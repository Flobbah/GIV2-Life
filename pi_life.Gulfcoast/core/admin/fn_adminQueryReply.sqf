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
RELAY_ONLY_REMOTE; //Sicherheitsphase 0.1b: Aufrufe anderer Spieler nur ueber den Server (CfgRelay)
params [["_admin",objNull,[objNull]]];
if (isNull _admin) exitWith {};
["life_fnc_adminInfo",[BANK,CASH,0,player,profileName,getPlayerUID player,life_side],_admin] call life_fnc_relaySend;
