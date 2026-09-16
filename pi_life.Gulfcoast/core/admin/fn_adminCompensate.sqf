#include "..\..\script_macros.hpp"
/*
    File: fn_adminCompensate.sqf
    Author: ColinM9991 (original), extended
    Description:
    Admin compensation (dialog 9920).
    Parameter 0 (mode):
        -1 = initialise the dialog (called from onLoad)
         0 = give the amount to yourself
         1 = give the amount to the player selected in the admin menu (life_admin_target)
    The account (bank / cash) is chosen in combo 9923, the limit is
    Life_Settings >> admin_compensateLimit. Modes 0 and 1 must be spawned (guiMessage).
*/
params [["_mode",0,[0]]];
disableSerialization;
if (FETCH_CONST(life_adminlevel) < 2) exitWith {closeDialog 0; [ localize "STR_ANOTF_ErrorLevel",true,"fast"] call life_fnc_notification_system;};
private _display = findDisplay 9920;
if (isNull _display) exitWith {};
private _limit = LIFE_SETTINGS(getNumber,"admin_compensateLimit");
private _target = missionNamespace getVariable ["life_admin_target",objNull];
private _targetName = if (isNull _target) then {"-"} else {_target getVariable ["realname",name _target]};
if (_mode isEqualTo -1) exitWith {
    (_display displayCtrl 9921) ctrlSetStructuredText parseText format [localize "STR_Admin_CompInfo",[_limit] call life_fnc_numberText,_targetName];
    private _combo = _display displayCtrl 9923;
    lbClear _combo;
    _combo lbAdd localize "STR_Admin_CompAccountBank";
    _combo lbAdd localize "STR_Admin_CompAccountCash";
    _combo lbSetCurSel 0;
    (_display displayCtrl 9924) ctrlEnable !(isNull _target);
};
private _value = parseNumber (ctrlText 9922);
if (_value <= 0) exitWith {[ localize "STR_ANOTF_Amount",true,"fast"] call life_fnc_notification_system;};
if (_value > _limit) exitWith {[ format [localize "STR_ANOTF_Fail",[_limit] call life_fnc_numberText],true,"fast"] call life_fnc_notification_system;};
_value = round _value;
private _toBank = (lbCurSel 9923) isEqualTo 0;
private _accountName = localize (["STR_Admin_CompAccountCash","STR_Admin_CompAccountBank"] select _toBank);
private _valueText = [_value] call life_fnc_numberText;
private _logTarget = "";
if (_mode isEqualTo 1) then {
    if (isNull _target) exitWith {[ localize "STR_ANOTF_NoTarget",true,"fast"] call life_fnc_notification_system;};
    private _action = [
        format [localize "STR_ANOTF_CompTargetWarn",_targetName,_valueText,_accountName],
        localize "STR_Admin_Compensate",
        localize "STR_Global_Yes",
        localize "STR_Global_No"
    ] call BIS_fnc_guiMessage;
    if (!_action) exitWith {[ localize "STR_NOTF_ActionCancel",true,"fast"] call life_fnc_notification_system; closeDialog 0;};
    if (ECONOMY_MODE >= 1) then {
        ["compensate", _value, _target, _toBank] remoteExecCall ["TON_fnc_econBank",RSERV]; //Geld-Umbau Schritt 2: bucht der Server, Rueckmeldung kommt vom Server
    } else {
        ["life_fnc_adminCompReceive",[_value,_toBank,profileName],_target] call life_fnc_relaySend;
        [ format [localize "STR_ANOTF_CompSent",_targetName,_valueText,_accountName],false,"fast"] call life_fnc_notification_system;
    };
    _logTarget = format ["%1 (%2)",_targetName,getPlayerUID _target];
    closeDialog 0;
} else {
    private _action = [
        format [localize "STR_ANOTF_CompWarn",_valueText],
        localize "STR_Admin_Compensate",
        localize "STR_Global_Yes",
        localize "STR_Global_No"
    ] call BIS_fnc_guiMessage;
    if (!_action) exitWith {[ localize "STR_NOTF_ActionCancel",true,"fast"] call life_fnc_notification_system; closeDialog 0;};
    if (ECONOMY_MODE >= 1) then {
        ["compensate", _value, objNull, _toBank] remoteExecCall ["TON_fnc_econBank",RSERV]; //Geld-Umbau Schritt 2: bucht der Server, Rueckmeldung kommt vom Server
    } else {
        if (_toBank) then {
            BANK = BANK + _value;
            [1] call SOCK_fnc_updatePartial;
        } else {
            CASH = CASH + _value;
            [0] call SOCK_fnc_updatePartial;
        };
        [] call life_fnc_hudUpdate;
        [ format [localize "STR_ANOTF_CompSelf",_valueText,_accountName],true,"fast"] call life_fnc_notification_system;
    };
    _logTarget = "self";
    closeDialog 0;
};
if (!(_logTarget isEqualTo "") && {ECONOMY_MODE isEqualTo 0} && {LIFE_SETTINGS(getNumber,"player_moneyLog") isEqualTo 1}) then { //ab Modus 1 protokolliert der Server
    money_log = format ["[ADMIN COMPENSATE] %1 (%2) -> %3: $%4 (%5)",profileName,getPlayerUID player,_logTarget,_valueText,_accountName];
    [money_log] remoteExecCall ["TON_fnc_clientLog",RSERV];
};
