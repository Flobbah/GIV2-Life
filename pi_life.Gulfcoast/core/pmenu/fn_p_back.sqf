#include "..\..\script_macros.hpp"
/*
    File: fn_p_back.sqf
    Description:
    Zurueck-Knopf des Telefons: eine Ebene zurueck, egal ob das eine Seite im Spielermenue oder eine
    eigene App war. Ist nichts mehr da, verhaelt er sich wie der Home-Knopf.
*/
private _stack = missionNamespace getVariable ["life_phone_stack", []];
if (_stack isEqualTo []) exitWith {[] call life_fnc_p_home};
private _entry = _stack deleteAt ((count _stack) - 1);
missionNamespace setVariable ["life_phone_stack", _stack];
_entry params [["_kind",""], ["_value",""]];
if (_kind isEqualTo "page") exitWith {
    if (!isNull (findDisplay 2001)) exitWith {[_value, false] call life_fnc_p_showPage};
    missionNamespace setVariable ["life_phone_dialog",""];
    closeDialog 0;
    [_value] spawn {
        uiSleep 0.05;
        if !(createDialog "playerSettings") exitWith {};
        [_this select 0, false] call life_fnc_p_showPage;
        [] call life_fnc_p_updateMenu;
    };
};
missionNamespace setVariable ["life_phone_dialog", _value];
closeDialog 0;
[_value] spawn {
    uiSleep 0.05;
    (_this select 0) call life_fnc_p_openDialog;
};
