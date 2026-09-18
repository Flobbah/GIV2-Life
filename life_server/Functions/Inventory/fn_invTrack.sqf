#include "\life_server\script_macros.hpp"
/*
    File: fn_invTrack.sqf
    Description:
    A client reports one change of its virtual inventory (life_fnc_handleInv, the single place where
    the mission adds or removes virtual items). The server keeps its own copy per player
    (docs/INVENTORY_AUTHORITY.md). Removing more than the server has is logged.
    Shadow mode (InventoryMode 1): every change is followed.
    Enforce mode (2): only removals are followed - using a lockpick or a bandage is still done by the
    client and can only cost the player something. Additions are ignored and logged, because in this
    mode every legitimate addition is booked by the server itself.
    Parameters:
        0: STRING - item (class name in VirtualItems, or its variable name)
        1: NUMBER - signed change
*/
private _owner = CALLER_OWNER;
params [["_item", "", [""]], ["_delta", 0, [0]]];
if (INVENTORY_MODE isEqualTo 0) exitWith {};
private _info = [_owner] call TON_fnc_callerInfo;
if (_info isEqualTo []) exitWith {};
_info params ["_uid", "_unit", "_side", "_name"];
private _key = getText (missionConfigFile >> "VirtualItems" >> _item >> "variable");
_delta = round _delta;
switch (true) do {
    case (_key isEqualTo ""): {[_owner, "TON_fnc_invTrack", format ["unknown item %1", _item]] call TON_fnc_denyCaller};
    case (_delta isEqualTo 0 || {abs _delta > 100000}): {[_owner, "TON_fnc_invTrack", format ["impossible amount %1 %2", _delta, _item]] call TON_fnc_denyCaller};
    case (INVENTORY_MODE >= 2 && {_delta > 0}): {
        //Scharf: Zugaenge entscheidet der Server, nicht der Client
        [_uid, _name, format ["client added %1 %2 by itself, ignored", _delta, _key]] call TON_fnc_invWarn;
        [_uid, _key, ((localNamespace getVariable ["life_inv_store", createHashMap]) getOrDefault [_uid, createHashMap]) getOrDefault [_key, 0]] call TON_fnc_invPush;
    };
    default {
        private _store = localNamespace getVariable "life_inv_store";
        if (isNil "_store") exitWith {};
        private _inv = _store getOrDefault [_uid, createHashMap];
        _store set [_uid, _inv];
        private _had = _inv getOrDefault [_key, 0];
        private _new = _had + _delta;
        if (_new < 0) then {
            [_uid, _name, format ["removed %1 %2 but the server only had %3", abs _delta, _key, _had]] call TON_fnc_invWarn;
            _new = 0;
        };
        _inv set [_key, _new];
    };
};
