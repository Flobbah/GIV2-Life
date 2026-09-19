#include "..\..\script_macros.hpp"
/*
    File: fn_weaponShopSelection.sqf
    Author: Bryan "Tonic" Boardwine
    Edited: mohsen98
    Description:
    Fuellt die rechte Spalte des Waffenladens: Bild, Name, Preis und Kurzbeschreibung des
    ausgewaehlten Gegenstands. Reicht das Bargeld nicht, steht dort, wie viel fehlt.
    Prueft ausserdem, ob es zur gewaehlten Waffe Magazine und Zubehoer im Laden gibt.
*/
private ["_control","_index","_shop","_priceTag","_price","_item","_itemArray","_bool"];
_control = [_this,0,controlNull,[controlNull]] call BIS_fnc_param;
_index = [_this,1,-1,[0]] call BIS_fnc_param;
_shop = uiNamespace getVariable ["Weapon_Shop",""];
if (isNull _control) exitWith {closeDialog 0;}; //Bad data
if (_index isEqualTo -1) exitWith {}; //Nothing selected
_priceTag = CONTROL(38400,38404);
private _selling = (uiNamespace getVariable ["Weapon_Shop_Filter",0]) isEqualTo 1;
if (_selling) then {
    _item = CONTROL_DATAI(_control,_index);
    _itemArray = M_CONFIG(getArray,"WeaponShops",_shop,"items");
    _itemArray append M_CONFIG(getArray,"WeaponShops",_shop,"mags");
    _itemArray append M_CONFIG(getArray,"WeaponShops",_shop,"accs");
    _item = [_item,_itemArray] call TON_fnc_index;
    _price = ((_itemArray select _item) select 3);
    _control lbSetValue[_index,_price];
} else {
    _price = _control lbValue _index;
};
//Bild, Name und Kurzbeschreibung zum Eintrag
private _class = CONTROL_DATAI(_control,_index);
private _details = [_class] call life_fnc_fetchCfgDetails;
private _name = if (count _details > 1) then {_details select 1} else {_class};
private _picture = if (count _details > 2) then {_details select 2} else {""};
private _desc = if (count _details > 9) then {_details select 9} else {""};
private _priceLine = format [
    "<t size='1.0'>%1 <t color='#8cff9b'>$%2</t></t>",
    localize "STR_GNOTF_Price",
    [_price] call life_fnc_numberText
];
if (!_selling && {_price > CASH}) then {
    _priceLine = format [
        "<t size='1.0'>%1 <t color='#ff6b6b'>$%2</t></t><br/><t size='0.9' color='#e6a23c'>%3</t>",
        localize "STR_GNOTF_Price",
        [_price] call life_fnc_numberText,
        format [localize "STR_Shop_Lacks",[_price - CASH] call life_fnc_numberText]
    ];
};
_priceTag ctrlSetStructuredText parseText format [
    "<t align='center'><img size='5' image='%1'/><br/><t size='1.15'>%2</t><br/><br/>%3</t><br/><br/><t size='0.9' color='#aeb3bd'>%4</t>",
    _picture,
    _name,
    _priceLine,
    _desc
];
if (!_selling) then {
    _item = _class;
    if ((uiNamespace getVariable ["Weapon_Magazine",0]) isEqualTo 0 && (uiNamespace getVariable ["Weapon_Accessories",0]) isEqualTo 0) then {
        if (isClass (configFile >> "CfgWeapons" >> _item)) then {
            //Magazines menu
            if (isArray (configFile >> "CfgWeapons" >> _item >> "magazines")) then {
                _itemArray = FETCH_CONFIG2(getArray,"CfgWeapons",_item,"magazines");
                _bool = false;
                {
                    _var = _x select 0;
                    _count = {_x == _var} count _itemArray;
                    if (_count > 0) exitWith {_bool = true};
                } forEach M_CONFIG(getArray,"WeaponShops",_shop,"mags");
                if (_bool) then {
                    ((findDisplay 38400) displayCtrl 38406) ctrlEnable true;
                } else {
                    ((findDisplay 38400) displayCtrl 38406) ctrlEnable false;
                };
            } else {
                ((findDisplay 38400) displayCtrl 38406) ctrlEnable false;
            };
            //Accessories Menu
            _itemArray = _item call BIS_fnc_compatibleItems;
            _bool = false;
            {
                _var = _x select 0;
                _count = {_x == _var} count _itemArray;
                if (_count > 0) exitWith {_bool = true};
            } forEach M_CONFIG(getArray,"WeaponShops",_shop,"accs");
            if (_bool) then {
                ((findDisplay 38400) displayCtrl 38407) ctrlEnable true;
            } else {
                ((findDisplay 38400) displayCtrl 38407) ctrlEnable false;
            };
        } else {
            ((findDisplay 38400) displayCtrl 38406) ctrlEnable false;
            ((findDisplay 38400) displayCtrl 38407) ctrlEnable false;
        };
    };
};
