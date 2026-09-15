#include "..\..\script_macros.hpp"
/*
    File: fn_navStop.sqf
    Description:
    Beendet die aktive Navigation: Route und HUD-Anzeige entfernen, eigene Navigations-Aufgabe
    loeschen. Die Aufgabe eines Lieferauftrags bleibt bestehen (verwaltet fn_getDPMission/fn_dpFinish).
    Parameter:
        0: BOOL - true = ohne Meldung (z. B. beim Wechsel auf ein neues Ziel)
*/
params [["_silent",false,[false]]];
if (!hasInterface) exitWith {};
private _wasActive = missionNamespace getVariable ["life_nav_active",false];
life_nav_active = false;
life_nav_path = [];
life_nav_label = "";
life_nav_isDelivery = false;
life_nav_routeLen = 0;
life_nav_calcId = (missionNamespace getVariable ["life_nav_calcId",0]) + 1;
if (!isNil "life_nav_task" && {!isNull life_nav_task}) then {
    player removeSimpleTask life_nav_task;
    life_nav_task = taskNull;
};
disableSerialization;
[false] call life_fnc_navMiniMap;
private _ctrl = LIFEctrl(30);
if (!isNull _ctrl) then {_ctrl ctrlSetStructuredText parseText "";};
if (_wasActive && !_silent) then {
    [ localize "STR_NAV_Stopped",false,"fast"] call life_fnc_notification_system;
};
