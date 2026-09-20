#include "..\..\script_macros.hpp"
/*
    File: fn_putInCar.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Finds the nearest vehicle and loads the target into the vehicle.
*/
private ["_unit"];
_unit = param [0,objNull,[objNull]];
if (isNull _unit || !isPlayer _unit) exitWith {};
_nearestVehicle = nearestObjects[getPosATL player,["Car","Ship","Submarine","Air"],10] select 0;
if (isNil "_nearestVehicle") exitWith {[ localize "STR_NOTF_VehicleNear",true,"fast"] call life_fnc_notification_system};
detach _unit;
["life_fnc_moveIn",[_nearestVehicle],_unit] call life_fnc_relaySend;
//Sicherheitsprüfung #7: den Zustand setzt der Server (TON_fnc_custody), nicht der Client
[_unit,"inCar"] remoteExecCall ["TON_fnc_custody",RSERV];