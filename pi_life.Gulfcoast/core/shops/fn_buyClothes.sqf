#include "..\..\script_macros.hpp"
/*
    File: fn_buyClothes.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Kauft die angezogene Zusammenstellung und schliesst den Laden.
    Wird mit spawn gerufen, weil die Rueckfrage (BIS_fnc_guiMessage) wartet.
*/
private ["_price"];
if ((lbCurSel 3101) isEqualTo -1) exitWith {titleText[localize "STR_Shop_NoClothes","PLAIN"];};

//Rueckfrage, wenn ein Platz leer bleiben soll ("Entferne Kleidung"): das alte Stueck ist danach
//weg, es gibt weder Ersatz noch Geld zurueck. Ohne die Frage kostet ein Fehlklick die Uniform.
private _worn = [uniform player, headgear player, goggles player, vest player, backpack player];
private _old = [life_oldClothes, life_oldHat, life_oldGlasses, life_oldVest, life_oldBackpack];
private _slotNames = ["STR_Shop_UI_Clothing","STR_Shop_UI_Hats","STR_Shop_UI_Glasses","STR_Shop_UI_Vests","STR_Shop_UI_Backpack"];
private _drops = [];
{
    if (!(_x isEqualTo -1)
        && {(_worn select _forEachIndex) isEqualTo ""}
        && {!((_old select _forEachIndex) isEqualTo "")}) then {
        _drops pushBack (localize (_slotNames select _forEachIndex));
    };
} forEach life_clothing_purchase;
if !(_drops isEqualTo []) then {
    private _ok = [
        format [localize "STR_Shop_ConfirmRemove",_drops joinString ", "],
        localize "STR_Shop_ConfirmRemoveTitle",
        localize "STR_Global_Yes",
        localize "STR_Global_No"
    ] call BIS_fnc_guiMessage;
    if (!_ok) exitWith {};
};

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
