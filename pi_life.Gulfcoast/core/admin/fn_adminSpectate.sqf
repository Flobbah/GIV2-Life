#include "..\..\script_macros.hpp"
/*
    File: fn_adminSpectate.sqf
    Author: ColinM9991
    Description:
    Spectate the chosen player.
*/
if (FETCH_CONST(life_adminlevel) < 3) exitWith {closeDialog 0;};
private _unit = [] call life_fnc_adminTarget;
if (isNull _unit) exitWith {[ localize "STR_ANOTF_NoTarget",true,"fast"] call life_fnc_notification_system;};
if (_unit isEqualTo player) exitWith {[ localize "STR_ANOTF_Error",true,"fast"] call life_fnc_notification_system;};
closeDialog 0;
_unit switchCamera "INTERNAL";
[ format [localize "STR_NOTF_nowSpectating",_unit getVariable ["realname",name _unit]],true,"fast"] call life_fnc_notification_system;
AM_Exit = (findDisplay 46) displayAddEventHandler ["KeyDown", "if ((_this select 1) == 68) then {(findDisplay 46) displayRemoveEventHandler ['KeyDown',AM_Exit]; player switchCamera 'INTERNAL'; [ localize 'STR_NOTF_stoppedSpectating',true,'fast'] call life_fnc_notification_system;}; false"];
