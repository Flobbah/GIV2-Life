#include "\life_server\script_macros.hpp"
/*
    File: fn_trunkWeight.sqf
    Description:
    Total weight of a list of items, from VirtualItems >> weight. Server-only.
    Parameters:
        0: ARRAY - [[item, count], ...]
    Returns:
        NUMBER
*/
params [["_items", [], [[]]]];
private _weight = 0;
{
    if (_x isEqualType [] && {count _x >= 2}) then {
        _weight = _weight + ((getNumber (missionConfigFile >> "VirtualItems" >> (_x param [0, "", [""]]) >> "weight")) * (_x param [1, 0, [0]]));
    };
} forEach _items;
_weight
