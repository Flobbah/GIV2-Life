#include "..\..\script_macros.hpp"
/*
    File: fn_adminTpTo.sqf
    Description:
    Teleports the admin (or the vehicle he sits in) next to the selected player.
*/
if (FETCH_CONST(life_adminlevel) < 3) exitWith {closeDialog 0; [ localize "STR_ANOTF_ErrorLevel",true,"fast"] call life_fnc_notification_system;};
private _target = [] call life_fnc_adminTarget;
if (isNull _target) exitWith {[ localize "STR_ANOTF_NoTarget",true,"fast"] call life_fnc_notification_system;};
if (_target isEqualTo player) exitWith {[ localize "STR_ANOTF_Error",true,"fast"] call life_fnc_notification_system;};
closeDialog 0;
private _targetVeh = vehicle _target;
private _pos = _targetVeh getPos [3,(getDir _targetVeh) + 90];
_pos set [2,0];
(vehicle player) setPos _pos;
[ format [localize "STR_ANOTF_TpTo",_target getVariable ["realname",name _target]],false,"fast"] call life_fnc_notification_system;
