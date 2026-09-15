#include "..\..\script_macros.hpp"
/*
    File: fn_adminArsenal.sqf
    Description:
    Opens the full virtual arsenal for the admin. When it is closed the
    resulting gear is saved to the database like a normal shop purchase.
    Must be spawned (waits for the arsenal to close).
*/
if (FETCH_CONST(life_adminlevel) < 3) exitWith {closeDialog 0; [ localize "STR_ANOTF_ErrorLevel",true,"fast"] call life_fnc_notification_system;};
if (!alive player || {!isNull objectParent player}) exitWith {closeDialog 0; [ localize "STR_ANOTF_Error",true,"fast"] call life_fnc_notification_system;};
closeDialog 0;
["Open",true] call BIS_fnc_arsenal;
//Wait until the arsenal camera exists (it is created when the arsenal opens) and then until it is gone again.
private _timeout = diag_tickTime + 5;
waitUntil {!isNull (uiNamespace getVariable ["BIS_fnc_arsenal_cam",objNull]) || {diag_tickTime > _timeout}};
waitUntil {isNull (uiNamespace getVariable ["BIS_fnc_arsenal_cam",objNull])};
[] call life_fnc_saveGear;
[3] call SOCK_fnc_updatePartial;
[] call life_fnc_playerSkins;
[ localize "STR_ANOTF_ArsenalSaved",false,"fast"] call life_fnc_notification_system;
