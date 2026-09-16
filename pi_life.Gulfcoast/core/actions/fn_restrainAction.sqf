#include "..\..\script_macros.hpp"
/*
    File: fn_restrainAction.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Restrains the target.
*/
private ["_unit"];
_unit = cursorObject;
if (isNull _unit) exitWith {}; //Not valid
if (player distance _unit > 3) exitWith {};
if (_unit getVariable "restrained") exitWith {};
if (SIDE_OF(_unit) isEqualTo west) exitWith {};
if (player isEqualTo _unit) exitWith {};
if (!isPlayer _unit) exitWith {};
//Broadcast!
_unit setVariable ["playerSurrender",false,true];
_unit setVariable ["restrained",true,true];
["life_fnc_restrain",[player],_unit] call life_fnc_relaySend;
["life_fnc_broadcast",[0,"STR_NOTF_Restrained",true,[_unit getVariable ["realname", name _unit], profileName]],west] call life_fnc_relaySend;
