#include "..\..\script_macros.hpp"
/*
    File: fn_onPlayerRespawn.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Does something but I won't know till I write it...
*/
private ["_unit","_corpse","_containers"];
_unit = _this select 0;
_corpse = _this select 1;
life_corpse = _corpse;
//Set some vars on our new body.
//Sicherheitsprüfung #7: Beim Tod hat der Server den Gewahrsam bereits beendet
_unit setVariable ["playerSurrender",false,true];
_unit setVariable ["steam64id",getPlayerUID player,true]; //Reset the UID.
_unit setVariable ["realname",profileName,true]; //Reset the players name.
_unit setVariable ["life_side",life_side,true]; //Dienst-System: Fraktion auf den neuen Koerper uebertragen
if !((side (group _unit)) isEqualTo life_side) then {[_unit] joinSilent (createGroup [life_side,true]);};
player playMoveNow "AmovPpneMstpSrasWrflDnon";
[] call life_fnc_setupActions;
[_unit,life_settings_enableSidechannel,life_side] remoteExecCall ["TON_fnc_manageSC",RSERV];
if (LIFE_SETTINGS(getNumber,"enable_fatigue") isEqualTo 0) then {player enableFatigue false;};
