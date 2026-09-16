#include "\life_server\script_macros.hpp"
/*
    File: fn_wantedCrimes.sqf
    Author: ColinM
    Assistance by: Paronity
    Stress Tests by: Midgetgrimm
    Description:
    Grabs a list of crimes committed by a person.
*/
disableSerialization;
params [
    ["_ret",objNull,[objNull]],
    ["_criminal",[],[]]
];
//Sicherheitsphase 0.1: nur Polizei, UID muss eine Steam-ID sein (sonst SQL-Injection moeglich)
if (isNull _ret) exitWith {};
private _criminalUid = if (_criminal isEqualType []) then {_criminal param [0, ""]} else {""};
if (!(_criminalUid isEqualType "") || {!(_criminalUid regexMatch "\d{17}")}) exitWith {};
private _caller = CALLER_OWNER;
if !([_caller, _ret, "", sideUnknown, "life_fnc_wantedCrimes"] call TON_fnc_checkCaller) exitWith {};
if (!(_caller isEqualTo 2) && {!((AUTH_SIDE(getPlayerUID _ret)) isEqualTo west)} && {[_caller, "life_fnc_wantedCrimes", "sender is not a cop"] call TON_fnc_denyCaller}) exitWith {};
private _query = format ["SELECT wantedCrimes, wantedBounty FROM wanted WHERE active='1' AND wantedID='%1'",_criminal select 0];
private _queryResult = [_query,2] call DB_fnc_asyncCall;
_ret = owner _ret;
private _type = [_queryResult select 0] call DB_fnc_mresToArray;
if (_type isEqualType "") then {_type = call compile format ["%1", _type];};
private _crimesArr = [];
{
    private _str = format ["STR_Crime_%1", _x];
    _crimesArr pushBack _str;
    false
} count _type;
_queryResult set[0,_crimesArr];
[_queryResult] remoteExec ["life_fnc_wantedInfo",_ret];
