#include "..\..\script_macros.hpp"
/*
    File: fn_buyClothes.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Buys the current set of clothes and closes out of the shop interface.
*/
private ["_price"];
if ((lbCurSel 3101) isEqualTo -1) exitWith {titleText[localize "STR_Shop_NoClothes","PLAIN"];};
_price = 0;
{
    if (!(_x isEqualTo -1)) then {
        _price = _price + _x;
    };
} forEach life_clothing_purchase;
if (_price > CASH) exitWith {titleText[localize "STR_Shop_NotEnoughClothes","PLAIN"];};
if (ECONOMY_MODE >= 1) exitWith {
    //Geld-Umbau Schritt 2: der Server berechnet den Preis aus Config_Clothing anhand der angezogenen Vorschau
    ["TON_fnc_econShop", ["clothing", life_clothing_store, life_clothing_purchase apply {!(_x isEqualTo -1)}], {
        life_clothesPurchased = true;
        [] call life_fnc_playerSkins;
        closeDialog 0;
    }, {
        titleText[localize "STR_Shop_NotEnoughClothes","PLAIN"];
    }] call life_fnc_econRequest;
};
CASH = CASH - _price;
[0] call SOCK_fnc_updatePartial;
life_clothesPurchased = true;
[] call life_fnc_playerSkins;
closeDialog 0;