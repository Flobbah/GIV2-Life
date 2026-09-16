#include "..\..\script_macros.hpp"
/*
    File: moveIn.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Set a variable on the player so that he can't get out of a vehicle
*/
RELAY_ONLY_REMOTE; //Sicherheitsphase 0.1b: Aufrufe anderer Spieler nur ueber den Server (CfgRelay)
life_disable_getIn = false;
player moveInCargo (_this select 0);
life_disable_getOut = true;
