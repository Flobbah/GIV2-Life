#include "..\..\script_macros.hpp"
/*
    File: fn_wireTransfer.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Initiates the wire-transfer
*/
RELAY_ONLY_REMOTE; //Sicherheitsphase 0.1b: Aufrufe anderer Spieler nur ueber den Server (CfgRelay)
if (ECONOMY_MODE >= 1) exitWith {}; //Geld-Umbau Schritt 2: Ueberweisungen bucht der Server (TON_fnc_econBank)
params [
    ["_value",0,[0]],
    ["_from","",[""]]
];
if (_value isEqualTo 0 || _from isEqualTo "" || _from isEqualTo profileName) exitWith {}; //No
BANK = BANK + _value;
[1] call SOCK_fnc_updatePartial;
[ format [localize "STR_ATM_WireTransfer",_from,[_value] call life_fnc_numberText],false,"fast"] call life_fnc_notification_system;