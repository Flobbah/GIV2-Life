#include "..\..\script_macros.hpp"
/*
    File: fn_sellGarage.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Sells a vehicle from the garage.
*/
private ["_vehicle","_vehicleLife","_vid","_pid","_sellPrice","_multiplier","_price","_purchasePrice"];
disableSerialization;
if ((lbCurSel 2802) isEqualTo -1) exitWith {[ localize "STR_Global_NoSelection",true,"fast"] call life_fnc_notification_system};
_vehicle = lbData[2802,(lbCurSel 2802)];
_vehicle = (call compile format ["%1",_vehicle]) select 0;
_vehicleLife = _vehicle;
_vid = lbValue[2802,(lbCurSel 2802)];
_pid = getPlayerUID player;
if (isNil "_vehicle") exitWith {[ localize "STR_Garage_Selection_Error",true,"fast"] call life_fnc_notification_system};
if ((time - life_action_delay) < 1.5) exitWith {[ localize "STR_NOTF_ActionDelay",true,"fast"] call life_fnc_notification_system;};
if (!isClass (missionConfigFile >> "LifeCfgVehicles" >> _vehicleLife)) then {
    _vehicleLife = "Default"; //Use Default class if it doesn't exist
    diag_log format ["%1: LifeCfgVehicles class doesn't exist",_vehicle];
};
_price = M_CONFIG(getNumber,"LifeCfgVehicles",_vehicleLife,"price");
switch (life_side) do {
    case civilian: {
        _multiplier = LIFE_SETTINGS(getNumber,"vehicle_sell_multiplier_CIVILIAN");
        _purchasePrice = _price * LIFE_SETTINGS(getNumber,"vehicle_purchase_multiplier_CIVILIAN");
    };
    case west: {
        _multiplier = LIFE_SETTINGS(getNumber,"vehicle_sell_multiplier_COP");
        _purchasePrice = _price * LIFE_SETTINGS(getNumber,"vehicle_purchase_multiplier_COP");
    };
    case independent: {
        _multiplier = LIFE_SETTINGS(getNumber,"vehicle_sell_multiplier_MEDIC");
        _purchasePrice = _price * LIFE_SETTINGS(getNumber,"vehicle_purchase_multiplier_MEDIC");
    };
    case east: {
        _multiplier = LIFE_SETTINGS(getNumber,"vehicle_sell_multiplier_OPFOR");
        _purchasePrice = _price * LIFE_SETTINGS(getNumber,"vehicle_purchase_multiplier_OPFOR");
    };
};
_sellPrice = _purchasePrice * _multiplier;
if (!(_sellPrice isEqualType 0) || _sellPrice < 1) then {_sellPrice = 500;};
if (LIFE_HC_ACTIVE) then {
    [_vid,_pid,_sellPrice,player,life_garage_type] remoteExecCall ["HC_fnc_vehicleDelete",HC_Life];
} else {
    [_vid,_pid,_sellPrice,player,life_garage_type] remoteExecCall ["TON_fnc_vehicleDelete",RSERV];
};
if (ECONOMY_MODE isEqualTo 0) then { //ab Modus 1 zahlt der Server nach der Pruefung (TON_fnc_vehicleDelete)
    [ format [localize "STR_Garage_SoldCar",[_sellPrice] call life_fnc_numberText],false,"fast"] call life_fnc_notification_system;
    BANK = BANK + _sellPrice;
    [1] call SOCK_fnc_updatePartial;
};
if (LIFE_SETTINGS(getNumber,"player_advancedLog") isEqualTo 1) then {
    if (LIFE_SETTINGS(getNumber,"battlEye_friendlyLogging") isEqualTo 1) then {
        advanced_log = format [localize "STR_DL_AL_soldVehicle_BEF",_vehicleLife,[_sellPrice] call life_fnc_numberText,[BANK] call life_fnc_numberText,[CASH] call life_fnc_numberText];
    } else {
        advanced_log = format [localize "STR_DL_AL_soldVehicle",profileName,(getPlayerUID player),_vehicleLife,[_sellPrice] call life_fnc_numberText,[BANK] call life_fnc_numberText,[CASH] call life_fnc_numberText];
    };
    [advanced_log] remoteExecCall ["TON_fnc_clientLog",RSERV];
};
life_action_delay = time;
closeDialog 0;