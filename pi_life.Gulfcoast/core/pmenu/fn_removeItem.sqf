#include "..\..\script_macros.hpp"
/*
    File: fn_removeItem.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Removes the selected item & amount to remove from the players
    virtual inventory.
*/
private ["_data","_value","_obj"];
disableSerialization;
_data = lbData[2005,(lbCurSel 2005)];
_value = ctrlText 2010;
if (_data isEqualTo "") exitWith {[ localize "STR_NOTF_didNotSelectToRemove",true,"fast"] call life_fnc_notification_system;};
if (!([_value] call TON_fnc_isnumber)) exitWith {[ localize "STR_NOTF_notNumberFormat",true,"fast"] call life_fnc_notification_system;};
if (parseNumber(_value) <= 0) exitWith {[ localize "STR_NOTF_enterAmountRemove",true,"fast"] call life_fnc_notification_system;};
if (ITEM_ILLEGAL(_data) isEqualTo 1 && ([west,visiblePosition player,100] call life_fnc_nearUnits)) exitWith {titleText[localize "STR_NOTF_illegalItemCannotDispose","PLAIN"]};
if !(isNull objectParent player) exitWith {titleText[localize "STR_NOTF_cannotRemoveInVeh","PLAIN"]};
//Inventar-Umbau Paket 3: ab Modus 1 nimmt der Server die Gegenstaende aus dem Inventar
if (INVENTORY_MODE >= 1) exitWith {
    ["TON_fnc_invDrop", [_data, parseNumber _value], {
        (_this select 1) params ["_item"];
        [ format [localize "STR_NOTF_removedFromInventory",((_this select 0) param [0, 0]),(localize ITEM_NAME(_item))],false,"fast"] call life_fnc_notification_system;
        [] call life_fnc_p_updateMenu;
    }, {
        [ localize "STR_NOTF_couldNotRemoveThatMuch",true,"fast"] call life_fnc_notification_system;
    }, [_data]] call life_fnc_econRequest;
};
if (!([false,_data,(parseNumber _value)] call life_fnc_handleInv)) exitWith {[ localize "STR_NOTF_couldNotRemoveThatMuch",true,"fast"] call life_fnc_notification_system;};
[ format [localize "STR_NOTF_removedFromInventory",(parseNumber _value),(localize ITEM_NAME(_data))],false,"fast"] call life_fnc_notification_system;
[] call life_fnc_p_updateMenu;
