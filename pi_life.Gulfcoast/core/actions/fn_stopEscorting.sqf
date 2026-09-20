#include "..\..\script_macros.hpp"
/*
    File: fn_stopEscorting.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Detaches player(_unit) from the Escorter(player) and sets them back down.
*/
private _unit = player getVariable ["escortingPlayer",objNull];
if (isNull _unit) then {_unit = cursorTarget;}; //Emergency fallback.
if (isNull _unit) exitWith {}; //Target not found even after using cursorTarget.
if (!(_unit getVariable ["Escorting",false])) exitWith {}; //He's not being Escorted.
detach _unit;
//Sicherheitsprüfung #7: den Zustand setzt der Server (TON_fnc_custody), nicht der Client
[_unit,"stopEscort"] remoteExecCall ["TON_fnc_custody",RSERV];
player setVariable ["isEscorting",false];
