#include "..\..\..\script_macros.hpp"
/*
    File: fn_soundDevice.sqf
    Author:
    Description:
    Plays a device sound for mining (Mainly Tempest device).
*/
RELAY_ONLY_REMOTE; //Sicherheitsphase 0.1b: Aufrufe anderer Spieler nur ueber den Server (CfgRelay)
params [["_vehicle", objNull, [objNull]]];
if (isNull _vehicle) exitWith {};
if (player distance _vehicle > 2500) exitWith {}; //Don't run it... They're to far out..
for "_i" from 0 to 1 step 0 do {
    if (isNull _vehicle || !alive _vehicle) exitWith {};
    if (isNil {_vehicle getVariable "mining"}) exitWith {};
    _vehicle say3D ["Device_disassembled_loop",150,1];
    sleep 28.6;
};
