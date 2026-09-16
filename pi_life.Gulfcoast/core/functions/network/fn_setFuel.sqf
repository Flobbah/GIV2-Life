#include "..\..\..\script_macros.hpp"
/*
    File: fn_setFuel.sqf
    Author: Bryan "Tonic" Boardwine
    Description: Used to set fuel levels in vehicles. (Ex. Service Chopper)
*/
RELAY_ONLY_REMOTE; //Sicherheitsphase 0.1b: Aufrufe anderer Spieler nur ueber den Server (CfgRelay)
(_this select 0) setFuel (_this select 1);