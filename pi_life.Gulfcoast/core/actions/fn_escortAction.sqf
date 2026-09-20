#include "..\..\script_macros.hpp"
/*
    File: fn_escortAction.sqf
    Author: Bryan "Tonic" Boardwine
    Description: Attaches the desired person(_unit) to the player(player) and "escorts them".
*/
private ["_unit"];
_unit = [_this,0,objNull,[objNull]] call BIS_fnc_param;
if (!isNull(player getVariable ["escortingPlayer",objNull])) exitWith {};
if (isNil "_unit" || isNull _unit || !isPlayer _unit) exitWith {};
if (!(SIDE_OF(_unit) in [civilian,independent])) exitWith {};
if (player distance _unit > 3) exitWith {};
_unit attachTo [player,[0.1,1.1,0]];
player setVariable ["escortingPlayer",_unit];
player setVariable ["isEscorting",true];
//Sicherheitsprüfung #7: den Zustand setzt der Server (TON_fnc_custody), nicht der Client
[_unit,"escort"] remoteExecCall ["TON_fnc_custody",RSERV];
player reveal _unit;
[_unit] spawn {
    _unit = _this select 0;
    waitUntil {(!(_unit getVariable ["Escorting",false]))};
    player setVariable ["escortingPlayer",nil];
    player setVariable ["isEscorting",false];
};