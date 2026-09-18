#include "\life_server\script_macros.hpp"
/*
    File: fn_invDrop.sqf
    Description:
    Throwing items away from the player menu (docs/INVENTORY_AUTHORITY.md, package 3). Nothing is
    created, the items are gone, so the server only has to take them out of its own copy.
    Parameters:
        0: NUMBER - request id
        1: STRING - item
        2: NUMBER - amount
    Answer data: [amount], failure ["items"] or ["denied"]
*/
private _owner = CALLER_OWNER;
params [["_id", -1, [0]], ["_item", "", [""]], ["_amount", 0, [0]]];
if (INVENTORY_MODE isEqualTo 0) exitWith {};
private _info = [_owner] call TON_fnc_callerInfo;
if (_info isEqualTo []) exitWith {};
_info params ["_uid"];
private _answer = {
    params ["_ok", ["_data", []]];
    [_id, _ok, _data] remoteExecCall ["life_fnc_econReply", _owner];
};
_amount = round _amount;
private _key = getText (missionConfigFile >> "VirtualItems" >> _item >> "variable");
switch (true) do {
    case (_key isEqualTo "" || {_amount < 1} || {_amount > 100000}): {
        [_owner, "TON_fnc_invDrop", format ["invalid %1 x%2", _item, _amount]] call TON_fnc_denyCaller;
        [false, ["denied"]] call _answer;
    };
    case (([_uid, _item] call TON_fnc_invGet) < _amount): {[false, ["items"]] call _answer};
    default {
        [_uid, _item, -_amount, "drop"] call TON_fnc_invChange;
        [true, [_amount]] call _answer;
    };
};
