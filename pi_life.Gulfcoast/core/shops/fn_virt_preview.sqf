#include "..\..\script_macros.hpp"
/*
    File: fn_virt_preview.sqf
    Description:
    Zeigt unter den Listen des Marktes, was der Einkauf kostet und wiegt und was der Verkauf
    einbringt - bevor man den Knopf drueckt. Wird bei jeder Auswahl und jeder Eingabe gerufen.

    Passt die Menge nicht ins Inventar oder reicht das Bargeld nicht, steht das in der Zeile;
    gekauft wird trotzdem, was passt (das macht life_fnc_virt_buy wie bisher).
*/
disableSerialization;
private _display = findDisplay 2400;
if (isNull _display) exitWith {};
private _buyInfo = _display displayCtrl 2406;
private _sellInfo = _display displayCtrl 2410;

//Eingabefeld: leer oder keine Zahl zaehlt als nichts ausgewaehlt
private _amountOf = {
    params ["_idc"];
    private _text = ctrlText (_display displayCtrl _idc);
    if !([_text] call TON_fnc_isnumber) exitWith {0};
    round (parseNumber _text)
};

//Kaufen
private _line = "";
private _sel = lbCurSel (_display displayCtrl 2401);
private _amount = [2404] call _amountOf;
if (_sel > -1 && {_amount > 0}) then {
    private _type = lbData [2401,_sel];
    private _price = lbValue [2401,_sel];
    private _weight = ([_type] call life_fnc_itemWeight) * _amount;
    private _fits = [_type,_amount,life_carryWeight,life_maxWeight] call life_fnc_calWeightDiff;
    _line = format [
        localize "STR_Shop_PreviewBuy",
        _amount,
        localize (M_CONFIG(getText,"VirtualItems",_type,"displayName")),
        [_price * _amount] call life_fnc_numberText,
        _weight
    ];
    if (_fits < _amount) then {
        _line = format ["%1<br/><t color='#e6a23c'>%2</t>",_line,format [localize "STR_Shop_PreviewFits",_fits max 0]];
    } else {
        if ((_price * _amount) > CASH) then {
            _line = format ["%1<br/><t color='#e6a23c'>%2</t>",_line,localize "STR_Shop_PreviewCash"];
        };
    };
};
_buyInfo ctrlSetStructuredText parseText _line;

//Verkaufen
_line = "";
_sel = lbCurSel (_display displayCtrl 2402);
_amount = [2405] call _amountOf;
if (_sel > -1 && {_amount > 0}) then {
    private _type = lbData [2402,_sel];
    private _price = lbValue [2402,_sel];
    private _owned = ITEM_VALUE(_type);
    if (_price isEqualTo -1) then {
        _line = format ["<t color='#e6a23c'>%1</t>",localize "STR_Shop_PreviewNoBuyer"];
    } else {
        _line = format [
            localize "STR_Shop_PreviewSell",
            _amount min _owned,
            localize (M_CONFIG(getText,"VirtualItems",_type,"displayName")),
            [_price * (_amount min _owned)] call life_fnc_numberText
        ];
        if (_amount > _owned) then {
            _line = format ["%1<br/><t color='#e6a23c'>%2</t>",_line,format [localize "STR_Shop_PreviewOwned",_owned]];
        };
    };
};
_sellInfo ctrlSetStructuredText parseText _line;
