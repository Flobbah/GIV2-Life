#include "..\..\script_macros.hpp"
/*
    File: fn_spikeStripEffect.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Doesn't work without the server-side effect but shifted part of it clientside
    so code can easily be changed. Ultimately it just pops the tires.
*/
SERVER_ONLY_REMOTE; //Sicherheitsphase 0.1: nur der Server darf diese Funktion remote aufrufen
private ["_vehicle"];
_vehicle = [_this,0,objNull,[objNull]] call BIS_fnc_param;
if (isNull _vehicle) exitWith {}; //Bad vehicle type
_vehicle setHitPointDamage["HitLFWheel",1];
_vehicle setHitPointDamage["HitRFWheel",1];
