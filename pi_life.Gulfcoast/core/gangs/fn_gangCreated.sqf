#include "..\..\script_macros.hpp"
/*
    File: fn_gangCreated.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Tells the player that the gang is created and throws him into it.
*/
SERVER_ONLY_REMOTE; //Sicherheitsphase 0.1: nur der Server darf diese Funktion remote aufrufen
private "_group";
life_action_gangInUse = nil;
if (ECONOMY_MODE >= 1) exitWith { //Geld-Umbau Schritt 2: den Preis hat der Server schon gebucht (TON_fnc_insertGang)
    [ format [localize "STR_GNOTF_CreateSuccess",(group player) getVariable "gang_name",[(LIFE_SETTINGS(getNumber,"gang_price"))] call life_fnc_numberText],false,"fast"] call life_fnc_notification_system;
};
if (BANK < (LIFE_SETTINGS(getNumber,"gang_price"))) exitWith {
    [ format [localize "STR_GNOTF_NotEnoughMoney",[((LIFE_SETTINGS(getNumber,"gang_price"))-BANK)] call life_fnc_numberText],true,"fast"] call life_fnc_notification_system;
    {group player setVariable [_x,nil,true];} forEach ["gang_id","gang_owner","gang_name","gang_members","gang_maxmembers","gang_bank"];
};
BANK = BANK - LIFE_SETTINGS(getNumber,"gang_price");
[1] call SOCK_fnc_updatePartial;
[ format [localize "STR_GNOTF_CreateSuccess",(group player) getVariable "gang_name",[(LIFE_SETTINGS(getNumber,"gang_price"))] call life_fnc_numberText],false,"fast"] call life_fnc_notification_system;