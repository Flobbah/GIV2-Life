#include "\life_server\script_macros.hpp"
/*
    File: fn_invLoad.sqf
    Description:
    Sets a player's server-side item copy from the saved gear at login (DB_fnc_queryRequest), the way
    TON_fnc_walletLoad does it for the money. Only the items Life_Settings >> saved_virtualItems allows
    are in there; everything else starts empty, exactly as the client does it
    (docs/INVENTORY_AUTHORITY.md).
    Parameters:
        0: STRING - player uid
        1: ARRAY  - the gear array from the database (virtual items are element 6)
*/
params [["_uid", "", [""]], ["_gear", [], [[]]]];
if (INVENTORY_MODE isEqualTo 0 || {!(_uid regexMatch "\d{17}")}) exitWith {};
private _store = localNamespace getVariable "life_inv_store";
if (isNil "_store") exitWith {};
private _inv = createHashMap;
{
    if (_x isEqualType [] && {count _x >= 2}) then {
        private _key = getText (missionConfigFile >> "VirtualItems" >> (_x param [0, "", [""]]) >> "variable");
        private _num = round (_x param [1, 0, [0]]);
        if (!(_key isEqualTo "") && {_num > 0}) then {
            _inv set [_key, (_inv getOrDefault [_key, 0]) + _num];
        };
    };
} forEach (_gear param [6, [], [[]]]);
_store set [_uid, _inv];
