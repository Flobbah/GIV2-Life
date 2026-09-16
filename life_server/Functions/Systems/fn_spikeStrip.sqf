#include "\life_server\script_macros.hpp"
/*
    File: fn_spikeStrip.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    This is the server-side part of it which constantly monitors the spike strip and vehicles near it.
    First originally tried triggers but I was never any good at those nor do I like them as they
    have a global effect.
*/
private ["_nearVehicles","_spikeStrip"];
_spikeStrip = [_this,0,objNull,[objNull]] call BIS_fnc_param;
if (isNull _spikeStrip) exitWith {}; //Bad vehicle type passed.
//Sicherheitsphase 0.1: nur Polizei in der Naehe des Nagelbands
private _caller = CALLER_OWNER;
private _deny = "";
if !(_caller isEqualTo 2) then {
    private _info = [_caller] call TON_fnc_callerInfo;
    switch (true) do {
        case (_info isEqualTo []): {_deny = "unknown sender";};
        case (!((_info select 2) isEqualTo west)): {_deny = "sender is not a cop";};
        case (((_info select 1) distance _spikeStrip) > 30): {_deny = "spike strip too far from the sender";};
    };
};
if (!(_deny isEqualTo "") && {[_caller, "TON_fnc_spikeStrip", _deny] call TON_fnc_denyCaller}) exitWith {};
waitUntil {_nearVehicles = nearestObjects[getPos _spikeStrip,["Car"],5]; count _nearVehicles > 0 || isNull _spikeStrip};
if (isNull _spikeStrip) exitWith {}; //It was picked up?
_vehicle = _nearVehicles select 0;
if (isNil "_vehicle") exitWith {deleteVehicle _spikeStrip;};
[_vehicle] remoteExec ["life_fnc_spikeStripEffect",_vehicle];
deleteVehicle _spikeStrip;