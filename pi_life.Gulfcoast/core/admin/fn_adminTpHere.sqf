#include "..\..\script_macros.hpp"
/*
    File: fn_adminTpHere.sqf
    Author: ColinM9991
    Description:
    Teleport selected player to you.
*/
if (FETCH_CONST(life_adminlevel) < 4) exitWith {closeDialog 0;};
private _target = [] call life_fnc_adminTarget;
if (isNull _target) exitWith {[ localize "STR_ANOTF_NoTarget",true,"fast"] call life_fnc_notification_system;};
if (_target isEqualTo player) exitWith {[ localize "STR_ANOTF_Error",true,"fast"] call life_fnc_notification_system;};
if (!(vehicle _target isEqualTo _target)) exitWith {[ localize "STR_Admin_CannotTpHere",true,"fast"] call life_fnc_notification_system;};
_target setPos (getPos player);
[ format [localize "STR_NOTF_haveTPedToYou",_target getVariable ["realname",name _target]],false,"fast"] call life_fnc_notification_system;
