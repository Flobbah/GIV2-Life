#include "..\..\script_macros.hpp"
/*
    File: fn_adminVehicleSpawn.sqf
    Description:
    Spawns the selected vehicle for the admin, adds the key to his keychain
    (client list + server key management, exactly like a shop purchase) and optionally
    stores it as a persistent vehicle in the database (checkbox 2954).
    If nothing is selected, the text in the search box is used as raw classname.
    Edited: freies Abstellen wie in Garage und Haendler (life_fnc_placementStart); das Fahrzeug
    entsteht erst beim Bestaetigen, bei Abbruch wird nichts erzeugt.
*/
if (FETCH_CONST(life_adminlevel) < 3) exitWith {closeDialog 0; [ localize "STR_ANOTF_ErrorLevel",true,"fast"] call life_fnc_notification_system;};
disableSerialization;
private _display = findDisplay 2950;
if (isNull _display) exitWith {};
private _list = _display displayCtrl 2951;
private _className = if ((lbCurSel _list) isEqualTo -1) then {ctrlText 2953} else {_list lbData (lbCurSel _list)};
private _cfg = configFile >> "CfgVehicles" >> _className;
if (_className isEqualTo "" || {!isClass _cfg} || {getNumber (_cfg >> "scope") < 1} || {!(_className isKindOf "LandVehicle" || {_className isKindOf "Air"} || {_className isKindOf "Ship"})}) exitWith {
    [ localize "STR_ANOTF_VehSpawnFail",true,"fast"] call life_fnc_notification_system;
};
private _colorIndex = if ((lbCurSel 2952) isEqualTo -1) then {-1} else {lbValue [2952,(lbCurSel 2952)]};
private _persistent = (cbChecked (_display displayCtrl 2954)) && {LIFE_SETTINGS(getNumber,"admin_vehicleSpawn_persistent") isEqualTo 1};
closeDialog 0;

[_className, {
    params ["_args", "_pos", "_vDir", "_vUp", "_water"];
    _args params ["_className", "_colorIndex", "_persistent"];
    if (FETCH_CONST(life_adminlevel) < 3) exitWith {[ localize "STR_ANOTF_ErrorLevel",true,"fast"] call life_fnc_notification_system;};
    private _cfg = configFile >> "CfgVehicles" >> _className;
    //an der abgestellten Stelle erzeugen (erst ausrichten, dann setzen)
    private _vehicle = createVehicle [_className, ASLToAGL _pos, [], 0, "CAN_COLLIDE"];
    if (isNull _vehicle) exitWith {[ localize "STR_ANOTF_VehSpawnFail",true,"fast"] call life_fnc_notification_system;};
    _vehicle allowDamage false;
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
    //Sicherheitsprüfung #7: die Schluesselliste fuehrt der Server (TON_fnc_vehicleKeys) - beim Anlegen schon geschehen
    _vehicle disableTIEquipment true;
    //Side specific animations (same as the vehicle shop)
    switch (life_side) do {
        case west: {[_vehicle,"cop_offroad",true] spawn life_fnc_vehicleAnimate;};
        case independent: {[_vehicle,"med_offroad",true] spawn life_fnc_vehicleAnimate;};
        case civilian: {
            if (_className isEqualTo "B_Heli_Light_01_F") then {[_vehicle,"civ_littlebird",true] spawn life_fnc_vehicleAnimate;};
        };
    };
    //Schaden erst nach dem Einschwingen der Federung wieder zulassen
    [_vehicle] spawn {
        sleep 2;
        (_this select 0) allowDamage true;
    };
    //Key: local keychain + server side key management
    life_vehicles pushBack _vehicle;
    [getPlayerUID player,life_side,_vehicle,1] remoteExecCall ["TON_fnc_keyManagement",RSERV];
    //Optional: persistent vehicle (garage)
    if (_persistent) then {
        if (LIFE_HC_ACTIVE) then {
            [getPlayerUID player,life_side,_vehicle,_colorIndex max 0] remoteExecCall ["HC_fnc_vehicleCreate",HC_Life];
        } else {
            [getPlayerUID player,life_side,_vehicle,_colorIndex max 0] remoteExecCall ["TON_fnc_vehicleCreate",RSERV];
        };
    };
    if (LIFE_SETTINGS(getNumber,"player_advancedLog") isEqualTo 1) then {
        advanced_log = format ["[ADMIN VEHICLE] %1 (%2) spawned %3 (persistent: %4)",profileName,getPlayerUID player,_className,_persistent];
        [advanced_log] remoteExecCall ["TON_fnc_clientLog",RSERV];
    };
    [ format [localize "STR_ANOTF_VehSpawned",getText (_cfg >> "displayName")],false,"fast"] call life_fnc_notification_system;
}, {}, [_className, _colorIndex, _persistent]] call life_fnc_placementStart;
