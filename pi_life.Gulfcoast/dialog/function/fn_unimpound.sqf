#include "..\..\script_macros.hpp"
/*
    File: fn_unimpound.sqf
    Author: Bryan "Tonic" Boardwine
    Edited: freies Abstellen statt Spawnmarker (life_fnc_placementStart)
    Description:
    Holt das gewaehlte Fahrzeug aus der Garage. Der Spieler stellt es selbst ab; die Gebuehr wird
    erst beim Bestaetigen abgebucht. Ist der Platz auf dem Server doch belegt, erstattet der Server
    die Gebuehr (life_fnc_garageRefund).
*/
private ["_vehicle","_vehicleLife","_vid","_pid","_price","_storageFee","_purchasePrice","_spawntext"];
disableSerialization;
if ((lbCurSel 2802) isEqualTo -1) exitWith {[ localize "STR_Global_NoSelection",true,"fast"] call life_fnc_notification_system};
_vehicle = lbData[2802,(lbCurSel 2802)];
_vehicle = (call compile format ["%1",_vehicle]) select 0;
_vehicleLife = _vehicle;
_vid = lbValue[2802,(lbCurSel 2802)];
_pid = getPlayerUID player;
_spawntext = localize "STR_Garage_spawn_Success";
if (isNil "_vehicle") exitWith {[ localize "STR_Garage_Selection_Error",true,"fast"] call life_fnc_notification_system};
if (!isClass (missionConfigFile >> "LifeCfgVehicles" >> _vehicleLife)) then {
    _vehicleLife = "Default"; //Use Default class if it doesn't exist
    diag_log format ["%1: LifeCfgVehicles class doesn't exist",_vehicle];
};
_price = M_CONFIG(getNumber,"LifeCfgVehicles",_vehicleLife,"price");
_storageFee = LIFE_SETTINGS(getNumber,"vehicle_storage_fee_multiplier");
_purchasePrice = _price;
switch (life_side) do {
    case civilian: {_purchasePrice = _price * LIFE_SETTINGS(getNumber,"vehicle_purchase_multiplier_CIVILIAN");};
    case west: {_purchasePrice = _price * LIFE_SETTINGS(getNumber,"vehicle_purchase_multiplier_COP");};
    case independent: {_purchasePrice = _price * LIFE_SETTINGS(getNumber,"vehicle_purchase_multiplier_MEDIC");};
    case east: {_purchasePrice = _price * LIFE_SETTINGS(getNumber,"vehicle_purchase_multiplier_OPFOR");};
};
_price = _purchasePrice * _storageFee;
if (!(_price isEqualType 0) || _price < 1) then {_price = 500;};
if (BANK < _price) exitWith {[ format [(localize "STR_Garage_CashError"),[_price] call life_fnc_numberText],true,"fast"] call life_fnc_notification_system;};
closeDialog 0;
[_vehicle, {
    params ["_args", "_pos", "_vDir", "_vUp", "_water"];
    _args params ["_vid", "_pid", "_price", "_spawntext"];
    if (BANK < _price) exitWith {[ format [(localize "STR_Garage_CashError"),[_price] call life_fnc_numberText],true,"fast"] call life_fnc_notification_system;};
    private _placement = [_pos, _vDir, _vUp, _water];
    if (LIFE_HC_ACTIVE) then {
        [_vid,_pid,_placement,player,_price,0,_spawntext] remoteExec ["HC_fnc_spawnVehicle",HC_Life];
    } else {
        [_vid,_pid,_placement,player,_price,0,_spawntext] remoteExec ["TON_fnc_spawnVehicle",RSERV];
    };
    [ localize "STR_Garage_SpawningVeh",false,"fast"] call life_fnc_notification_system;
    if (ECONOMY_MODE isEqualTo 0) then { //ab Modus 1 bucht der Server die Gebuehr beim Ausparken (TON_fnc_spawnVehicle)
        BANK = BANK - _price;
        [1] call SOCK_fnc_updatePartial;
    };
}, {}, [_vid, _pid, _price, _spawntext]] call life_fnc_placementStart;
