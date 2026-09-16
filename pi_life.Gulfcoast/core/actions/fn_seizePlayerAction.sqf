#include "..\..\script_macros.hpp"
/*
    File: fn_seizePlayerAction.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Starts the seize process..
    Based off Tonic's fn_searchAction.sqf
*/
params [
    ["_unit",objNull,[objNull]]
];
if (isNull _unit) exitWith {};
sleep 2;
if (player distance _unit > 5 || !alive player || !alive _unit) exitWith {[ localize "STR_NOTF_CannotSeizePerson",true,"fast"] call life_fnc_notification_system;};
["life_fnc_seizeClient",[player],_unit] call life_fnc_relaySend;
life_action_inUse = false;