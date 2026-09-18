#include "..\..\script_macros.hpp"
/*
    File: fn_p_showPage.sqf
    Description:
    Blendet im Spielermenue (Telefon, Dialog 2001) eine Seite ein und alle anderen aus.
    Seiten: "home" (App-Kacheln), "inventory", "licenses", "money".
    Der Weg dorthin landet im Telefon-Verlauf (life_phone_stack), damit der Zurueck-Knopf unten
    weiss, wohin - egal wie tief man sich durchgeklickt hat.

    Parameter:
        0: STRING - Name der Seite (Standard: "home")
        1: BOOL   - in den Verlauf aufnehmen (Standard: true; der Zurueck-Knopf selbst setzt false)
*/
params [["_page","home",[""]], ["_remember",true,[true]]];
if (isNull (findDisplay 2001)) exitWith {};
disableSerialization;
private _pages = [
    ["home",      [2030,2031,2009,2015,2032,2033,2034,2013,2035,2036,2011,2012,2021,2047,2048,2049,2054]],
    ["inventory", [2040,2041,2005,2043,2010,2044,2023,2045,2002,2046,2070,2071,2072]],
    ["licenses",  [2050,2051,2053]],
    ["money",     [2060,2061,2063,2064,2018,2065,2022,2001]]
];
if !(_page in (_pages apply {_x select 0})) then {_page = "home";};
private _current = missionNamespace getVariable ["life_pmenu_page","home"];
if (_page isEqualTo "home") then {
    missionNamespace setVariable ["life_phone_stack", []]; //Startseite ist die Wurzel
} else {
    if (_remember && {!(_current isEqualTo _page)}) then {
        private _stack = missionNamespace getVariable ["life_phone_stack", []];
        _stack pushBack ["page", _current];
        missionNamespace setVariable ["life_phone_stack", _stack];
    };
};
{
    _x params ["_name","_idcs"];
    private _show = _name isEqualTo _page;
    {ctrlShow [_x,_show];} forEach _idcs;
} forEach _pages;
life_pmenu_page = _page;
if (_page isEqualTo "home") then {
    // Gang nur fuer Zivilisten, Fahndungsliste nur fuer Polizei, Admin-App nur ab Adminlevel 1
    ctrlShow [2011, life_side isEqualTo civilian];
    ctrlShow [2012, life_side isEqualTo west];
    ctrlShow [2021, FETCH_CONST(life_adminlevel) >= 1];
};
