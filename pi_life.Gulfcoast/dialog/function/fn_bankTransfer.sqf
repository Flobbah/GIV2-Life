#include "..\..\script_macros.hpp"
/*
    File: fn_bankTransfer.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Figure it out again.
*/
private ["_value","_unit","_tax"];
_value = parseNumber(ctrlText 2702);
_unit = call compile format ["%1",(lbData[2703,(lbCurSel 2703)])];
if (isNull _unit) exitWith {};
if ((lbCurSel 2703) isEqualTo -1) exitWith {[ localize "STR_ATM_NoneSelected",true,"fast"] call life_fnc_notification_system};
if (isNil "_unit") exitWith {[ localize "STR_ATM_DoesntExist",true,"fast"] call life_fnc_notification_system};
private _limit = LIFE_SETTINGS(getNumber,"bank_transactionLimit");
if (_value > _limit) exitWith {[ format [localize "STR_ATM_TransferMax",[_limit] call life_fnc_numberText],true,"fast"] call life_fnc_notification_system;};
if (_value < 0) exitWith {};
if (!([str(_value)] call TON_fnc_isnumber)) exitWith {[ localize "STR_ATM_notnumeric",true,"fast"] call life_fnc_notification_system};
if (_value > BANK) exitWith {[ localize "STR_ATM_NotEnoughFunds",true,"fast"] call life_fnc_notification_system};
_tax = _value * LIFE_SETTINGS(getNumber,"bank_transferTax");
if ((_value + _tax) > BANK) exitWith {[ format [localize "STR_ATM_SentMoneyFail",_value,_tax],true,"fast"] call life_fnc_notification_system};
if (ECONOMY_MODE >= 1) exitWith {if (_value > 0) then {["transfer", _value, _unit] remoteExecCall ["TON_fnc_econBank",RSERV]};}; //Geld-Umbau Schritt 2: bucht der Server
BANK = BANK - (_value + _tax);
["life_fnc_wireTransfer",[_value,profileName],_unit] call life_fnc_relaySend;
[] call life_fnc_atmMenu;
[1] call SOCK_fnc_updatePartial;
[ format [localize "STR_ATM_SentMoneySuccess",[_value] call life_fnc_numberText,_unit getVariable ["realname",name _unit],[_tax] call life_fnc_numberText],false,"fast"] call life_fnc_notification_system;
if (LIFE_SETTINGS(getNumber,"player_moneyLog") isEqualTo 1) then {
    if (LIFE_SETTINGS(getNumber,"battlEye_friendlyLogging") isEqualTo 1) then {
        money_log = format [localize "STR_DL_ML_transferredBank_BEF",_value,_unit getVariable ["realname",name _unit],[BANK] call life_fnc_numberText,[CASH] call life_fnc_numberText];
    } else {
        money_log = format [localize "STR_DL_ML_transferredBank",profileName,(getPlayerUID player),_value,_unit getVariable ["realname",name _unit],[BANK] call life_fnc_numberText,[CASH] call life_fnc_numberText];
    };
    [money_log] remoteExecCall ["TON_fnc_clientLog",RSERV];
};
