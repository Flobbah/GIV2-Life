#include "..\..\script_macros.hpp"
/*
    File: fn_dutyNearest.sqf
    Description:
    Naechste Dienststelle einer Seite zum Spieler.
    Parameter:
        0: SIDE - west oder independent
    Rueckgabe: ARRAY - [Markername, Anzeigename, Entfernung in Metern] oder [] ohne Dienststellen
*/
params [["_side",west,[west]]];
private _best = [];
{
    _x params ["_marker","_name"];
    private _dist = player distance2D (getMarkerPos _marker);
    if (_best isEqualTo [] || {_dist < (_best select 2)}) then {_best = [_marker,_name,_dist];};
} forEach ([_side] call life_fnc_dutyPoints);
_best
