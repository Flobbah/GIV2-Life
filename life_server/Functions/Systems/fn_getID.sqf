#include "\life_server\script_macros.hpp"
/*
    File: fn_getID.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Used for the admin menu returns the player ID for in-game bans/kicks.
    https://community.bistudio.com/wiki/Multiplayer_Server_Commands
*/
private ["_id","_ret"];
params [["_target", objNull, [objNull]], ["_admin", objNull, [objNull]]];
if (isNull _target || {isNull _admin}) exitWith {};
//Sicherheitsphase 0.1: nur fuer Admins (Level aus der Datenbank)
private _caller = CALLER_OWNER; //Sicherheitsphase 0.1: Absender pruefen
if !([_caller, _admin, "", sideUnknown, "TON_fnc_getID"] call TON_fnc_checkCaller) exitWith {};
if (!(_caller isEqualTo 2) && {isNull ([_caller, 1] call TON_fnc_adminManageAuth)}) exitWith {};
_id = owner _target;
_ret = owner _admin;
[_id] remoteExecCall ["life_fnc_adminID",_ret];

