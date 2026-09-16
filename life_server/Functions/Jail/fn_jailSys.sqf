#include "\life_server\script_macros.hpp"
/*
    File: fn_jailSys.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    I forget?
*/
private ["_unit","_bad","_id","_ret"];
_unit = [_this,0,objNull,[objNull]] call BIS_fnc_param;
if (isNull _unit) exitWith {};
if !([CALLER_OWNER, _unit, "", sideUnknown, "life_fnc_jailSys"] call TON_fnc_checkCaller) exitWith {};
_bad = [_this,1,false,[false]] call BIS_fnc_param;
_id = owner _unit;
_ret = [_unit] call life_fnc_wantedPerson;
//Geld-Umbau Schritt 2: Kaution serverseitig merken (Betrag, ab wann zahlbar, bis wann gueltig), wie in life_fnc_jailMe berechnet
if (ECONOMY_MODE >= 1) then {
    private _bail = if (_ret isEqualTo []) then {1500} else {_ret param [2, 1500]};
    if (_bail isEqualType "") then {_bail = parseNumber _bail};
    private _jailTime = if (_ret isEqualTo []) then {600} else {(LIFE_SETTINGS(getNumber,"jail_timeMultiplier") * 60) + ([0, 900] select _bad)};
    [getPlayerUID _unit, "bail", [round _bail, diag_tickTime + ([300, 600] select _bad), diag_tickTime + _jailTime + 120]] call TON_fnc_serverSet;
};
[_ret,_bad] remoteExec ["life_fnc_jailMe",_id];