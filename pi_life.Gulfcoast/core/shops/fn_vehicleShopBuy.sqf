#include "..\..\script_macros.hpp"
/*
    File: fn_vehicleShopBuy.sqf
    Author: Bryan "Tonic" Boardwine
    Edited: freies Abstellen statt Spawnmarker (life_fnc_placementStart)
    Description:
    Kauft oder mietet das gewaehlte Fahrzeug. Nach den Pruefungen stellt der Spieler das Fahrzeug
    selbst ab; das Geld wird erst beim Bestaetigen abgebucht, bei Abbruch nichts.
*/
params [["_mode",true,[true]]];
if ((lbCurSel 2302) isEqualTo -1) exitWith {[ localize "STR_Shop_Veh_DidntPick",true,"fast"] call life_fnc_notification_system;closeDialog 0;};
if ((time - life_action_delay) < 0.2) exitWith {[ localize "STR_NOTF_ActionDelay",true,"fast"] call life_fnc_notification_system;};
life_action_delay = time;
private _className = lbData[2302,(lbCurSel 2302)];
private _initalPrice = M_CONFIG(getNumber,"LifeCfgVehicles",_className,"price");
private _buyMultiplier = 1;
private _rentMultiplier = 1;
switch (life_side) do {
    case civilian: {
        _buyMultiplier = LIFE_SETTINGS(getNumber,"vehicle_purchase_multiplier_CIVILIAN");
        _rentMultiplier = LIFE_SETTINGS(getNumber,"vehicle_rental_multiplier_CIVILIAN");
    };
    case west: {
        _buyMultiplier = LIFE_SETTINGS(getNumber,"vehicle_purchase_multiplier_COP");
        _rentMultiplier = LIFE_SETTINGS(getNumber,"vehicle_rental_multiplier_COP");
    };
    case independent: {
        _buyMultiplier = LIFE_SETTINGS(getNumber,"vehicle_purchase_multiplier_MEDIC");
        _rentMultiplier = LIFE_SETTINGS(getNumber,"vehicle_rental_multiplier_MEDIC");
    };
    case east: {
        _buyMultiplier = LIFE_SETTINGS(getNumber,"vehicle_purchase_multiplier_OPFOR");
        _rentMultiplier = LIFE_SETTINGS(getNumber,"vehicle_rental_multiplier_OPFOR");
    };
};
private _purchasePrice = if (_mode) then {round(_initalPrice * _buyMultiplier)} else {round(_initalPrice * _rentMultiplier)};
private _conditions = M_CONFIG(getText,"LifeCfgVehicles",_className,"conditions");
if !([_conditions] call life_fnc_levelCheck) exitWith {[ localize "STR_Shop_Veh_NoLicense",true,"fast"] call life_fnc_notification_system;};
private _colorIndex = lbValue[2304,(lbCurSel 2304)];
if (_purchasePrice < 0) exitWith {closeDialog 0;}; //Bad price entry
if (CASH < _purchasePrice) exitWith {[ format [localize "STR_Shop_Veh_NotEnough",[_purchasePrice - CASH] call life_fnc_numberText],true,"fast"] call life_fnc_notification_system;closeDialog 0;};
private _shopFlag = life_veh_shop select 2;
private _shop = life_veh_shop select 0;
closeDialog 0; //Haendler schliessen, das Fahrzeug wird jetzt abgestellt

