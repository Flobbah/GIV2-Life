#include "..\..\script_macros.hpp"
/*
    File: fn_shopStatus.sqf
    Description:
    Zeigt Konto und Bargeld in der Titelleiste eines Laden-Dialogs (IDC 9810) und haelt die
    Anzeige aktuell, solange der Laden offen ist. Damit sieht man beim Kaufen sofort, was ein
    Einkauf gekostet hat, ohne das Telefon zu oeffnen.
    Wird aus dem onLoad der Laden-Dialoge mit [_this select 0] aufgerufen.

    Parameter:
        0: DISPLAY - der geoeffnete Dialog
*/
params [["_display",displayNull,[displayNull]]];
if (isNull _display) exitWith {};
[_display] spawn {
    params ["_display"];
    disableSerialization;
    private _money = _display displayCtrl 9810;
    if (isNull _money) exitWith {};
    private _last = [-1,-1];
    while {!isNull _display} do {
        //Nur neu zeichnen, wenn sich etwas geaendert hat - der Dialog steht sonst still.
        if !(_last isEqualTo [CASH,BANK]) then {
            _last = [CASH,BANK];
            _money ctrlSetStructuredText parseText format [
                "<t align='right'><img size='1.0' image='\pi_data\icons\ico_bank.paa'/> $%1      <img size='1.0' image='\pi_data\icons\ico_money.paa'/> $%2</t>",
                [BANK] call life_fnc_numberText,
                [CASH] call life_fnc_numberText
            ];
        };
        sleep 1;
    };
};
