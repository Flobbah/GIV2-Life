#include "..\..\script_macros.hpp"
/*
    File: fn_p_openApp.sqf
    Description:
    Oeffnet eine App des Telefons (einen eigenen Dialog im gleichen Rahmen) und merkt sich, woher man
    kam. Der Zurueck-Knopf unten bringt einen genau dorthin zurueck.
    Parameter:
        0: STRING - Klassenname des Dialogs, z. B. "Life_Skills"
*/
params [["_class","",[""]]];
if (_class isEqualTo "") exitWith {};
private _stack = missionNamespace getVariable ["life_phone_stack", []];
if (!isNull (findDisplay 2001)) then {
    _stack pushBack ["page", missionNamespace getVariable ["life_pmenu_page","home"]];
} else {
    private _from = missionNamespace getVariable ["life_phone_dialog",""];
    if !(_from isEqualTo "") then {_stack pushBack ["dialog", _from]};
};
missionNamespace setVariable ["life_phone_stack", _stack];
missionNamespace setVariable ["life_phone_dialog", _class];
closeDialog 0;
[_class] spawn {
    uiSleep 0.05; //ein Dialog laesst sich nicht im selben Moment schliessen und oeffnen
    (_this select 0) call life_fnc_p_openDialog;
};
