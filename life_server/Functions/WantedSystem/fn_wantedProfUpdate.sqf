#include "\life_server\script_macros.hpp"
/*
    File: fn_wantedProfUpdate.sqf
    Author: [midgetgrimm]
    Persistence by: ColinM
    Description:
    Updates name of player if they change profiles
*/
private ["_query","_tickTime","_wantedCheck","_wantedQuery"];
params [
    ["_uid","",[""]],
    ["_name","",[""]]
];
//Bad data check
if (_uid isEqualTo "" ||  {_name isEqualTo ""}) exitWith {};
//Sicherheitsphase 0.1: nur der eigene Name, fuer SQL maskiert
if !([CALLER_OWNER, objNull, _uid, sideUnknown, "life_fnc_wantedProfUpdate"] call TON_fnc_checkCaller) exitWith {};
_name = [_name] call DB_fnc_mresString;
_wantedCheck = format ["SELECT wantedName FROM wanted WHERE wantedID='%1'",_uid];
_wantedQuery = [_wantedCheck,2] call DB_fnc_asyncCall;
if (count _wantedQuery isEqualTo 0) exitWith {};
if !(_name isEqualTo (_wantedQuery select 0)) then {
    _query = format ["UPDATE wanted SET wantedName='%1' WHERE wantedID='%2'",_name,_uid];
    [_query,2] call DB_fnc_asyncCall;
};
