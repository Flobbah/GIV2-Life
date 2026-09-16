#include "..\..\script_macros.hpp"
/*
    File: fn_robAction.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Starts the robbing process?
*/
private ["_target"];
_target = cursorObject;
//Error checks
if (isNull _target) exitWith {};
if (!isPlayer _target) exitWith {};
if (_target getVariable ["robbed",false]) exitWith {};
if (ECONOMY_MODE >= 1) then {["rob", _target] remoteExecCall ["TON_fnc_econPlayer",RSERV]} else {["life_fnc_robPerson",[player],_target] call life_fnc_relaySend}; //Geld-Umbau Schritt 2
_target setVariable ["robbed",true,true];
