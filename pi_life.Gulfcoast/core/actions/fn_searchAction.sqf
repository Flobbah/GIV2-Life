/*
    File: fn_searchAction.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Starts the searching process.
*/
params [
    ["_unit",objNull,[objNull]]
];
if (isNull _unit) exitWith {};
[ localize "STR_NOTF_Searching",false,"fast"] call life_fnc_notification_system;
sleep 2;
if (player distance _unit > 5 || !alive player || !alive _unit) exitWith {[ localize "STR_NOTF_CannotSearchPerson",true,"fast"] call life_fnc_notification_system;};
["life_fnc_searchClient",[player],_unit] call life_fnc_relaySend;
life_action_inUse = true;