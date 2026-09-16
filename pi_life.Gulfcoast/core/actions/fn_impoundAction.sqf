#include "..\..\script_macros.hpp"
/*
    File: fn_impoundAction.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Impounds the vehicle
*/
private ["_vehicle","_type","_time","_value","_vehicleData","_upp","_ui","_progress","_pgText","_cP","_filters","_impoundValue","_price","_impoundMultiplier"];
_vehicle = param [0,objNull,[objNull]];
_filters = ["Car","Air","Ship"];
if (!((KINDOF_ARRAY(_vehicle,_filters)))) exitWith {};
if (player distance cursorObject > 10) exitWith {};
if (_vehicle getVariable "NPC") exitWith {[ localize "STR_NPC_Protected",true,"fast"] call life_fnc_notification_system};
_vehicleData = _vehicle getVariable ["vehicle_info_owners",[]];
if (_vehicleData isEqualTo 0) exitWith {deleteVehicle _vehicle}; //Bad vehicle.
_vehicleName = FETCH_CONFIG2(getText,"CfgVehicles",(typeOf _vehicle),"displayName");
_price = M_CONFIG(getNumber,"LifeCfgVehicles",(typeOf _vehicle),"price");
["life_fnc_broadcast",[0,"STR_NOTF_BeingImpounded",true,[((_vehicleData select 0) select 1),_vehicleName]],RCLIENT] call life_fnc_relaySend;
life_action_inUse = true;
_upp = localize "STR_NOTF_Impounding";
//Setup our progress bar.
disableSerialization;
"progressBar" cutRsc ["life_progress","PLAIN"];
_ui = uiNamespace getVariable "life_progress";
_progress = _ui displayCtrl 38201;
_pgText = _ui displayCtrl 38202;
_pgText ctrlSetText format ["%2 (1%1)...","%",_upp];
_progress progressSetPosition 0.01;
_cP = 0.01;
for "_i" from 0 to 1 step 0 do {
    uiSleep 0.09;
    _cP = _cP + 0.01;
    _progress progressSetPosition _cP;
    _pgText ctrlSetText format ["%3 (%1%2)...",round(_cP * 100),"%",_upp];
    if (_cP >= 1) exitWith {};
    if (player distance _vehicle > 10) exitWith {};
    if (!alive player) exitWith {};
};
"progressBar" cutText ["","PLAIN"];
if (player distance _vehicle > 10) exitWith {[ localize "STR_NOTF_ImpoundingCancelled",true,"fast"] call life_fnc_notification_system; life_action_inUse = false;};
if (!alive player) exitWith {life_action_inUse = false;};
if (count crew _vehicle isEqualTo 0) then {
    if (!(KINDOF_ARRAY(_vehicle,_filters))) exitWith {life_action_inUse = false;};
    _type = FETCH_CONFIG2(getText,"CfgVehicles",(typeOf _vehicle),"displayName");
    life_impound_inuse = true;
    if (LIFE_HC_ACTIVE) then {
        [_vehicle,true,player,"impound"] remoteExec ["HC_fnc_vehicleStore",HC_Life];
    } else {
        [_vehicle,true,player,"impound"] remoteExec ["TON_fnc_vehicleStore",RSERV];
    };
    waitUntil {!life_impound_inuse};
    if (life_side isEqualTo west && {ECONOMY_MODE >= 1}) then { //Geld-Umbau Schritt 2: Belohnung bucht der Server (TON_fnc_vehicleStore)
        ["life_fnc_broadcast",[0,"STR_NOTF_HasImpounded",true,[profileName,((_vehicleData select 0) select 1),_vehicleName]],RCLIENT] call life_fnc_relaySend;
    };
    if (life_side isEqualTo west && {ECONOMY_MODE isEqualTo 0}) then {
            _impoundMultiplier = LIFE_SETTINGS(getNumber,"vehicle_cop_impound_multiplier");
            _value = _price * _impoundMultiplier;
            ["life_fnc_broadcast",[0,"STR_NOTF_HasImpounded",true,[profileName,((_vehicleData select 0) select 1),_vehicleName]],RCLIENT] call life_fnc_relaySend;
            if (_vehicle in life_vehicles) then {
                [ format [localize "STR_NOTF_OwnImpounded",[_value] call life_fnc_numberText,_type],true,"fast"] call life_fnc_notification_system;
                BANK = BANK - _value;
            } else {
                [ format [localize "STR_NOTF_Impounded",_type,[_value] call life_fnc_numberText],false,"fast"] call life_fnc_notification_system;
                BANK = BANK + _value;
            };
            if (BANK < 0) then {BANK = 0;};
            [1] call SOCK_fnc_updatePartial;
    };
} else {
    [ localize "STR_NOTF_ImpoundingCancelled",true,"fast"] call life_fnc_notification_system;
};
life_action_inUse = false;
