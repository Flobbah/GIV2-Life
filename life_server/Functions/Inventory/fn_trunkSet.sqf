#include "\life_server\script_macros.hpp"
/*
    File: fn_trunkSet.sqf
    Description:
    Writes the contents of a trunk: into the server store and, as the display copy, onto the object
    (docs/INVENTORY_AUTHORITY.md, package 4). The weight is always recalculated from the items, so it
    cannot drift. Server-only.
    Parameters:
        0: OBJECT - vehicle, container or house
        1: ARRAY  - [[item, count], ...]
*/
params [["_obj", objNull, [objNull]], ["_items", [], [[]]]];
if (isNull _obj) exitWith {};
_items = _items select {(_x param [1, 0]) > 0};
private _data = [_items, [_items] call TON_fnc_trunkWeight];
[_obj, "trunk", _data] call TON_fnc_serverSet;
_obj setVariable ["Trunk", _data, true];
_data
