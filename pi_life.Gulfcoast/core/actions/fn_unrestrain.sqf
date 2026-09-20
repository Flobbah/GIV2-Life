#include "..\..\script_macros.hpp"
/*
    File: fn_unrestrain.sqf
    Author:
    Description:
*/
private ["_unit"];
_unit = param [0,objNull,[objNull]];
if (isNull _unit || !(_unit getVariable ["restrained",false])) exitWith {}; //Error check?
//Sicherheitsprüfung #7: den Zustand setzt der Server (TON_fnc_custody), nicht der Client
[_unit,"release"] remoteExecCall ["TON_fnc_custody",RSERV];
detach _unit;
["life_fnc_broadcast",[0,"STR_NOTF_Unrestrain",true,[_unit getVariable ["realname",name _unit], profileName]],west] call life_fnc_relaySend;