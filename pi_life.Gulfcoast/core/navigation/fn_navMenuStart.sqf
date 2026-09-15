#include "..\..\script_macros.hpp"
/*
    File: fn_navMenuStart.sqf
    Description:
    Button "Route starten" in der Telefon-App "Navi": Navigation zum in der Liste gewaehlten Ziel.
*/
private _sel = lbCurSel 2972;
if (_sel isEqualTo -1) exitWith {[ localize "STR_NAV_Select",true,"fast"] call life_fnc_notification_system;};
private _index = lbValue [2972, _sel];
if (_index < 0) exitWith {[ localize "STR_NAV_Select",true,"fast"] call life_fnc_notification_system;};
private _entry = (missionNamespace getVariable ["life_nav_list",[]]) param [_index, []];
if (count _entry < 2) exitWith {};
_entry params ["_name","_pos"];
private _isDelivery = (_index isEqualTo 0) && {missionNamespace getVariable ["life_delivery_in_progress",false]} && {!isNil "life_dp_point"};
[_pos, _name, _isDelivery] call life_fnc_navStart;
closeDialog 0;
