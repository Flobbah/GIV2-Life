#include "..\..\script_macros.hpp"
/*
    File: fn_adminFreeze.sqf
    Author: ColinM9991
    Description: Freezes selected player
*/
if (FETCH_CONST(life_adminlevel) < 4) exitWith {closeDialog 0; [ localize "STR_ANOTF_ErrorLevel",true,"fast"] call life_fnc_notification_system;};
private _unit = [] call life_fnc_adminTarget;
if (isNull _unit) exitWith {[ localize "STR_ANOTF_NoTarget",true,"fast"] call life_fnc_notification_system;};
if (_unit isEqualTo player) exitWith {[ localize "STR_ANOTF_Error",true,"fast"] call life_fnc_notification_system;};
[player] remoteExec ["life_fnc_freezePlayer",_unit];
