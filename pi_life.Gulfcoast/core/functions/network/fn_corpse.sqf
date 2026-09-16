#include "..\..\..\script_macros.hpp"
/*
    File: fn_corpse.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Hides dead bodies.
*/
RELAY_ONLY_REMOTE; //Sicherheitsphase 0.1b: Aufrufe anderer Spieler nur ueber den Server (CfgRelay)
private ["_corpse"];
_corpse = [_this,0,objNull,[objNull]] call BIS_fnc_param;
if (isNull _corpse) exitWith {};
if (alive _corpse) exitWith {}; //Stop script kiddies.
deleteVehicle _corpse;