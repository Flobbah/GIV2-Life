#include "..\..\script_macros.hpp"
/*
    File: fn_markerFilterMenu.sqf
    Description:
    Fuellt die Telefon-App "Karte" (Dialog 2950): eine Zeile je Kategorie mit Name,
    Markeranzahl und Schalter. Nicht belegte Zeilen werden ausgeblendet.
*/
disableSerialization;
waitUntil {!isNull (findDisplay 2950)};
private _display = findDisplay 2950;
[] call life_fnc_markerFilterApply;
private _hidden = profileNamespace getVariable ["life_markerFilter_hidden",[]];
if !(_hidden isEqualType []) then {_hidden = [];};
life_markerFilter_updating = true;
for "_i" from 0 to 7 do {
    private _row = _display displayCtrl (2981 + _i);
    private _label = _display displayCtrl (2971 + _i);
    private _check = _display displayCtrl (2951 + _i);
    if (_i < count life_markerFilter_map) then {
        (life_markerFilter_map select _i) params ["_cat","_nameKey","_markers"];
        _label ctrlSetText format [localize "STR_MF_Count",localize _nameKey,count _markers];
        _check cbSetChecked !(_cat in _hidden);
        {_x ctrlShow true;} forEach [_row,_label,_check];
    } else {
        {_x ctrlShow false;} forEach [_row,_label,_check];
    };
};
life_markerFilter_updating = false;
