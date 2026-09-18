#include "..\..\script_macros.hpp"
/*
    File: fn_safeTake.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Gateway to fn_vehTakeItem.sqf but for safe(s).
    Sicherheitsphase 0.2 Welle 2: Den Bestand fuehrt der Server, ausgegeben wird erst nach seiner Zusage.
*/
private ["_ctrl","_num","_safeInfo"];
disableSerialization;
if ((lbCurSel 3502) isEqualTo -1) exitWith {[ localize "STR_Civ_SelectItem",true,"fast"] call life_fnc_notification_system;};
_ctrl = CONTROL_DATA(3502);
_num = ctrlText 3505;
_safeInfo = life_safeObj getVariable ["safe",0];
//Error checks
if (!([_num] call TON_fnc_isnumber)) exitWith {[ localize "STR_MISC_WrongNumFormat",true,"fast"] call life_fnc_notification_system;};
_num = parseNumber(_num);
if (_num < 1) exitWith {[ localize "STR_Cop_VaultUnder1",true,"fast"] call life_fnc_notification_system;};
if (!(_ctrl isEqualTo "goldBar")) exitWith {[ localize "STR_Cop_OnlyGold",true,"fast"] call life_fnc_notification_system};
if (_num > _safeInfo) exitWith {[ format [localize "STR_Civ_IsntEnoughGold",_num],true,"fast"] call life_fnc_notification_system;};
//Secondary checks
_num = [_ctrl,_num,life_carryWeight,life_maxWeight] call life_fnc_calWeightDiff;
if (_num isEqualTo 0) exitWith {[ localize "STR_NOTF_InvFull",true,"fast"] call life_fnc_notification_system};
//Take it
["TON_fnc_fedSafe", ["take", _num], {
    params ["_data", "_ctx"];
    _data params [["_got", 0], ["_left", 0]];
    _ctx params ["_item"];
    life_safeObj setVariable ["safe", _left]; //Anzeige sofort, der Server schickt denselben Wert nach
    //Inventar-Umbau Paket 3: ab Modus 1 bucht der Server die Barren
    if (INVENTORY_MODE isEqualTo 0 && {!([true,_item,_got] call life_fnc_handleInv)}) exitWith {[ localize "STR_NOTF_CouldntAdd",true,"fast"] call life_fnc_notification_system;};
    if (!isNull (findDisplay 3500)) then {[life_safeObj] call life_fnc_safeInventory};
}, {
    params ["_data"];
    if (((_data param [0, ""]) isEqualTo "amount")) then {
        [ format [localize "STR_Civ_IsntEnoughGold",(_data param [1, 0])],true,"fast"] call life_fnc_notification_system;
    } else {
        [ localize "STR_Civ_VaultEmpty",true,"fast"] call life_fnc_notification_system;
    };
}, [_ctrl]] call life_fnc_econRequest;
