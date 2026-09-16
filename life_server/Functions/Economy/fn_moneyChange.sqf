#include "\life_server\script_macros.hpp"
/*
    File: fn_moneyChange.sqf
    Description:
    The server's way to change a player's money (docs/ECONOMY_AUTHORITY.md). Changes the
    server-side wallet, writes the database, logs the transaction and tells the player's client
    (life_fnc_moneyUpdate). Server-only: not whitelisted in CfgRemoteExec, never call it with an
    amount a client chose. A change that would make the balance negative is refused.
    Parameters:
        0: STRING - player uid
        1: STRING - "cash" or "bank"
        2: NUMBER - signed change
        3: STRING - reason code for the transaction log, e.g. "paycheck"
        4: STRING - (optional) counterpart uid
        5: STRING - (optional) details
    Returns:
        BOOL - true when the change was applied
*/
params [
    ["_uid", "", [""]],
    ["_account", "", [""]],
    ["_delta", 0, [0]],
    ["_reason", "", [""]],
    ["_counterpart", "", [""]],
    ["_meta", "", [""]]
];
if (ECONOMY_MODE isEqualTo 0) exitWith {false};
if (!(_uid regexMatch "\d{17}") || {!(_account in ["cash", "bank"])} || {_reason isEqualTo ""}) exitWith {false};
_delta = round _delta;
if (_delta isEqualTo 0) exitWith {true};
private _wallets = localNamespace getVariable "life_econ_wallets";
if (isNil "_wallets") exitWith {false};
private _wallet = _wallets get _uid;
if (isNil "_wallet") exitWith {
    diag_log format ["[ECONOMY] moneyChange %1 %2 %3 (%4): no wallet loaded for this player", _uid, _account, _delta, _reason];
    false
};
private _index = ["cash", "bank"] find _account;
private _balance = (_wallet select _index) + _delta;
if (_balance < 0) exitWith {
    diag_log format ["[ECONOMY] moneyChange %1 %2 %3 (%4) refused: balance would be %5", _uid, _account, _delta, _reason, _balance];
    false
};
_wallet set [_index, _balance];
[format ["UPDATE players SET %1='%2' WHERE pid='%3'", ["cash", "bankacc"] select _index, [_balance] call DB_fnc_numberSafe, _uid], 1] call DB_fnc_asyncCall;
[_uid, 0, _account, _delta, _balance, _reason, _counterpart, _meta] call TON_fnc_moneyLog;
private _owner = 0;
{
    if ((getPlayerUID _x) isEqualTo _uid) exitWith {_owner = owner _x};
} forEach allPlayers;
if (_owner > 2) then {
    [_wallet select 0, _wallet select 1, [0, _delta] select (_index isEqualTo 0), [0, _delta] select (_index isEqualTo 1)] remoteExecCall ["life_fnc_moneyUpdate", _owner];
};
true
