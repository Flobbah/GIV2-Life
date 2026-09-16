#include "..\..\script_macros.hpp"
/*
    File: fn_ticketPaid.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Verifies that the ticket was paid.
*/
RELAY_ONLY_REMOTE; //Sicherheitsphase 0.1b: Aufrufe anderer Spieler nur ueber den Server (CfgRelay)
if (ECONOMY_MODE >= 1) exitWith {}; //Geld-Umbau Schritt 2: Strafzettel bucht der Server (TON_fnc_econJustice)
params [
    ["_value",5,[0]],
    ["_unit",objNull,[objNull]],
    ["_cop",objNull,[objNull]]
];
if (isNull _unit || {!(_unit isEqualTo life_ticket_unit)}) exitWith {}; //NO
if (isNull _cop || {!(_cop isEqualTo player)}) exitWith {}; //Double NO
BANK = BANK + _value;
[1] call SOCK_fnc_updatePartial;
