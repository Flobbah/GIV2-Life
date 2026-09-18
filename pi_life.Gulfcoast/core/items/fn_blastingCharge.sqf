#include "..\..\script_macros.hpp"
/*
    File: fn_blastingCharge.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Blasting charge is used for the federal reserve vault and nothing  more.. Yet.
    Sicherheitsphase 0.2 Welle 2: Ob eine Ladung liegt, entscheidet der Server. Die Pruefungen hier
    sind nur die schnelle Rueckmeldung; abgelehnt gibt es die Ladung zurueck ins Inventar.
*/
private ["_vault","_handle"];
_vault = param [0,ObjNull,[ObjNull]];
if (isNull _vault) exitWith {}; //Bad object
if (typeOf _vault != "Land_CargoBox_V1_F") exitWith {[ localize "STR_ISTR_Blast_VaultOnly",true,"fast"] call life_fnc_notification_system};
if (_vault getVariable ["chargeplaced",false]) exitWith {[ localize "STR_ISTR_Blast_AlreadyPlaced",true,"fast"] call life_fnc_notification_system};
if (_vault getVariable ["safe_open",false]) exitWith {[ localize "STR_ISTR_Blast_AlreadyOpen",true,"fast"] call life_fnc_notification_system};
if (({SIDE_OF(_x) isEqualTo west} count playableUnits) < (LIFE_SETTINGS(getNumber,"minimum_cops"))) exitWith {
     [ format [localize "STR_Civ_NotEnoughCops",(LIFE_SETTINGS(getNumber,"minimum_cops"))],true,"fast"] call life_fnc_notification_system;
};
private _vaultHouse = [[["Gulfcoast", "Land_Research_house_V1_F"], ["Tanoa", "Land_Medevac_house_V1_F"]]] call TON_fnc_terrainSort;
private _altisArray = [14778.333,12362.36,0];
private _tanoaArray = [11074.2,11501.5,0.00137329];
private _pos = [[["Gulfcoast", _altisArray], ["Tanoa", _tanoaArray]]] call TON_fnc_terrainSort;
if ((nearestObject [_pos,_vaultHouse]) getVariable ["locked",true]) exitWith {[ localize "STR_ISTR_Blast_Exploit",true,"fast"] call life_fnc_notification_system};
if (INVENTORY_MODE isEqualTo 0 && {!([false,"blastingcharge",1] call life_fnc_handleInv)}) exitWith {}; //Error?
if (INVENTORY_MODE >= 1 && {life_inv_blastingcharge < 1}) exitWith {};
["TON_fnc_handleBlastingCharge", [], {
    [ localize "STR_ISTR_Blast_KeepOff",false,"fast"] call life_fnc_notification_system;
}, {
    params ["_data"];
    if (INVENTORY_MODE isEqualTo 0) then {[true,"blastingcharge",1] call life_fnc_handleInv}; //Der Server hat abgelehnt, Ladung zurueck
    switch ((_data param [0, ""])) do {
        case "open": {[ localize "STR_ISTR_Blast_AlreadyOpen",true,"fast"] call life_fnc_notification_system};
        case "placed": {[ localize "STR_ISTR_Blast_AlreadyPlaced",true,"fast"] call life_fnc_notification_system};
        case "cops": {[ format [localize "STR_Civ_NotEnoughCops",(LIFE_SETTINGS(getNumber,"minimum_cops"))],true,"fast"] call life_fnc_notification_system};
        default {[ localize "STR_ISTR_Blast_Exploit",true,"fast"] call life_fnc_notification_system};
    };
}] call life_fnc_econRequest;
