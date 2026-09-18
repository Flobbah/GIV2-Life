#include "..\..\script_macros.hpp"
/*
    File: fn_virt_sellAll.sqf
    Author: Basti | John Collins
    Description:
    Sell a virtual item to the store / shop
*/
private ["_type","_index","_price","_amount","_name"];
if ((lbCurSel 2402) isEqualTo -1) exitWith {};
_type = lbData[2402,(lbCurSel 2402)];
_price = M_CONFIG(getNumber,"VirtualItems",_type,"sellPrice");
if (_price isEqualTo -1) exitWith {};
_amount = ITEM_VALUE(_type);
if ((time - life_action_delay) < 0.2) exitWith {[localize "STR_NOTF_ActionDelay",true,"fast"] call life_fnc_notification_system;};
life_action_delay = time;
_price = (_price * _amount);
_name = M_CONFIG(getText,"VirtualItems",_type,"displayName");
//Inventar-Umbau Paket 2: ab Modus 1 nimmt der Server die Ware aus dem Inventar
if (INVENTORY_MODE >= 1 || {[false,_type,_amount] call life_fnc_handleInv}) then {
    if (ECONOMY_MODE >= 1) exitWith {
        //Geld-Umbau Schritt 3: Preis und Stundengrenze prueft der Server; ohne Zusage kommen die Gegenstaende zurueck
        ["TON_fnc_econIncome", ["sellItem", life_shop_type, _type, _amount], {
            (_this select 1) params ["_type", "_amount", "_name"];
            [ format [localize "STR_Shop_Virt_SellItem",_amount,(localize _name),[(_this select 0) param [0, 0]] call life_fnc_numberText],false,"fast"] call life_fnc_notification_system;
            ["carry", _amount * ([_type] call life_fnc_itemWeight) * (getNumber (missionConfigFile >> "CfgSkills" >> "carry" >> "xpPerWeight"))] call life_fnc_skillAddXP;
            [] call life_fnc_virt_update;
            [3] call SOCK_fnc_updatePartial;
        }, {
            (_this select 1) params ["_type", "_amount"];
            if (INVENTORY_MODE isEqualTo 0) then {[true,_type,_amount] call life_fnc_handleInv};
            [ localize "STR_NOTF_ActionCancel",true,"fast"] call life_fnc_notification_system;
            [] call life_fnc_virt_update;
            [3] call SOCK_fnc_updatePartial;
        }, [_type, _amount, _name]] call life_fnc_econRequest;
    };
    [format [localize "STR_Shop_Virt_SellItem",_amount,(localize _name),[_price] call life_fnc_numberText],false,"fast"] call life_fnc_notification_system;
    CASH = CASH + _price;
    //Skill Tragkraft: XP nach verkauftem Gewicht (nicht je Vorgang)
    ["carry", _amount * ([_type] call life_fnc_itemWeight) * (getNumber (missionConfigFile >> "CfgSkills" >> "carry" >> "xpPerWeight"))] call life_fnc_skillAddXP;
    [0] call SOCK_fnc_updatePartial;
    [] call life_fnc_virt_update;
};
if (life_shop_type isEqualTo "drugdealer") then {
    private ["_array","_ind","_val"];
    _array = life_shop_npc getVariable ["sellers",[]];
    _ind = [getPlayerUID player,_array] call TON_fnc_index;
    if (!(_ind isEqualTo -1)) then {
        _val = ((_array select _ind) select 2);
        _val = _val + _price;
        _array set[_ind,[getPlayerUID player,profileName,_val]];
        life_shop_npc setVariable ["sellers",_array,true];
    } else {
        _array pushBack [getPlayerUID player,profileName,_price];
        life_shop_npc setVariable ["sellers",_array,true];
    };
};
if (life_shop_type isEqualTo "gold" && (LIFE_SETTINGS(getNumber,"noatm_timer")) > 0) then {
    [] spawn {
        life_use_atm = false;
        sleep ((LIFE_SETTINGS(getNumber,"noatm_timer")) * 60);
        life_use_atm = true;
    };
};
[3] call SOCK_fnc_updatePartial;