//Fahrzeug erzeugen (nach der Bezahlung, laeuft scheduled); _this = [_args, _pos, _vDir, _vUp, _water]
private _create = {
    params ["_args", "_pos", "_vDir", "_vUp", "_water"];
    _args params ["_className", "_mode", "_purchasePrice", "_colorIndex", "_shopFlag"];
    if (_mode) then {
        [ format [localize "STR_Shop_Veh_Bought",getText(configFile >> "CfgVehicles" >> _className >> "displayName"),[_purchasePrice] call life_fnc_numberText],false,"fast"] call life_fnc_notification_system;
    } else {
        [ format [localize "STR_Shop_Veh_Rented",getText(configFile >> "CfgVehicles" >> _className >> "displayName"),[_purchasePrice] call life_fnc_numberText],false,"fast"] call life_fnc_notification_system;
    };

    //Fahrzeug an der abgestellten Stelle erzeugen (erst ausrichten, dann setzen)
    private _vehicle = createVehicle [_className, ASLToAGL _pos, [], 0, "CAN_COLLIDE"];
    waitUntil {!isNull _vehicle};
    _vehicle allowDamage false; //Temp disable damage handling..
    _vehicle setVectorDirAndUp [_vDir, _vUp];
    if (_water) then {
        _vehicle setPosASLW [_pos select 0, _pos select 1, 0];
    } else {
        _vehicle setPosASL (_pos vectorAdd [0, 0, 0.05]);
    };
    _vehicle lock 2;
    [_vehicle,_colorIndex] call life_fnc_colorVehicle;
    [_vehicle] call life_fnc_clearVehicleAmmo;
    _vehicle setVariable ["trunk_in_use",false,true];
    _vehicle setVariable ["vehicle_info_owners",[[getPlayerUID player,profileName]],true];
    _vehicle disableTIEquipment true; //No Thermals.. They're cheap but addictive.
    //Side Specific actions.
    switch (life_side) do {
        case west: {
            [_vehicle,"cop_offroad",true] spawn life_fnc_vehicleAnimate;
        };
        case civilian: {
            if (_shopFlag isEqualTo "civ" && {_className == "B_Heli_Light_01_F"}) then {
                [_vehicle,"civ_littlebird",true] spawn life_fnc_vehicleAnimate;
            };
        };
        case independent: {
            [_vehicle,"med_offroad",true] spawn life_fnc_vehicleAnimate;
        };
    };
    //Schaden erst nach dem Einschwingen der Federung wieder zulassen
    [_vehicle] spawn {
        sleep 2;
        (_this select 0) allowDamage true;
    };
    life_vehicles pushBack _vehicle;
    //Always handle key management by the server
    [getPlayerUID player,life_side,_vehicle,1] remoteExecCall ["TON_fnc_keyManagement",RSERV];
    if (_mode) then {
        if !(_className in LIFE_SETTINGS(getArray,"vehicleShop_rentalOnly")) then {
            if (LIFE_HC_ACTIVE) then {
                [(getPlayerUID player),life_side,_vehicle,_colorIndex] remoteExecCall ["HC_fnc_vehicleCreate",HC_Life];
            } else {
                [(getPlayerUID player),life_side,_vehicle,_colorIndex] remoteExecCall ["TON_fnc_vehicleCreate",RSERV];
            };
        };
    };
    if (LIFE_SETTINGS(getNumber,"player_advancedLog") isEqualTo 1) then {
        if (LIFE_SETTINGS(getNumber,"battlEye_friendlyLogging") isEqualTo 1) then {
            advanced_log = format [localize "STR_DL_AL_boughtVehicle_BEF",_className,[_purchasePrice] call life_fnc_numberText,[CASH] call life_fnc_numberText,[BANK] call life_fnc_numberText];
        } else {
            advanced_log = format [localize "STR_DL_AL_boughtVehicle",profileName,(getPlayerUID player),_className,[_purchasePrice] call life_fnc_numberText,[CASH] call life_fnc_numberText,[BANK] call life_fnc_numberText];
        };
        [advanced_log] remoteExecCall ["TON_fnc_clientLog",RSERV];
    };
};
[_className, {
    params ["_args", "_pos", "_vDir", "_vUp", "_water"];
    _args params ["_className", "_mode", "_purchasePrice", "_colorIndex", "_shopFlag", "_shop", "_create"];
    if (ECONOMY_MODE >= 1) exitWith {
        //Geld-Umbau Schritt 2: den Preis bucht der Server (TON_fnc_econShop), das Fahrzeug entsteht nach seiner Zusage
        ["TON_fnc_econShop", ["vehicle", _shop, _className, [1, 0] select _mode], {
            private _context = _this select 1;
            _context spawn ((_context select 0) select 6);
        }, {
            private _price = ((_this select 1) select 0) select 2;
            [ format [localize "STR_Shop_Veh_NotEnough",[(_price - CASH) max 0] call life_fnc_numberText],true,"fast"] call life_fnc_notification_system;
        }, [_args, _pos, _vDir, _vUp, _water]] call life_fnc_econRequest;
    };
    if (CASH < _purchasePrice) exitWith {[ format [localize "STR_Shop_Veh_NotEnough",[_purchasePrice - CASH] call life_fnc_numberText],true,"fast"] call life_fnc_notification_system;};
    CASH = CASH - _purchasePrice;
    [0] call SOCK_fnc_updatePartial;
    [_args, _pos, _vDir, _vUp, _water] call _create;
}, {}, [_className, _mode, _purchasePrice, _colorIndex, _shopFlag, _shop, _create]] call life_fnc_placementStart;
true;
