#include "..\..\script_macros.hpp"
/*
    File: fn_chopShopMenu.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Opens & initializes the chop shop menu.
*/
if (life_action_inUse) exitWith {[ localize "STR_NOTF_ActionInProc",true,"fast"] call life_fnc_notification_system};
if !(life_side isEqualTo civilian) exitWith {[ localize "STR_NOTF_notAllowed",true,"fast"] call life_fnc_notification_system};
disableSerialization;
private _chopable = LIFE_SETTINGS(getArray,"chopShop_vehicles");
private _nearVehicles = nearestObjects [getMarkerPos (_this select 3),_chopable,25];
private _nearUnits = (nearestObjects[player,["CAManBase"],5]) arrayIntersect playableUnits;
if (count _nearUnits > 1) exitWith {[ localize "STR_NOTF_PlayerNear",true,"fast"] call life_fnc_notification_system};
life_chopShop = _this select 3;
//Error check
if (_nearVehicles isEqualTo []) exitWith {titleText[localize "STR_Shop_NoVehNear","PLAIN"];};
if (!(createDialog "Chop_Shop")) exitWith {[ localize "STR_Shop_ChopShopError",true,"fast"] call life_fnc_notification_system};
private _control = CONTROL(39400,39402);
private "_className";
private "_displayName";
private "_picture";
private "_price";
private "_chopMultiplier";
{
    if (alive _x) then {
        _className = typeOf _x;
        _displayName = getText(configFile >> "CfgVehicles" >> _className >> "displayName");
        _picture = [_className] call life_fnc_vehiclePicture;
        if (!isClass (missionConfigFile >> "LifeCfgVehicles" >> _className)) then {
            diag_log format ["%1: LifeCfgVehicles class doesn't exist",_className];
            _className = "Default"; //Use Default class if it doesn't exist
        };
        _price = M_CONFIG(getNumber,"LifeCfgVehicles",_className,"price");
        _chopMultiplier = LIFE_SETTINGS(getNumber,"vehicle_chopShop_multiplier");
        _price = _price * _chopMultiplier;
        if (!isNil "_price" && count crew _x isEqualTo 0) then {
            _control lbAdd _displayName;
            _control lbSetData [(lbSize _control)-1,(netId _x)];
            _control lbSetPicture [(lbSize _control)-1,_picture];
            _control lbSetValue [(lbSize _control)-1,_price];
        };
    };
} forEach _nearVehicles;
