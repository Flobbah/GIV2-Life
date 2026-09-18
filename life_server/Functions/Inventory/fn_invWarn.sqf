#include "\life_server\script_macros.hpp"
/*
    File: fn_invWarn.sqf
    Description:
    One [INVENTORY] line per player at most every CfgInventory >> warnSeconds, so a single cheater
    cannot flood the RPT. Server-only.
    Parameters:
        0: STRING - player uid
        1: STRING - player name
        2: STRING - what does not add up
*/
params [["_uid", "", [""]], ["_name", "", [""]], ["_text", "", [""]]];
private _store = localNamespace getVariable "life_inv_warn";
if (isNil "_store") then {
    _store = createHashMap;
    localNamespace setVariable ["life_inv_warn", _store];
};
if ((diag_tickTime - (_store getOrDefault [_uid, -1e9])) < (getNumber (missionConfigFile >> "CfgInventory" >> "warnSeconds"))) exitWith {};
_store set [_uid, diag_tickTime];
diag_log format ["[INVENTORY] %1 (%2): %3", _name, _uid, _text];
