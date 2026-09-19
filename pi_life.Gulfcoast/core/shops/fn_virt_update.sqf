#include "..\..\script_macros.hpp"
/*
    File: fn_virt_update.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Fuellt den Markt: links das Angebot mit Preis und Gewicht, rechts die eigene Ware mit Menge
    und dem Erloes je Stueck. Ueber den Listen stehen die Spaltenkoepfe, rechts mit der Traglast.
*/
disableSerialization;
//Setup control vars.
private _item_list = CONTROL(2400,2401);
private _gear_list = CONTROL(2400,2402);
//Purge list
lbClear _item_list;
lbClear _gear_list;
if (!isClass(missionConfigFile >> "VirtualShops" >> life_shop_type)) exitWith {closeDialog 0; [ localize "STR_NOTF_ConfigDoesNotExist",true,"fast"] call life_fnc_notification_system;}; //Make sure the entry exists..
ctrlSetText[2403,localize (M_CONFIG(getText,"VirtualShops",life_shop_type,"name"))];
ctrlSetText[2412,localize "STR_Shop_ColsOffer"];
ctrlSetText[2411,format [localize "STR_Shop_ColsOwn",life_carryWeight,life_maxWeight]];
private _shopItems = M_CONFIG(getArray,"VirtualShops",life_shop_type,"items");
{
    private _displayName = M_CONFIG(getText,"VirtualItems",_x,"displayName");
    private _price = M_CONFIG(getNumber,"VirtualItems",_x,"buyPrice");
    if (!(_price isEqualTo -1)) then {
        _item_list lbAdd format ["%1   $%2   (%3)",(localize _displayName),[_price] call life_fnc_numberText,[_x] call life_fnc_itemWeight];
        _item_list lbSetData [(lbSize _item_list)-1,_x];
        _item_list lbSetValue [(lbSize _item_list)-1,_price];
        private _icon = M_CONFIG(getText,"VirtualItems",_x,"icon");
        if (!(_icon isEqualTo "")) then {
            _item_list lbSetPicture [(lbSize _item_list)-1,_icon];
        };
    };
} forEach _shopItems;
{
    private _name = M_CONFIG(getText,"VirtualItems",_x,"displayName");
    private _val = ITEM_VALUE(_x);
    if (_val > 0) then {
        private _sell = M_CONFIG(getNumber,"VirtualItems",_x,"sellPrice");
        //Was der Laden nicht ankauft (-1), wird ohne Preis gezeigt - sonst stuende dort "$-1".
        private _line = if (_sell isEqualTo -1) then {
            format ["%1   x%2",(localize _name),_val]
        } else {
            format ["%1   x%2   $%3",(localize _name),_val,[_sell] call life_fnc_numberText]
        };
        _gear_list lbAdd _line;
        _gear_list lbSetData [(lbSize _gear_list)-1,_x];
        _gear_list lbSetValue [(lbSize _gear_list)-1,_sell];
        private _icon = M_CONFIG(getText,"VirtualItems",_x,"icon");
        if (!(_icon isEqualTo "")) then {
            _gear_list lbSetPicture [(lbSize _gear_list)-1,_icon];
        };
    };
} forEach _shopItems;
[] call life_fnc_virt_preview;
