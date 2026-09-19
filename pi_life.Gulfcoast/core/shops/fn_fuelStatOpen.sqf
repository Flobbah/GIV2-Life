#include "..\..\script_macros.hpp"
/*
    File: fn_fuelStatOpen.sqf
    Author : NiiRoZz
    Description:
    Open dialog Pump.
*/
if (dialog || life_action_inUse || life_is_processing) exitWith {};
private _fuelStations = nearestObjects [player, ["Land_fs_feed_F", "Land_FuelStation_01_pump_F", "Land_FuelStation_02_pump_F"], 10];
if (_fuelstations isEqualTo []) exitWith {};
private _vehicleList = nearestObjects [player, ["Car","Air"], 10];
if (_vehicleList isEqualTo []) exitWith {[ localize "STR_NOTF_VehicleNear",true,"fast"] call life_fnc_notification_system};
createDialog "Life_FuelStat";
life_action_inUse = true;
private _fuelCost = LIFE_SETTINGS(getNumber,"fuel_cost");
uiNamespace setVariable ["fuel_cost",_fuelCost];
ctrlSetText [20301,localize "STR_Fuel_Title"];
//Fetch the shop config.
private _vehicleFuelList = [];
{
    private _fuel = fuel _x;
    _vehicleFuelList pushBack [_x,_fuel];
} forEach _vehicleList;
uiNamespace setVariable ["fuel_list",_vehicleFuelList];
private _control = (findDisplay 20300) displayCtrl 20302;
lbClear _control;
ctrlSetText [20322,format [localize "STR_Price_Fuel_Pump",_fuelCost]];
ctrlSetText [20323,format [localize "STR_Fuel_Total",0]]; //noch nichts gewaehlt
//Loop through
{
    _x params ["_vehicle","_fuelLeft"];
    private _className = typeOf _vehicle;
    private _vehicleInfo = [_className] call life_fnc_fetchVehInfo;
    _control lbAdd (_vehicleInfo select 3);
    _control lbSetPicture [_forEachIndex,(_vehicleInfo select 2)];
    _control lbSetData [_forEachIndex,_className];
} forEach _vehicleFuelList;
