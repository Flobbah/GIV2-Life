#include "..\..\script_macros.hpp"
/*
    File: fn_robPerson.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Robs a person.
*/
RELAY_ONLY_REMOTE; //Sicherheitsphase 0.1b: Aufrufe anderer Spieler nur ueber den Server (CfgRelay)
if (ECONOMY_MODE >= 1) exitWith {}; //Geld-Umbau Schritt 2: Raub bucht der Server (TON_fnc_econPlayer)
params [
    ["_robber",objNull,[objNull]]
];
if (isNull _robber) exitWith {}; //No one to return it to?
if (CASH > 0) then {
    ["life_fnc_robReceive",[CASH,player,_robber],_robber] call life_fnc_relaySend;
    if (LIFE_HC_ACTIVE) then {
        [getPlayerUID _robber,_robber getVariable ["realname",name _robber],"211"] remoteExecCall ["HC_fnc_wantedAdd",HC_Life];
    } else {
        [getPlayerUID _robber,_robber getVariable ["realname",name _robber],"211"] remoteExecCall ["life_fnc_wantedAdd",RSERV];
    };
    ["life_fnc_broadcast",[1,"STR_NOTF_Robbed",true,[_robber getVariable ["realname",name _robber],profileName,[CASH] call life_fnc_numberText]],RCLIENT] call life_fnc_relaySend;
    CASH = 0;
    [0] call SOCK_fnc_updatePartial;
} else {
    ["life_fnc_broadcast",[2,"STR_NOTF_RobFail",true,[profileName]],_robber] call life_fnc_relaySend;
};
