#include "..\..\script_macros.hpp"
/*
    File: fn_navStart.sqf
    Description:
    Startet die Navigation zu einem Ziel: Route ueber Strassen berechnen (calculatePath),
    Wegpunkt-Aufgabe mit Zielmarkierung setzen, Entfernung im HUD anzeigen.
    Parameter:
        0: OBJECT oder ARRAY - Ziel (Objekt oder Position)
        1: STRING            - Anzeigename des Ziels
        2: BOOL              - true = gehoert zum Lieferauftrag (nutzt dessen Aufgabe, endet erst mit der Lieferung)
*/
params [["_target",objNull,[objNull,[]]],["_label","",[""]],["_isDelivery",false,[false]]];
if (!hasInterface) exitWith {};
private _pos = if (_target isEqualType objNull) then {
    if (isNull _target) exitWith {[]};
    getPosATL _target
} else {_target};
if (count _pos < 2) exitWith {};
if (life_nav_active) then {[true] call life_fnc_navStop;};
life_nav_active = true;
life_nav_target = [_pos select 0, _pos select 1, 0];
life_nav_label = _label;
life_nav_isDelivery = _isDelivery;
life_nav_path = [[getPosATL player select 0, getPosATL player select 1], [life_nav_target select 0, life_nav_target select 1]];
life_nav_routeLen = player distance2D life_nav_target;
//Aufgabe mit Ziel: beim Lieferauftrag die vorhandene Aufgabe, sonst eine eigene Navigations-Aufgabe
if (_isDelivery && {!isNil "life_cur_task"} && {!isNull life_cur_task}) then {
    life_cur_task setSimpleTaskDestination life_nav_target;
    player setCurrentTask life_cur_task;
} else {
    life_nav_task = player createSimpleTask ["life_navigation"];
    life_nav_task setSimpleTaskDescription [format [localize "STR_NAV_TaskDesc",_label],format [localize "STR_NAV_TaskTitle",_label],""];
    life_nav_task setSimpleTaskDestination life_nav_target;
    life_nav_task setTaskState "Assigned";
    player setCurrentTask life_nav_task;
};
[true] call life_fnc_navCalc;
[true] call life_fnc_navMiniMap; //Minikarte einblenden, auch ohne GPS
[ format [localize "STR_NAV_Started",_label],false,"fast"] call life_fnc_notification_system;
life_nav_loopId = (missionNamespace getVariable ["life_nav_loopId",0]) + 1;
[] spawn life_fnc_navLoop;
