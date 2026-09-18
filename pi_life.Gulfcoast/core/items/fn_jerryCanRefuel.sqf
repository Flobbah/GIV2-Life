#include "..\..\script_macros.hpp"
/*
    File: fn_jerryCanRefuel.sqf
    Author: Bryan "Tonic" Boardwine
    Modified: Jesse "tkcjesse" Schultz
    Description:
    Refuels the empty fuel canister at a gas pump. Based off the jerryRefuel/lockpick scripts by Tonic.
*/
private ["_startPos","_badDistance","_title","_ui","_progress","_pgText","_cP","_action","_fuelCost"];
life_interrupted = false;
if (life_inv_fuelEmpty isEqualTo 0) exitWith {};
if (count(nearestObjects [player,["Land_FuelStation_Feed_F","Land_fs_feed_F"],3.5]) isEqualTo 0) exitWith { [ localize "STR_ISTR_Jerry_Distance",true,"fast"] call life_fnc_notification_system;};
if (life_action_inUse) exitWith {};
if !(isNull objectParent player) exitWith {};
if (player getVariable "restrained") exitWith {[ localize "STR_NOTF_isrestrained",true,"fast"] call life_fnc_notification_system;};
if (player getVariable "playerSurrender") exitWith {[ localize "STR_NOTF_surrender",true,"fast"] call life_fnc_notification_system;};
_fuelCost = LIFE_SETTINGS(getNumber,"fuelCan_refuel");
life_action_inUse = true;
_action = [
    format [localize "STR_ISTR_Jerry_PopUp",[_fuelCost] call life_fnc_numberText],
    localize "STR_ISTR_Jerry_StationPump",
    localize "STR_Global_Yes",
    localize "STR_Global_No"
] call BIS_fnc_guiMessage;
if (_action) then {
    if (CASH < _fuelCost) exitWith {[ localize "STR_NOTF_NotEnoughMoney",true,"fast"] call life_fnc_notification_system; life_action_inUse = false;};
    _startPos = getPos player;
    //Setup our progress bar.
    disableSerialization;
    "progressBar" cutRsc ["life_progress","PLAIN"];
    _title = localize "STR_ISTR_Jerry_Refuel";
    _ui = uiNamespace getVariable "life_progress";
    _progress = _ui displayCtrl 38201;
    _pgText = _ui displayCtrl 38202;
    _pgText ctrlSetText format ["%2 (1%1)...","%",_title];
    _progress progressSetPosition 0.01;
    _cP = 0.01;
    private _anim = "Acts_carFixingWheel";
    ["start",_anim] call life_fnc_actionAnim;
    for "_i" from 0 to 1 step 0 do {
        ["keep",_anim] call life_fnc_actionAnim;
        uiSleep 0.2;
        if (isNull _ui) then {
            "progressBar" cutRsc ["life_progress","PLAIN"];
            _ui = uiNamespace getVariable "life_progress";
            _progressBar = _ui displayCtrl 38201;
            _titleText = _ui displayCtrl 38202;
        };
        _cP = _cP + 0.01;
        _progress progressSetPosition _cP;
        _pgText ctrlSetText format ["%3 (%1%2)...",round(_cP * 100),"%",_title];
        if (_cP >= 1) exitWith {};
        if (!alive player) exitWith {life_action_inUse = false;};
        if (life_interrupted) exitWith {life_interrupted = false; life_action_inUse = false;};
    };
    //Kill the UI display and check for various states
    "progressBar" cutText ["","PLAIN"];
    ["stop"] call life_fnc_actionAnim;
    if (!alive player || life_istazed || life_isknocked) exitWith {life_action_inUse = false;};
    if (player getVariable ["restrained",false]) exitWith {life_action_inUse = false;};
    if (!isNil "_badDistance") exitWith {titleText[localize "STR_ISTR_Lock_TooFar","PLAIN"]; life_action_inUse = false;};
    if (life_interrupted) exitWith {life_interrupted = false; titleText[localize "STR_NOTF_ActionCancel","PLAIN"]; life_action_inUse = false;};
    if (INVENTORY_MODE isEqualTo 0 && {!([false,"fuelEmpty",1] call life_fnc_handleInv)}) exitWith {life_action_inUse = false;};
    if (INVENTORY_MODE >= 1 && {life_inv_fuelEmpty < 1}) exitWith {life_action_inUse = false;};
    life_action_inUse = false;
    if (ECONOMY_MODE >= 1) exitWith {
        //Geld-Umbau Schritt 2: die Gebuehr bucht der Server; ohne Zusage gibt es den leeren Kanister zurueck
        ["TON_fnc_econFee", ["jerryCan"], {
            //Inventar-Umbau: ab Modus 1 tauscht der Server leer gegen voll
            if (INVENTORY_MODE >= 1) exitWith {["TON_fnc_invConvert", ["fuelEmpty", "fuelFull"], {}, {}] call life_fnc_econRequest};
            [true,"fuelFull",1] call life_fnc_handleInv;
            [ localize "STR_ISTR_Jerry_Refueled",false,"fast"] call life_fnc_notification_system;
        }, {
            if (INVENTORY_MODE isEqualTo 0) then {[true,"fuelEmpty",1] call life_fnc_handleInv};
            [ localize "STR_NOTF_NotEnoughMoney",true,"fast"] call life_fnc_notification_system;
        }] call life_fnc_econRequest;
    };
    CASH = CASH - _fuelCost;
    if (INVENTORY_MODE >= 1) then {
        ["TON_fnc_invConvert", ["fuelEmpty", "fuelFull"], {}, {}] call life_fnc_econRequest;
    } else {
        [true,"fuelFull",1] call life_fnc_handleInv;
    };
    [ localize "STR_ISTR_Jerry_Refueled",false,"fast"] call life_fnc_notification_system;
} else {
    [ localize "STR_NOTF_ActionCancel",true,"fast"] call life_fnc_notification_system;
    closeDialog 0;
    life_action_inUse = false;
};