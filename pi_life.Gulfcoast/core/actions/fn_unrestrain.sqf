#include "..\..\script_macros.hpp"
/*
    File: fn_unrestrain.sqf
    Author:
    Description:
*/
private ["_unit"];
_unit = param [0,objNull,[objNull]];
if (isNull _unit || !(_unit getVariable ["restrained",false])) exitWith {}; //Error check?
_unit setVariable ["restrained",false,true];
_unit setVariable ["Escorting",false,true];
_unit setVariable ["transporting",false,true];
detach _unit;
["life_fnc_broadcast",[0,"STR_NOTF_Unrestrain",true,[_unit getVariable ["realname",name _unit], profileName]],west] call life_fnc_relaySend;