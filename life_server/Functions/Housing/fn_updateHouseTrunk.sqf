#include "\life_server\script_macros.hpp"
/*
    File : fn_updateHouseTrunk.sqf
    Author: NiiRoZz
    Description:
    Update inventory "y" in container
*/
private ["_house"];
_container = [_this,0,objNull,[objNull]] call BIS_fnc_param;
if (isNull _container) exitWith {};
private _caller = CALLER_OWNER; //Sicherheitsphase 0.1: Absender pruefen
if (!(_caller isEqualTo 2) && {((([_caller] call TON_fnc_callerInfo) param [1, objNull]) distance _container) > 60} && {[_caller, "TON_fnc_updateHouseTrunk", "container too far from the sender"] call TON_fnc_denyCaller}) exitWith {};
_trunkData = _container getVariable ["Trunk",[[],0]];
_containerID = [_container, "container_id", -1] call TON_fnc_serverGet; //Sicherheitsphase 0.2: nicht die faelschbare Objekt-Variable (SQL)
if (_containerID isEqualTo -1) exitWith {}; //Dafuq?
_trunkData = [_trunkData] call DB_fnc_mresArray;
_query = format ["UPDATE containers SET inventory='%1' WHERE id='%2'",_trunkData,_containerID];
[_query,1] call DB_fnc_asyncCall;
