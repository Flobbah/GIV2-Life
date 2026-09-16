#include "\life_server\script_macros.hpp"
/*
    File: fn_removeGang.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Removes gang from database
*/
private ["_group","_groupID"];
_group = param [0,grpNull,[grpNull]];
if (isNull _group) exitWith {};
_groupID = _group getVariable ["gang_id",-1];
if (!(_groupID isEqualType 0) || {_groupID isEqualTo -1}) exitWith {}; //Sicherheitsphase 0.2: gang_id kann jeder Client setzen, nur Zahlen (SQL)
private _caller = CALLER_OWNER; //Sicherheitsphase 0.1: Absender pruefen
if (!(_caller isEqualTo 2) && {([format ["SELECT id FROM gangs WHERE id='%1' AND owner='%2' AND active='1'", _groupID, ([_caller] call TON_fnc_callerInfo) param [0, "-"]], 2] call DB_fnc_asyncCall) isEqualTo []} && {[_caller, "TON_fnc_removeGang", "sender is not the gang owner"] call TON_fnc_denyCaller}) exitWith {};
_group setVariable ["gang_owner",nil,true];
[format ["UPDATE gangs SET active='0' WHERE id='%1'",_groupID],1] call DB_fnc_asyncCall;
[_group] remoteExecCall ["life_fnc_gangDisbanded",(units _group)];
waitUntil {(units _group) isEqualTo []};
deleteGroup _group;