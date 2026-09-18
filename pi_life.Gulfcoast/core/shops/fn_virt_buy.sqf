#include "..\..\script_macros.hpp"
/*
    File: fn_virt_buy.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Buy a virtual item from the store.
*/
private ["_type","_price","_amount","_diff","_name","_hideout"];
if ((lbCurSel 2401) isEqualTo -1) exitWith {[ localize "STR_Shop_Virt_Nothing",true,"fast"] call life_fnc_notification_system};
_type = lbData[2401,(lbCurSel 2401)];
_price = lbValue[2401,(lbCurSel 2401)];
_amount = ctrlText 2404;
if (!([_amount] call TON_fnc_isnumber)) exitWith {[ localize "STR_Shop_Virt_NoNum",true,"fast"] call life_fnc_notification_system;};
_diff = [_type,parseNumber(_amount),life_carryWeight,life_maxWeight] call life_fnc_calWeightDiff;
_amount = parseNumber(_amount);
if (_diff <= 0) exitWith {[ localize "STR_NOTF_NoSpace",true,"fast"] call life_fnc_notification_system};
_amount = _diff;
private _altisArray = ["Land_u_Barracks_V2_F","Land_i_Barracks_V2_F"];
private _tanoaArray = ["Land_School_01_F","Land_Warehouse_03_F","Land_House_Small_02_F"];
private _hideoutObjs = [[["Gulfcoast", _altisArray], ["Tanoa", _tanoaArray]]] call TON_fnc_terrainSort;
_hideout = (nearestObjects[getPosATL player,_hideoutObjs,25]) select 0;
if ((_price * _amount) > CASH && {!isNil "_hideout" && {!isNil {group player getVariable "gang_bank"}} && {(group player getVariable "gang_bank") <= _price * _amount}}) exitWith {[ localize "STR_NOTF_NotEnoughMoney",true,"fast"] call life_fnc_notification_system};
if ((time - life_action_delay) < 0.2) exitWith {[ localize "STR_NOTF_ActionDelay",true,"fast"] call life_fnc_notification_system;};
life_action_delay = time;
_name = M_CONFIG(getText,"VirtualItems",_type,"displayName");
//Inventar-Umbau Paket 3: ab Modus 1 bucht der Server die Ware nach der Bezahlung
if (INVENTORY_MODE >= 1 || {[true,_type,_amount] call life_fnc_handleInv}) then {
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
            [ format [localize "STR_Shop_Virt_BoughtGang",_amount,(localize _name),[(_price * _amount)] call life_fnc_numberText],false,"fast"] call life_fnc_notification_system;
            if (ECONOMY_MODE >= 1) then {
                //Geld-Umbau Schritt 2: die Gangkasse bucht der Server (Mitglied laut Datenbank, am Versteck)
                ["TON_fnc_econShop", ["virtual", life_shop_type, _type, _amount, true], {
                    [] call life_fnc_virt_update;
                }, {
                    (_this select 1) params ["_type", "_amount"];
                    if (INVENTORY_MODE isEqualTo 0) then {[false,_type,_amount] call life_fnc_handleInv};
                    [ localize "STR_NOTF_NotEnoughMoney",true,"fast"] call life_fnc_notification_system;
                    [] call life_fnc_virt_update;
                    [3] call SOCK_fnc_updatePartial;
                }, [_type, _amount]] call life_fnc_econRequest;
            } else {
                _funds = group player getVariable "gang_bank";
                _funds = _funds - (_price * _amount);
                group player setVariable ["gang_bank",_funds,true];
                if (LIFE_HC_ACTIVE) then {
                    [1,group player] remoteExecCall ["HC_fnc_updateGang",HC_Life];
                } else {
                    [1,group player] remoteExecCall ["TON_fnc_updateGang",RSERV];
                };
            };
        } else {
            if ((_price * _amount) > CASH) exitWith {if (INVENTORY_MODE isEqualTo 0) then {[false,_type,_amount] call life_fnc_handleInv}; [ localize "STR_NOTF_NotEnoughMoney",true,"fast"] call life_fnc_notification_system;};
            [ format [localize "STR_Shop_Virt_BoughtItem",_amount,(localize _name),[(_price * _amount)] call life_fnc_numberText],false,"fast"] call life_fnc_notification_system;
            if (ECONOMY_MODE >= 1) then {
                //Geld-Umbau Schritt 2: der Server bucht den Preis aus Config_vItems; ohne Zusage werden die Gegenstaende wieder entfernt
                ["TON_fnc_econShop", ["virtual", life_shop_type, _type, _amount], {
                    [] call life_fnc_virt_update;
                }, {
                    (_this select 1) params ["_type", "_amount"];
                    if (INVENTORY_MODE isEqualTo 0) then {[false,_type,_amount] call life_fnc_handleInv};
                    [ localize "STR_NOTF_NotEnoughMoney",true,"fast"] call life_fnc_notification_system;
                    [] call life_fnc_virt_update;
                    [3] call SOCK_fnc_updatePartial;
                }, [_type, _amount]] call life_fnc_econRequest;
            } else {
                CASH = CASH - _price * _amount;
            };
        };
    } else {
        if ((_price * _amount) > CASH) exitWith {[ localize "STR_NOTF_NotEnoughMoney",true,"fast"] call life_fnc_notification_system; if (INVENTORY_MODE isEqualTo 0) then {[false,_type,_amount] call life_fnc_handleInv};}; //vorher true: Gegenstaende doppelt statt entfernt
        [ format [localize "STR_Shop_Virt_BoughtItem",_amount,(localize _name),[(_price * _amount)] call life_fnc_numberText],false,"fast"] call life_fnc_notification_system;
        if (ECONOMY_MODE >= 1) then {
            //Geld-Umbau Schritt 2: der Server bucht den Preis aus Config_vItems; ohne Zusage werden die Gegenstaende wieder entfernt
            ["TON_fnc_econShop", ["virtual", life_shop_type, _type, _amount], {
                [] call life_fnc_virt_update;
            }, {
                (_this select 1) params ["_type", "_amount"];
                if (INVENTORY_MODE isEqualTo 0) then {[false,_type,_amount] call life_fnc_handleInv};
                [ localize "STR_NOTF_NotEnoughMoney",true,"fast"] call life_fnc_notification_system;
                [] call life_fnc_virt_update;
                [3] call SOCK_fnc_updatePartial;
            }, [_type, _amount]] call life_fnc_econRequest;
        } else {
            CASH = CASH - _price * _amount;
        };
    };
    [] call life_fnc_virt_update;
};
[0] call SOCK_fnc_updatePartial;
[3] call SOCK_fnc_updatePartial;
