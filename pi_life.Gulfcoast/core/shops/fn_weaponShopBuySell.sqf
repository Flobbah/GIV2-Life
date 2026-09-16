#include "..\..\script_macros.hpp"
/*
    File: fn_weaponShopBuySell.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Master handling of the weapon shop for buying / selling an item.
*/
disableSerialization;
private ["_price","_item","_itemInfo","_bad"];
if ((lbCurSel 38403) isEqualTo -1) exitWith {[ localize "STR_Shop_Weapon_NoSelect",true,"fast"] call life_fnc_notification_system};
_price = lbValue[38403,(lbCurSel 38403)]; if (isNil "_price") then {_price = 0;};
_item = lbData[38403,(lbCurSel 38403)];
_itemInfo = [_item] call life_fnc_fetchCfgDetails;
_bad = "";
if ((_itemInfo select 6) != "CfgVehicles") then {
    if ((_itemInfo select 4) in [4096,131072]) then {
        if (!(player canAdd _item) && (uiNamespace getVariable ["Weapon_Shop_Filter",0]) != 1) exitWith {_bad = (localize "STR_NOTF_NoRoom")};
    };
};
if (_bad != "") exitWith {[ _bad,true,"fast"] call life_fnc_notification_system};
if ((uiNamespace getVariable ["Weapon_Shop_Filter",0]) isEqualTo 1) then {
    CASH = CASH + _price;
    [_item,false] call life_fnc_handleItem;
    [ parseText format [localize "STR_Shop_Weapon_Sold",_itemInfo select 1,[_price] call life_fnc_numberText],false,"fast"] call life_fnc_notification_system;
    [nil,(uiNamespace getVariable ["Weapon_Shop_Filter",0])] call life_fnc_weaponShopFilter; //Update the menu.
} else {
    private _altisArray = ["Land_u_Barracks_V2_F","Land_i_Barracks_V2_F"];
    private _tanoaArray = ["Land_School_01_F","Land_Warehouse_03_F","Land_House_Small_02_F"];
    private _hideoutObjs = [[["Gulfcoast", _altisArray], ["Tanoa", _tanoaArray]]] call TON_fnc_terrainSort;
    private _hideout = (nearestObjects[getPosATL player,_hideoutObjs,25]) select 0;
    if (!isNil "_hideout" && {!isNil {group player getVariable "gang_bank"}} && {(group player getVariable "gang_bank") >= _price}) then {
        _action = [
            format [(localize "STR_Shop_Virt_Gang_FundsMSG")+ "<br/><br/>" +(localize "STR_Shop_Virt_Gang_Funds")+ " <t color='#8cff9b'>$%1</t><br/>" +(localize "STR_Shop_Virt_YourFunds")+ " <t color='#8cff9b'>$%2</t>",
                [(group player getVariable "gang_bank")] call life_fnc_numberText,
                [CASH] call life_fnc_numberText
            ],
            localize "STR_Shop_Virt_YourorGang",
            localize "STR_Shop_Virt_UI_GangFunds",
            localize "STR_Shop_Virt_UI_YourCash"
        ] call BIS_fnc_guiMessage;
        if (_action) then {
            if (ECONOMY_MODE >= 1) then {
                //Geld-Umbau Schritt 2: die Gangkasse bucht der Server (Mitglied laut Datenbank, am Versteck)
                ["TON_fnc_econShop", ["weapon", uiNamespace getVariable ["Weapon_Shop",""], _item, 1, true], {
                    (_this select 1) params ["_item", "_itemName", "_price"];
                    [ parseText format [localize "STR_Shop_Weapon_BoughtGang",_itemName,[_price] call life_fnc_numberText],false,"fast"] call life_fnc_notification_system;
                    [_item,true] call life_fnc_handleItem;
                    [3] call SOCK_fnc_updatePartial;
                }, {
                    [ localize "STR_NOTF_NotEnoughMoney",true,"fast"] call life_fnc_notification_system;
                }, [_item, _itemInfo select 1, _price]] call life_fnc_econRequest;
            } else {
                [ parseText format [localize "STR_Shop_Weapon_BoughtGang",_itemInfo select 1,[_price] call life_fnc_numberText],false,"fast"] call life_fnc_notification_system;
                _funds = group player getVariable "gang_bank";
                _funds = _funds - _price;
                group player setVariable ["gang_bank",_funds,true];
                [_item,true] call life_fnc_handleItem;
                if (LIFE_HC_ACTIVE) then {
                    [1,group player] remoteExecCall ["HC_fnc_updateGang",HC_Life];
                } else {
                    [1,group player] remoteExecCall ["TON_fnc_updateGang",RSERV];
                };
            };
        } else {
            if (_price > CASH) exitWith {[ localize "STR_NOTF_NotEnoughMoney",true,"fast"] call life_fnc_notification_system};
            if (ECONOMY_MODE >= 1) then {
                //Geld-Umbau Schritt 2: der Server bucht den Preis aus Config_Weapons, die Ware gibt es nach seiner Zusage
                ["TON_fnc_econShop", ["weapon", uiNamespace getVariable ["Weapon_Shop",""], _item], {
                    (_this select 1) params ["_item", "_itemName", "_price"];
                    [ parseText format [localize "STR_Shop_Weapon_BoughtItem",_itemName,[_price] call life_fnc_numberText],false,"fast"] call life_fnc_notification_system;
                    [_item,true] call life_fnc_handleItem;
                    [3] call SOCK_fnc_updatePartial;
                }, {
                    [ localize "STR_NOTF_NotEnoughMoney",true,"fast"] call life_fnc_notification_system;
                }, [_item, _itemInfo select 1, _price]] call life_fnc_econRequest;
            } else {
                [ parseText format [localize "STR_Shop_Weapon_BoughtItem",_itemInfo select 1,[_price] call life_fnc_numberText],false,"fast"] call life_fnc_notification_system;
                CASH = CASH - _price;
                [_item,true] call life_fnc_handleItem;
            };
        };
    } else {
        if (_price > CASH) exitWith {[ localize "STR_NOTF_NotEnoughMoney",true,"fast"] call life_fnc_notification_system};
        if (ECONOMY_MODE >= 1) then {
            //Geld-Umbau Schritt 2: der Server bucht den Preis aus Config_Weapons, die Ware gibt es nach seiner Zusage
            ["TON_fnc_econShop", ["weapon", uiNamespace getVariable ["Weapon_Shop",""], _item], {
                (_this select 1) params ["_item", "_itemName", "_price"];
                [ parseText format [localize "STR_Shop_Weapon_BoughtItem",_itemName,[_price] call life_fnc_numberText],false,"fast"] call life_fnc_notification_system;
                [_item,true] call life_fnc_handleItem;
                [3] call SOCK_fnc_updatePartial;
            }, {
                [ localize "STR_NOTF_NotEnoughMoney",true,"fast"] call life_fnc_notification_system;
            }, [_item, _itemInfo select 1, _price]] call life_fnc_econRequest;
        } else {
            [ parseText format [localize "STR_Shop_Weapon_BoughtItem",_itemInfo select 1,[_price] call life_fnc_numberText],false,"fast"] call life_fnc_notification_system;
            CASH = CASH - _price;
            [_item,true] call life_fnc_handleItem;
        };
    };
};
[0] call SOCK_fnc_updatePartial;
[3] call SOCK_fnc_updatePartial;
