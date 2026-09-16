#include "..\..\script_macros.hpp"
/*
    File: fn_robReceive.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
*/
RELAY_ONLY_REMOTE; //Sicherheitsphase 0.1b: Aufrufe anderer Spieler nur ueber den Server (CfgRelay)
if (ECONOMY_MODE >= 1) exitWith {}; //Geld-Umbau Schritt 2: Raub bucht der Server (TON_fnc_econPlayer)
params [
    ["_cash",0,[0]],
    ["_victim",objNull,[objNull]],
    ["_robber",objNull,[objNull]]
];
if (_robber == _victim) exitWith {};
if (_cash isEqualTo 0) exitWith {titleText[localize "STR_Civ_RobFail","PLAIN"]};
CASH = CASH + _cash;
[0] call SOCK_fnc_updatePartial;
titleText[format [localize "STR_Civ_Robbed",[_cash] call life_fnc_numberText],"PLAIN"];
if (LIFE_SETTINGS(getNumber,"player_moneyLog") isEqualTo 1) then {
    if (LIFE_SETTINGS(getNumber,"battlEye_friendlyLogging") isEqualTo 1) then {
        money_log = format [localize "STR_DL_ML_Robbed_BEF",[_cash] call life_fnc_numberText,_victim,[BANK] call life_fnc_numberText,[CASH] call life_fnc_numberText];
    } else {
        money_log = format [localize "STR_DL_ML_Robbed",profileName,(getPlayerUID player),[_cash] call life_fnc_numberText,_victim,[BANK] call life_fnc_numberText,[CASH] call life_fnc_numberText];
    };
    [money_log] remoteExecCall ["TON_fnc_clientLog",RSERV];
};
