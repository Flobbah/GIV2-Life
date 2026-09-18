#include "\life_server\script_macros.hpp"
/*
    File: fn_invReport.sqf
    Description:
    Answer to the full inventory question of TON_fnc_invSync: everything the client currently carries.
    The server compares it with its own copy (docs/INVENTORY_AUTHORITY.md). A difference means either a
    flow that does not report through life_fnc_handleInv or a client that wrote its life_inv_ variables
    itself.
    Shadow mode (InventoryMode 1): the server takes the client's numbers over after logging them.
    Enforce mode (2): the server keeps its own numbers and pushes them back, so the client's display
    ends up at what the server has.
    Parameters:
        0: ARRAY - [[item variable, count], ...]
*/
private _owner = CALLER_OWNER;
params [["_items", [], [[]]]];
if (INVENTORY_MODE isEqualTo 0) exitWith {};
private _info = [_owner] call TON_fnc_callerInfo;
if (_info isEqualTo []) exitWith {};
_info params ["_uid", "_unit", "_side", "_name"];
private _store = localNamespace getVariable "life_inv_store";
if (isNil "_store") exitWith {};
private _enforce = INVENTORY_MODE >= 2;
private _client = createHashMap;
{
    if (_x isEqualType [] && {count _x >= 2} && {(_x param [0, 0]) isEqualType ""} && {(_x param [1, ""]) isEqualType 0}) then {
        private _value = round (_x select 1);
        if (_value > 0) then {_client set [_x select 0, _value]};
    };
} forEach _items;
private _inv = _store getOrDefault [_uid, createHashMap];
private _diff = [];
private _seen = [];
{
    if !(_x in _seen) then {
        _seen pushBack _x;
        private _c = _client getOrDefault [_x, 0];
        private _s = _inv getOrDefault [_x, 0];
        if !(_c isEqualTo _s) then {
            _diff pushBack format ["%1 %2/%3", _x, _c, _s];
            //Scharf: der Client bekommt den Stand des Servers zurueck
            if (_enforce) then {[_uid, _x, _s] call TON_fnc_invPush};
        };
    };
} forEach ((keys _inv) + (keys _client));
if !(_diff isEqualTo []) then {
    [_uid, _name, format ["report differs (item client/server): %1", _diff joinString ", "]] call TON_fnc_invWarn;
};
//Schattenmodus: der Server uebernimmt, was der Client meldet
if (!_enforce) then {_store set [_uid, _client]};
