#include "..\..\script_macros.hpp"
/*
    File: fn_dutyPoints.sqf
    Description:
    Liefert die Dienststellen einer uniformierten Seite: alle Spawnpunkte der Seite aus
    CfgSpawnPoints (ohne deren Rangbedingungen) plus extraMarkers aus CfgDuty.
    Parameter:
        0: SIDE - west (Polizei) oder independent (Rettungsdienst)
    Rueckgabe: ARRAY - [[Markername, Anzeigename], ...]
*/
params [["_side",west,[west]]];
private _class = switch (_side) do {case west: {"Cop"}; case independent: {"Medic"}; default {""};};
if (_class isEqualTo "") exitWith {[]};
private _sideName = ["independent","west"] select (_side isEqualTo west);
private _out = [];
{
    private _marker = getText (_x >> "spawnMarker");
    if (!(_marker isEqualTo "") && {!((getMarkerColor _marker) isEqualTo "")}) then {
        _out pushBack [_marker, getText (_x >> "displayName")];
    };
} forEach ("true" configClasses (missionConfigFile >> "CfgSpawnPoints" >> worldName >> _class));
{
    if (!((getMarkerColor _x) isEqualTo "")) then {
        private _name = markerText _x;
        if ((_name select [0,1]) isEqualTo "@") then {_name = localize (_name select [1]);};
        if (_name isEqualTo "") then {_name = _x;};
        _out pushBack [_x, _name];
    };
} forEach (getArray (missionConfigFile >> "CfgDuty" >> _sideName >> "extraMarkers"));
_out
