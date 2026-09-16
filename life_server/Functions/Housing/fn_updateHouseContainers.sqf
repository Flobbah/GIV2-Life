#include "\life_server\script_macros.hpp"
/*
    File : fn_updateHouseContainers.sqf
    Author: NiiRoZz
    Description:
    Update inventory "i" in container
*/
private ["_containerID","_containers","_query","_vehItems","_vehMags","_vehWeapons","_vehBackpacks","_cargo"];
_container = [_this,0,objNull,[objNull]] call BIS_fnc_param;
if (isNull _container) exitWith {};
private _caller = CALLER_OWNER; //Sicherheitsphase 0.1: Absender pruefen
if (!(_caller isEqualTo 2) && {((([_caller] call TON_fnc_callerInfo) param [1, objNull]) distance _container) > 25} && {[_caller, "TON_fnc_updateHouseContainers", "container too far from the sender"] call TON_fnc_denyCaller}) exitWith {};
_containerID = [_container, "container_id", -1] call TON_fnc_serverGet; //Sicherheitsphase 0.2: nicht die faelschbare Objekt-Variable (SQL)
if (_containerID isEqualTo -1) exitWith {};
_vehItems = getItemCargo _container;
_vehMags = getMagazineCargo _container;
_vehWeapons = getWeaponCargo _container;
_vehBackpacks = getBackpackCargo _container;
_cargo = [_vehItems,_vehMags,_vehWeapons,_vehBackpacks];
_cargo = [_cargo] call DB_fnc_mresArray;
_query = format ["UPDATE containers SET gear='%1' WHERE id='%2'",_cargo,_containerID];
[_query,1] call DB_fnc_asyncCall;
