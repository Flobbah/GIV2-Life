#include "\life_server\script_macros.hpp"
/*
    File: fn_pickupAction.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Validates that the cash is not a lie
*/
params [
    ["_obj",objNull,[objNull]],
    ["_client",objNull,[objNull]],
    ["_cash",false,[true]]
];
if (isNull _obj || {isNull _client}) exitWith {systemChat "Obj or client is null?";}; //No.
private _caller = CALLER_OWNER; //Sicherheitsphase 0.1: Absender pruefen
if !([_caller, _client, "", sideUnknown, "TON_fnc_pickupAction"] call TON_fnc_checkCaller) exitWith {};
if (!(_caller isEqualTo 2) && {(_obj distance _client) > 10} && {[_caller, "TON_fnc_pickupAction", "object too far from the sender"] call TON_fnc_denyCaller}) exitWith {};
if (_cash && {ECONOMY_MODE >= 1}) exitWith {
    //Geld-Umbau Schritt 2: gezahlt wird der Wert, den der Server beim Erzeugen des Buendels gespeichert hat
    if !((typeOf _obj) isEqualTo "Land_Money_F") exitWith {};
    private _value = [_obj, "money", -1] call TON_fnc_serverGet;
    private _claimed = (_obj getVariable ["item", []]) param [1, "?"];
    [_obj, "money"] call TON_fnc_serverSet;
    deleteVehicle _obj;
    if (_value < 0) exitWith {
        diag_log format ["[ECONOMY] money bundle without server value picked up by %1 (%2), claimed %3, nothing paid", name _client, getPlayerUID _client, _claimed];
    };
    if ([getPlayerUID _client, "cash", _value, "cash_pickup"] call TON_fnc_moneyChange) then {
        ["STR_NOTF_PickedMoney", [[_value] call life_fnc_numberText]] remoteExecCall ["life_fnc_econResult", owner _client];
    };
};
//Geld-Umbau Schritt 3: Beweismittel (illegale Gegenstaende, die die Polizei aufhebt) zahlt der Server
private _itemClass = (_obj getVariable ["item", []]) param [0, "", [""]];
private _evidence = !_cash && {ECONOMY_MODE >= 1} && {(AUTH_SIDE(getPlayerUID _client)) isEqualTo west} && {isClass (missionConfigFile >> "VirtualItems" >> _itemClass)} && {(getNumber (missionConfigFile >> "VirtualItems" >> _itemClass >> "illegal")) isEqualTo 1};
if (_evidence) exitWith {
    if (_obj getVariable ["inUse", false]) exitWith {};
    _obj setVariable ["inUse", true, true];
    private _value = round ((getNumber (missionConfigFile >> "VirtualItems" >> _itemClass >> "sellPrice")) / 2);
    deleteVehicle _obj;
    private _uid = getPlayerUID _client;
    if (_value > 0 && {[_uid, "police", _value, name _client] call TON_fnc_econEarnCheck} && {[_uid, "bank", _value, "evidence", "", _itemClass] call TON_fnc_moneyChange}) then {
        ["STR_NOTF_PickedEvidence", [getText (missionConfigFile >> "VirtualItems" >> _itemClass >> "displayName"), [_value] call life_fnc_numberText]] remoteExecCall ["life_fnc_econResult", owner _client];
    };
};
if (!(_obj getVariable ["inUse",false])) exitWith {
    _client = owner _client;
    _obj setVariable ["inUse",true,true];
    if (_cash) then {
        _obj remoteExecCall ["life_fnc_pickupMoney",_client];
    } else {
        _obj remoteExecCall ["life_fnc_pickupItem",_client];
    };
};