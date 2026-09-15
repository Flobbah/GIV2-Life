#include "..\..\script_macros.hpp"
/*
    File: fn_markerFilterToggle.sqf
    Description:
    Schalter in der Telefon-App "Karte": Kategorie ein- oder ausblenden, Auswahl im Profil
    speichern und sofort auf die Karte anwenden.
    Parameter:
        0: NUMBER oder CONTROL - Zeilenindex der Kategorie (-1 = alle) oder die Checkbox selbst
                                 (Index = IDC - 2951)
        1: BOOL oder NUMBER    - true/1 = anzeigen, false/0 = ausblenden
*/
params [["_index",-1,[0,controlNull]],["_show",true,[true,0]]];
if (_index isEqualType controlNull) then {
    if (isNull _index) exitWith {};
    _index = (ctrlIDC _index) - 2951;
};
//onCheckedChanged der Checkbox liefert 0/1 statt true/false
if (_show isEqualType 0) then {_show = _show isEqualTo 1;};
if (missionNamespace getVariable ["life_markerFilter_updating",false]) exitWith {};
if (isNil "life_markerFilter_map") then {[] call life_fnc_markerFilterApply;};
private _hidden = profileNamespace getVariable ["life_markerFilter_hidden",[]];
if !(_hidden isEqualType []) then {_hidden = [];};
private _cats = if (_index < 0) then {
    life_markerFilter_map apply {_x select 0}
} else {
    if (_index >= count life_markerFilter_map) exitWith {[]};
    [(life_markerFilter_map select _index) select 0]
};
{
    if (_show) then {
        _hidden deleteAt (_hidden find _x);
    } else {
        _hidden pushBackUnique _x;
    };
} forEach _cats;
profileNamespace setVariable ["life_markerFilter_hidden",_hidden];
saveProfileNamespace;
[] call life_fnc_markerFilterApply;
//Bei "alle" die Schalter im Dialog nachziehen
if (_index < 0 && {!isNull (findDisplay 2950)}) then {
    disableSerialization;
    life_markerFilter_updating = true;
    for "_i" from 0 to ((count life_markerFilter_map) min 8) - 1 do {
        ((findDisplay 2950) displayCtrl (2951 + _i)) cbSetChecked _show;
    };
    life_markerFilter_updating = false;
};
