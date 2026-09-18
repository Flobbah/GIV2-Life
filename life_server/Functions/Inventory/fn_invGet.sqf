#include "\life_server\script_macros.hpp"
/*
    File: fn_invGet.sqf
    Description:
    How many of an item the server thinks a player carries (docs/INVENTORY_AUTHORITY.md). For server
    functions that want to check a sale or a transfer. In shadow mode the number follows the client,
    so it is good for logging, not yet for refusing. Server-only.
    Parameters:
        0: STRING - player uid
        1: STRING - item (class name in VirtualItems, or its variable name)
    Returns:
        NUMBER - count, 0 when unknown
*/
params [["_uid", "", [""]], ["_item", "", [""]]];
private _key = getText (missionConfigFile >> "VirtualItems" >> _item >> "variable");
if (_key isEqualTo "") exitWith {0};
private _store = localNamespace getVariable "life_inv_store";
if (isNil "_store") exitWith {0};
(_store getOrDefault [_uid, createHashMap]) getOrDefault [_key, 0]
