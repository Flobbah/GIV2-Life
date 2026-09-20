#include "..\..\script_macros.hpp"
/*
    File: fn_pullOutVeh.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
*/
RELAY_ONLY_REMOTE; //Sicherheitsphase 0.1b: Aufrufe anderer Spieler nur ueber den Server (CfgRelay)
if (life_side isEqualTo west || (isNull objectParent player)) exitWith {};
if (player getVariable "restrained") then {
    detach player;
    //Sicherheitsprüfung #7: den Zustand setzt der Server (TON_fnc_custody), nicht der Client
    life_disable_getOut = false;
    player action ["Eject", vehicle player];
    titleText[localize "STR_NOTF_PulledOut","PLAIN"];
    titleFadeOut 4;
    life_disable_getIn = true;
} else {
    player action ["Eject", vehicle player];
    titleText[localize "STR_NOTF_PulledOut","PLAIN"];
    titleFadeOut 4;
};
