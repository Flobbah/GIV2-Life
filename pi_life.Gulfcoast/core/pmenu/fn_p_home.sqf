#include "..\..\script_macros.hpp"
/*
    File: fn_p_home.sqf
    Description:
    Home-Knopf des Telefons: Auf der Startseite schliesst er das Menue, sonst fuehrt er dorthin -
    aus einer App heraus also zurueck ins Spielermenue. Der Verlauf wird dabei geleert.
*/
missionNamespace setVariable ["life_phone_stack", []];
if (!isNull (findDisplay 2001)) exitWith {
    if ((missionNamespace getVariable ["life_pmenu_page","home"]) isEqualTo "home") exitWith {closeDialog 0};
    ["home", false] call life_fnc_p_showPage;
};
missionNamespace setVariable ["life_phone_dialog",""];
closeDialog 0;
[] spawn {
    uiSleep 0.05;
    if !(createDialog "playerSettings") exitWith {};
    ["home", false] call life_fnc_p_showPage;
    [] call life_fnc_p_updateMenu;
};
