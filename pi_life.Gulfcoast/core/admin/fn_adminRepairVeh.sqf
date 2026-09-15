#include "..\..\script_macros.hpp"
/*
    File: fn_adminRepairVeh.sqf
    Description:
    Fully repairs and refuels the vehicle the admin sits in or looks at (max. 25m).
*/
if (FETCH_CONST(life_adminlevel) < 2) exitWith {closeDialog 0; [ localize "STR_ANOTF_ErrorLevel",true,"fast"] call life_fnc_notification_system;};
private _veh = if (isNull objectParent player) then {cursorObject} else {vehicle player};
private _types = ["LandVehicle","Air","Ship"];
if (isNull _veh || {!(KINDOF_ARRAY(_veh,_types))} || {player distance _veh > 25}) exitWith {[ localize "STR_ANOTF_NoVehicle",true,"fast"] call life_fnc_notification_system;};
closeDialog 0;
_veh setDamage 0;
if (local _veh) then {
    _veh setFuel 1;
} else {
    [_veh,1] remoteExecCall ["life_fnc_setFuel",_veh];
};
[ format [localize "STR_ANOTF_VehRepaired",getText (configFile >> "CfgVehicles" >> (typeOf _veh) >> "displayName")],false,"fast"] call life_fnc_notification_system;
