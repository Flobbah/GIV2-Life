#include "\life_server\script_macros.hpp"
/*
    File: fn_fedSafe.sqf
    Description:
    The federal reserve vault (docs/SECURITY_AUDIT.md finding #4). Before this the client decremented
    the public object variable "safe" itself, so any client could take unlimited gold bars. The amount
    and the open state now live in the server store; the object variables "safe" and "safe_open" are
    only a mirror for the action menu and the dialog. Answers through life_fnc_econReply.
    Parameters:
        0: NUMBER - request id
        1: STRING - "take", "store" or "close"
        2: NUMBER - gold bars
    Answer data: take/store [amount, new total], failure ["amount", total] or ["denied"]
*/
private _owner = CALLER_OWNER;
params [["_id", -1, [0]], ["_kind", "", [""]], ["_amount", 0, [0]]];
private _info = [_owner] call TON_fnc_callerInfo;
if (_info isEqualTo []) exitWith {};
_info params ["_uid", "_unit", "_side"];
private _answer = {
    params ["_ok", ["_data", []]];
    [_id, _ok, _data] remoteExecCall ["life_fnc_econReply", _owner];
};
private _deny = {
    [_owner, "TON_fnc_fedSafe " + _kind, _this] call TON_fnc_denyCaller;
    [false, ["denied"]] call _answer;
};
if (isNil "fed_bank" || {isNull fed_bank}) exitWith {[false, ["denied"]] call _answer};
if ((_unit distance fed_bank) > 12) exitWith {"sender too far from the vault" call _deny};
_amount = round _amount;
private _funds = ["server", "fedSafe", 0] call TON_fnc_serverGet;
switch (_kind) do {
    case "take": {
        switch (true) do {
            case (!(_side isEqualTo civilian)): {"only civilians take gold from the vault" call _deny};
            case (!(["server", "fedOpen", false] call TON_fnc_serverGet)): {"the vault is not open" call _deny};
            case (_amount < 1 || {_amount > _funds}): {[false, ["amount", _funds]] call _answer};
            default {
                private _left = _funds - _amount;
                ["server", "fedSafe", _left] call TON_fnc_serverSet;
                fed_bank setVariable ["safe", _left, true];
                diag_log format ["[VAULT] %1 (%2) took %3 gold bars, %4 left", name _unit, _uid, _amount, _left];
                [true, [_amount, _left]] call _answer;
            };
        };
    };
    case "store": {
        switch (true) do {
            case (!(_side isEqualTo civilian)): {"only civilians put gold into the vault" call _deny};
            case (_amount < 1 || {_amount > 5000}): {[false, ["amount", _funds]] call _answer};
            default {
                private _total = _funds + _amount;
                ["server", "fedSafe", _total] call TON_fnc_serverSet;
                fed_bank setVariable ["safe", _total, true];
                [true, [_amount, _total]] call _answer;
            };
        };
    };
    case "close": {
        switch (true) do {
            case (!(_side isEqualTo west)): {"only police close the vault" call _deny};
            default {
                ["server", "fedOpen", false] call TON_fnc_serverSet;
                fed_bank setVariable ["safe_open", false, true];
                [true] call _answer;
            };
        };
    };
    default {format ["unknown vault action %1", _kind] call _deny};
};
