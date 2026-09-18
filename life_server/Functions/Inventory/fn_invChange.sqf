#include "\life_server\script_macros.hpp"
/*
    File: fn_invChange.sqf
    Description:
    The server's way to change a player's virtual items (docs/INVENTORY_AUTHORITY.md, package 3).
    Changes the server-side copy and pushes the new count to the player (life_fnc_invUpdate), so the
    client does not add anything itself. Server-only: never with an amount a client chose.
    Parameters:
        0: STRING - player uid
        1: STRING - item (class name in VirtualItems, or its variable name)
        2: NUMBER - signed change
        3: STRING - (optional) reason, for the log
    Returns:
        BOOL - true when the change was applied
*/
params [["_uid", "", [""]], ["_item", "", [""]], ["_delta", 0, [0]], ["_reason", "", [""]]];
if (INVENTORY_MODE isEqualTo 0) exitWith {false};
private _key = getText (missionConfigFile >> "VirtualItems" >> _item >> "variable");
if (_key isEqualTo "" || {!(_uid regexMatch "\d{17}")}) exitWith {false};
_delta = round _delta;
if (_delta isEqualTo 0) exitWith {true};
private _store = localNamespace getVariable "life_inv_store";
if (isNil "_store") exitWith {false};
private _inv = _store getOrDefault [_uid, createHashMap];
_store set [_uid, _inv];
private _new = (_inv getOrDefault [_key, 0]) + _delta;
if (_new < 0) exitWith {false};
_inv set [_key, _new];
[_uid, _key, _new] call TON_fnc_invPush;
true
