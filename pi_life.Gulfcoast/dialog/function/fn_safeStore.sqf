#include "..\..\script_macros.hpp"
/*
    File: fn_safeStore.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Gateway copy of fn_vehStoreItem but designed for the safe.
    Sicherheitsphase 0.2 Welle 2: Den Bestand fuehrt der Server. Frueher stand hier ein getVariable
    statt setVariable, eingelagertes Gold war also einfach weg.
*/
private ["_ctrl","_num"];
disableSerialization;
_ctrl = CONTROL_DATA(3503);
_num = ctrlText 3506;
//Error checks
if (!([_num] call TON_fnc_isnumber)) exitWith {[ localize "STR_MISC_WrongNumFormat",true,"fast"] call life_fnc_notification_system;};
_num = parseNumber(_num);
if (_num < 1) exitWith {[ localize "STR_Cop_VaultUnder1",true,"fast"] call life_fnc_notification_system;};
if (!(_ctrl isEqualTo "goldBar")) exitWith {[ localize "STR_Cop_OnlyGold",true,"fast"] call life_fnc_notification_system};
if (_num > life_inv_goldbar) exitWith {[ format [localize "STR_Cop_NotEnoughGold",_num],true,"fast"] call life_fnc_notification_system;};
//Store it.
//Inventar-Umbau Paket 3: ab Modus 1 nimmt der Server die Barren aus dem Inventar
if (INVENTORY_MODE isEqualTo 0 && {!([false,_ctrl,_num] call life_fnc_handleInv)}) exitWith {[ localize "STR_Cop_CantRemove",false,"fast"] call life_fnc_notification_system;};
["TON_fnc_fedSafe", ["store", _num], {
    params ["_data"];
    life_safeObj setVariable ["safe", (_data param [1, 0])];
    if (!isNull (findDisplay 3500)) then {[life_safeObj] call life_fnc_safeInventory};
}, {
    params ["", "_ctx"];
    _ctx params ["_item", "_amount"];
    if (INVENTORY_MODE isEqualTo 0) then {[true,_item,_amount] call life_fnc_handleInv}; //Der Server hat abgelehnt, Gold zurueck ins Inventar
    [ localize "STR_NOTF_ActionCancel",true,"fast"] call life_fnc_notification_system;
}, [_ctrl, _num]] call life_fnc_econRequest;
