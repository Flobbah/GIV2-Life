#include "..\..\script_macros.hpp"
/*
    File: fn_navMenuFilter.sqf
    Description:
    Fuellt die Zielliste der Telefon-App "Navi" (Dialog 2970) aus life_nav_list, gefiltert nach
    dem Suchtext (Feld 2975, Gross-/Kleinschreibung egal, Teilstring). Wird beim Oeffnen und bei
    jedem Tastendruck im Suchfeld aufgerufen. Die Listenzeile speichert den Index in life_nav_list.
*/
disableSerialization;
private _display = findDisplay 2970;
if (isNull _display) exitWith {};
private _list = _display displayCtrl 2972;
private _needle = toLower (ctrlText (_display displayCtrl 2975));
private _me = getPosATL player;
lbClear _list;
{
    _x params ["_name","_pos"];
    if (_needle isEqualTo "" || {(toLower _name) find _needle > -1}) then {
        private _idx = _list lbAdd format ["%1  (%2)", _name, [_me distance2D _pos] call life_fnc_navDistText];
        _list lbSetValue [_idx, _forEachIndex];
    };
} forEach (missionNamespace getVariable ["life_nav_list",[]]);
if ((lbSize _list) isEqualTo 0) then {
    private _idx = _list lbAdd (localize "STR_NAV_NoMatch");
    _list lbSetValue [_idx, -1];
    _list lbSetColor [_idx, [0.6, 0.6, 0.6, 1]];
} else {
    _list lbSetCurSel 0;
};
