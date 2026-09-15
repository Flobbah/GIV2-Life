#include "..\..\script_macros.hpp"
/*
    File: fn_markerFilterApply.sqf
    Description:
    Ordnet alle Karten-Marker den Kategorien aus CfgMarkerFilter zu (Namensmuster, "*" am Ende =
    beginnt mit) und blendet die im Profil gespeicherten Kategorien lokal aus.
    Ergebnis in life_markerFilter_map: [[Kategorie, Anzeigename-Key, [Marker...]], ...]
    Parameter:
        0: BOOL - true = Zuordnung neu aufbauen (Standard: nur beim ersten Aufruf)
*/
params [["_rebuild",false,[false]]];
if (!hasInterface) exitWith {};
if (_rebuild || {isNil "life_markerFilter_map"}) then {
    private _all = allMapMarkers;
    private _map = [];
    {
        private _patterns = (getArray (_x >> "markers")) apply {toLower _x};
        private _list = [];
        {
            private _marker = _x;
            private _name = toLower _marker;
            private _hit = false;
            {
                private _pat = _x;
                if ((_pat select [(count _pat) - 1, 1]) isEqualTo "*") then {
                    if ((_name find (_pat select [0, (count _pat) - 1])) isEqualTo 0) exitWith {_hit = true;};
                } else {
                    if (_name isEqualTo _pat) exitWith {_hit = true;};
                };
            } forEach _patterns;
            if (_hit) then {_list pushBack _marker;};
        } forEach _all;
        _map pushBack [configName _x, getText (_x >> "displayName"), _list];
    } forEach ("true" configClasses (missionConfigFile >> "CfgMarkerFilter"));
    life_markerFilter_map = _map;
};
private _hidden = profileNamespace getVariable ["life_markerFilter_hidden",[]];
if !(_hidden isEqualType []) then {_hidden = [];};
{
    _x params ["_cat","","_markers"];
    private _alpha = [1,0] select (_cat in _hidden);
    {_x setMarkerAlphaLocal _alpha;} forEach _markers;
} forEach life_markerFilter_map;
