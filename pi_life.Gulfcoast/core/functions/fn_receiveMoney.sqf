#include "..\..\script_macros.hpp"
/*
    File: fn_receiveMoney.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Receives money
*/
RELAY_ONLY_REMOTE; //Sicherheitsphase 0.1b: Aufrufe anderer Spieler nur ueber den Server (CfgRelay)
if (ECONOMY_MODE >= 1) exitWith {}; //Geld-Umbau Schritt 2: Geld geben bucht der Server (TON_fnc_econPlayer)
params [
    ["_unit",objNull,[objNull]],
    ["_val","",[""]],
    ["_from",objNull,[objNull]]
];
if (isNull _unit || isNull _from || _val isEqualTo "") exitWith {};
if !(player isEqualTo _unit) exitWith {};
if (!([_val] call TON_fnc_isnumber)) exitWith {};
if (_unit == _from) exitWith {}; //Bad boy, trying to exploit his way to riches.
[ format [localize "STR_NOTF_GivenMoney",_from getVariable ["realname",name _from],[(parseNumber (_val))] call life_fnc_numberText],true,"fast"] call life_fnc_notification_system;
CASH = CASH + parseNumber(_val);
[0] call SOCK_fnc_updatePartial;