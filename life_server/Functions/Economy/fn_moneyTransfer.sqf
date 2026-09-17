#include "\life_server\script_macros.hpp"
/*
    File: fn_moneyTransfer.sqf
    Description:
    Moves money between two accounts (docs/ECONOMY_AUTHORITY.md): one player's cash and bank
    (ATM) or two players (transfer, give cash). Checks the source balance first and then books
    both sides with TON_fnc_moneyChange in the same frame, so money is never created or lost.
    Must run unscheduled (remoteExecCall/call), never after a sleep. Server-only.
    Parameters:
        0: STRING - source uid
        1: STRING - source account "cash" or "bank"
        2: STRING - target uid
        3: STRING - target account "cash" or "bank"
        4: NUMBER - amount (positive)
        5: STRING - reason code for the transaction log
        6: STRING - (optional) details
    Returns:
        BOOL - true when both sides were booked
*/
params [
    ["_fromUid", "", [""]],
    ["_fromAccount", "", [""]],
    ["_toUid", "", [""]],
    ["_toAccount", "", [""]],
    ["_amount", 0, [0]],
    ["_reason", "", [""]],
    ["_meta", "", [""]]
];
if (ECONOMY_MODE isEqualTo 0) exitWith {false};
_amount = round _amount;
if (_amount <= 0 || {!(_fromAccount in ["cash", "bank"])} || {!(_toAccount in ["cash", "bank"])}) exitWith {false};
if (_fromUid isEqualTo _toUid && {_fromAccount isEqualTo _toAccount}) exitWith {false};
private _from = [_fromUid] call TON_fnc_walletEnsure;
private _to = [_toUid] call TON_fnc_walletEnsure;
if (_from isEqualTo [] || {_to isEqualTo []}) exitWith {false};
if ((_from select (["cash", "bank"] find _fromAccount)) < _amount) exitWith {false};
private _samePlayer = _fromUid isEqualTo _toUid;
if !([_fromUid, _fromAccount, -_amount, _reason, ["", _toUid] select !_samePlayer, _meta] call TON_fnc_moneyChange) exitWith {false};
[_toUid, _toAccount, _amount, _reason, ["", _fromUid] select !_samePlayer, _meta] call TON_fnc_moneyChange
