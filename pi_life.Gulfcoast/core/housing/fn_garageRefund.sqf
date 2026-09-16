#include "..\..\script_macros.hpp"
/*
    File: fn_garageRefund.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    I don't know?
*/
SERVER_ONLY_REMOTE; //Sicherheitsphase 0.1: nur der Server darf diese Funktion remote aufrufen
if (ECONOMY_MODE >= 1) exitWith {}; //Geld-Umbau Schritt 2: der Server bucht die Gebuehr erst beim erfolgreichen Ausparken
_price = _this select 0;
_unit = _this select 1;
if !(_unit isEqualTo player) exitWith {};
BANK = BANK + _price;
[1] call SOCK_fnc_updatePartial;
