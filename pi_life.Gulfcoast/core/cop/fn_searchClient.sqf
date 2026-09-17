#include "..\..\script_macros.hpp"
/*
    File: fn_searchClient.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Searches the player and he returns information back to the player.
*/
RELAY_ONLY_REMOTE; //Sicherheitsphase 0.1b: Aufrufe anderer Spieler nur ueber den Server (CfgRelay)
private ["_inv","_val","_var","_robber"];
params [
    ["_cop",objNull,[objNull]]
];
if (isNull _cop) exitWith {};
_inv = [];
_robber = false;
//Illegal items
{
    _var = configName(_x);
    _val = ITEM_VALUE(_var);
    if (_val > 0) then {
        _inv pushBack [_var,_val];
        [false,_var,_val] call life_fnc_handleInv;
    };
} forEach ("getNumber(_x >> 'illegal') isEqualTo 1" configClasses (missionConfigFile >> "VirtualItems"));
if (!life_use_atm) then  {
    if (ECONOMY_MODE >= 1) then {["forfeit"] remoteExecCall ["TON_fnc_econCash",RSERV]}; //Geld-Umbau Schritt 2: Beute verfaellt auf dem Server
    CASH = 0;
    if (ECONOMY_MODE >= 2) then {[] remoteExecCall ["TON_fnc_walletSync",RSERV]}; //Schritt 4: Kontostand vom Server
    _robber = true;
};
["life_fnc_copSearch",[player,_inv,_robber],_cop] call life_fnc_relaySend;
