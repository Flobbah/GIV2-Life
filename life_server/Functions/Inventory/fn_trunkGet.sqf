#include "\life_server\script_macros.hpp"
/*
    File: fn_trunkGet.sqf
    Description:
    The contents of a trunk (vehicle, house container or house) as the server knows them
    (docs/INVENTORY_AUTHORITY.md, package 4). The object variable "Trunk" is only the display copy;
    every client can write it, so it is taken over exactly once - the first time the server is asked
    about an object it does not know yet (vehicles and houses from before the change). Server-only.
    Parameters:
        0: OBJECT - vehicle, container or house
    Returns:
        ARRAY - [[[item, count], ...], weight]
*/
params [["_obj", objNull, [objNull]]];
if (isNull _obj) exitWith {[[], 0]};
private _stored = [_obj, "trunk", []] call TON_fnc_serverGet;
if (count _stored isEqualTo 2) exitWith {_stored};
private _mirror = _obj getVariable ["Trunk", [[], 0]];
private _items = [];
if (_mirror isEqualType [] && {(_mirror param [0, ""]) isEqualType []}) then {
    {
        if (_x isEqualType [] && {count _x >= 2} && {(_x param [0, 0]) isEqualType ""} && {(_x param [1, ""]) isEqualType 0}) then {
            private _num = round (_x select 1);
            if (_num > 0 && {isClass (missionConfigFile >> "VirtualItems" >> (_x select 0))}) then {
                _items pushBack [_x select 0, _num];
            };
        };
    } forEach (_mirror select 0);
};
private _data = [_items, [_items] call TON_fnc_trunkWeight];
[_obj, "trunk", _data] call TON_fnc_serverSet;
_data
