#include "..\..\script_macros.hpp"
/*
    File: fn_adminGetID.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Fetches the selected ID of the player.
    Used by in-game admins to issue bans/kicks.
    https://community.bistudio.com/wiki/Multiplayer_Server_Commands
*/
private _unit = [] call life_fnc_adminTarget;
if (isNull _unit) exitWith {[ localize "STR_ANOTF_NoTarget",true,"fast"] call life_fnc_notification_system;};
[_unit,player] remoteExecCall ["TON_fnc_getID",RSERV];
