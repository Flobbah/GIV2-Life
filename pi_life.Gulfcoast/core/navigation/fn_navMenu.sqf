#include "..\..\script_macros.hpp"
/*
    File: fn_navMenu.sqf
    Description:
    Fuellt die Telefon-App "Navi" (Dialog 2970): aktuelle Route und eine nach Entfernung
    sortierte Liste aller beschrifteten Kartenmarker (plus dem Lieferziel, falls ein Auftrag laeuft).
    Die Liste liegt in life_nav_list als [[Name, Position], ...]; die Listenzeile speichert den Index.
    Hält die Routenanzeige aktuell, solange der Dialog offen ist.
*/
disableSerialization;
waitUntil {!isNull (findDisplay 2970)};
private _display = findDisplay 2970;
private _list = _display displayCtrl 2972;
lbClear _list;
life_nav_list = [];
private _me = getPosATL player;
//Lieferziel zuerst
if ((missionNamespace getVariable ["life_delivery_in_progress",false]) && {!isNil "life_dp_point"} && {!isNull life_dp_point}) then {
    life_nav_list pushBack [format [localize "STR_NAV_DeliveryTarget",toUpper ((str life_dp_point splitString "_") joinString " ")], getPosATL life_dp_point];
};
private _entries = [];
{
    private _text = markerText _x;
    //Missionsmarker liefern den rohen Stringtable-Verweis ("@STR_..."), hier uebersetzen
    if ((_text select [0,1]) isEqualTo "@") then {
        private _key = _text select [1];
        if (isLocalized _key) then {_text = localize _key;} else {_text = "";};
    };
    if (!(_text isEqualTo "") && {!((markerType _x) isEqualTo "")} && {!((toLower _x) find "_marker" > -1)}) then {
        private _pos = markerPos _x;
        _entries pushBack [_text, _pos, _me distance2D _pos];
    };
} forEach allMapMarkers;
_entries sort true; //nach Text, dann Entfernung
_entries = [_entries, [], {_x select 2}, "ASCEND"] call BIS_fnc_sortBy;
{
    life_nav_list pushBack [_x select 0, _x select 1];
} forEach _entries;
//Liste ueber den Filter fuellen (Suchfeld leer) und den Cursor ins Suchfeld setzen
(_display displayCtrl 2975) ctrlSetText "";
[] call life_fnc_navMenuFilter;
ctrlSetFocus (_display displayCtrl 2975);
//Laufende Anzeige der aktuellen Route
while {!isNull (findDisplay 2970)} do {
    private _info = (findDisplay 2970) displayCtrl 2971;
    if (life_nav_active) then {
        _info ctrlSetStructuredText parseText format ["<t size='0.95'>%1</t>", format [localize "STR_NAV_Current", life_nav_label, [player distance2D life_nav_target] call life_fnc_navDistText, [life_nav_routeLen] call life_fnc_navDistText]];
    } else {
        _info ctrlSetStructuredText parseText format ["<t size='0.95' color='#AAAAAA'>%1</t>", localize "STR_NAV_NoRoute"];
    };
    ((findDisplay 2970) displayCtrl 2974) ctrlEnable life_nav_active;
    sleep 1;
};
