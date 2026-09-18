#include "..\..\script_macros.hpp"
#define ctrlSelData(ctrl) (lbData[##ctrl,(lbCurSel ##ctrl)])
/*
    File: fn_vehStoreItem.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Used in the vehicle trunk menu, stores the selected item and puts it in the vehicles virtual inventory
    if the vehicle has room for the item.
*/
private ["_ctrl","_num","_totalWeight","_itemWeight","_veh_data","_inv","_index","_val"];
disableSerialization;
if ((life_trunk_vehicle getVariable ["trunk_in_use_by",player]) != player) exitWith { closeDialog 0; [ localize "STR_MISC_VehInvUse",true,"fast"] call life_fnc_notification_system; };
_ctrl = ctrlSelData(3503);
_num = ctrlText 3506;
if (!([_num] call TON_fnc_isnumber)) exitWith {[ localize "STR_MISC_WrongNumFormat",true,"fast"] call life_fnc_notification_system;};
_num = parseNumber(_num);
if (_num < 1) exitWith {[ localize "STR_MISC_Under1",true,"fast"] call life_fnc_notification_system;};
_totalWeight = [life_trunk_vehicle] call life_fnc_vehicleWeight;
_itemWeight = ([_ctrl] call life_fnc_itemWeight) * _num;
_veh_data = life_trunk_vehicle getVariable ["Trunk",[[],0]];
_inv = _veh_data select 0;
if (_ctrl == "goldbar" && {!(life_trunk_vehicle isKindOf "LandVehicle")}) exitWith {[ localize "STR_NOTF_canOnlyStoreInLandVeh",true,"fast"] call life_fnc_notification_system;};
if (_ctrl == "money") then {
    _index = [_ctrl,_inv] call TON_fnc_index;
    if (CASH < _num) exitWith {[ localize "STR_NOTF_notEnoughCashToStoreInVeh",true,"fast"] call life_fnc_notification_system;};
    if (_index isEqualTo -1) then {
        _inv pushBack [_ctrl,_num];
    } else {
        _val = _inv select _index select 1;
        _inv set[_index,[_ctrl,_val + _num]];
    };
    CASH = CASH - _num;
    [0] call SOCK_fnc_updatePartial;
    life_trunk_vehicle setVariable ["Trunk",[_inv,(_veh_data select 1) + _itemWeight],true];
    [life_trunk_vehicle] call life_fnc_vehInventory;
} else {
    //Inventar-Umbau Paket 4: der Server verschiebt zwischen Spieler und Kofferraum
    if (INVENTORY_MODE >= 1) exitWith {
        ["TON_fnc_invTrunk", ["store", life_trunk_vehicle, _ctrl, _num], {
        (_this select 0) params [["_item",""],["_num",0]];
        [ format [localize "STR_NOTF_Trunk_Stored",_num,(localize (M_CONFIG(getText,"VirtualItems",_item,"displayName")))],false,"fast"] call life_fnc_notification_system;
        [life_trunk_vehicle] call life_fnc_vehInventory;
    }, {
        if ((((_this select 0) param [0,""]) isEqualTo "space")) then {
            [ localize "STR_NOTF_VehicleFullOrInsufCap",true,"fast"] call life_fnc_notification_system;
        } else {
            [ localize "STR_CouldNotRemoveItemsToPutInVeh",true,"fast"] call life_fnc_notification_system;
        };
    }] call life_fnc_econRequest;
    };
    if (((_totalWeight select 1) + _itemWeight) > (_totalWeight select 0)) exitWith {[ localize "STR_NOTF_VehicleFullOrInsufCap",true,"fast"] call life_fnc_notification_system;};
    if (!([false,_ctrl,_num] call life_fnc_handleInv)) exitWith {[ localize "STR_CouldNotRemoveItemsToPutInVeh",true,"fast"] call life_fnc_notification_system;};
    _index = [_ctrl,_inv] call TON_fnc_index;
    if (_index isEqualTo -1) then {
        _inv pushBack [_ctrl,_num];
    } else {
        _val = _inv select _index select 1;
        _inv set[_index,[_ctrl,_val + _num]];
    };
    life_trunk_vehicle setVariable ["Trunk",[_inv,(_veh_data select 1) + _itemWeight],true];
    [life_trunk_vehicle] call life_fnc_vehInventory;
};