#include "..\..\script_macros.hpp"
/*
    File: fn_adminQueryReply.sqf
    Description:
    Wird auf dem abgefragten Spieler ausgefuehrt (remoteExec aus fn_adminQuery) und schickt
    die Kontodaten an den Admin zurueck (life_fnc_adminInfo). Ersetzt das nirgends definierte
    TON_fnc_player_query, wegen dem die Info-Box im Admin-Menue bei "Abfrage laeuft" haengen blieb.
    Parameter:
        0: OBJECT - der abfragende Admin
*/
params [["_admin",objNull,[objNull]]];
if (isNull _admin) exitWith {};
[BANK,CASH,0,player,profileName,getPlayerUID player,life_side] remoteExec ["life_fnc_adminInfo",_admin];
