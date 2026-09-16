#include "\life_server\script_macros.hpp"
/*
    File: fn_houseGarage.sqf
    Author: BoGuu
    Description:
    Database functionality for house garages.
*/
params [
    ["_uid","",[""]],
    ["_house",objNull,[objNull]],
    ["_mode",-1,[0]]
];
if (_uid isEqualTo "") exitWith {};
if (isNull _house) exitWith {};
if (_mode isEqualTo -1) exitWith {};
private _caller = CALLER_OWNER; //Sicherheitsphase 0.1: Absender pruefen
if !([_caller, objNull, _uid, sideUnknown, "TON_fnc_houseGarage"] call TON_fnc_checkCaller) exitWith {};
if (!(_caller isEqualTo 2) && {!((([_caller] call TON_fnc_callerInfo) param [0, ""]) isEqualTo (([_house, "house_owner", []] call TON_fnc_serverGet) param [0, "-"]))} && {[_caller, "TON_fnc_houseGarage", "sender does not own the house"] call TON_fnc_denyCaller}) exitWith {};
private _housePos = getPosATL _house;
//Geld-Umbau Schritt 2: Kauf/Verkauf der Garage bucht der Server; ob eine Garage da ist, sagt die Datenbank
if (ECONOMY_MODE >= 1 && {!(_caller isEqualTo 2)}) exitWith {
    private _has = ([format ["SELECT garage FROM houses WHERE pid='%1' AND pos='%2' AND owned='1'", _uid, _housePos], 2] call DB_fnc_asyncCall) param [0, -1];
    if (_has isEqualType "") then {_has = parseNumber _has};
    if (_mode isEqualTo 0) then {
        if (_has isEqualTo 1) exitWith {["STR_Garage_alreadyOwned", [], true] remoteExecCall ["life_fnc_econResult", _caller]};
        if !([_uid, "bank", -LIFE_SETTINGS(getNumber,"houseGarage_buyPrice"), "house_garage_buy", "", typeOf _house] call TON_fnc_moneyChange) exitWith {
            ["STR_House_NotEnough", [], true] remoteExecCall ["life_fnc_econResult", _caller];
        };
        [format ["UPDATE houses SET garage='1' WHERE pid='%1' AND pos='%2'", _uid, _housePos], 1] call DB_fnc_asyncCall;
        _house setVariable ["garageBought", true, true];
    } else {
        if !(_has isEqualTo 1) exitWith {["STR_Garage_NotOwned", [], true] remoteExecCall ["life_fnc_econResult", _caller]};
        [format ["UPDATE houses SET garage='0' WHERE pid='%1' AND pos='%2'", _uid, _housePos], 1] call DB_fnc_asyncCall;
        [_uid, "bank", LIFE_SETTINGS(getNumber,"houseGarage_sellPrice"), "house_garage_sell", "", typeOf _house] call TON_fnc_moneyChange;
        _house setVariable ["garageBought", false, true];
    };
};
private "_query";
if (_mode isEqualTo 0) then {
    _query = format ["UPDATE houses SET garage='1' WHERE pid='%1' AND pos='%2'",_uid,_housePos];
} else {
    _query = format ["UPDATE houses SET garage='0' WHERE pid='%1' AND pos='%2'",_uid,_housePos];
};
if (EXTDB_SETTING(getNumber,"DebugMode") isEqualTo 1) then {
    diag_log format ["Query: %1",_query];
};
[_query,1] call DB_fnc_asyncCall;