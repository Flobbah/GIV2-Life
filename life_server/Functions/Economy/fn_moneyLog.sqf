#include "\life_server\script_macros.hpp"
/*
    File: fn_moneyLog.sqf
    Description:
    Writes one row into the transaction log (table money_transactions), if the table exists.
    Text fields are reduced to safe characters and cut to the column length, numbers are rounded.
    Parameters:
        0: STRING - player uid ("" for gang rows)
        1: NUMBER - gang id (0 for player rows)
        2: STRING - account: "cash", "bank" or "gang"
        3: NUMBER - signed change
        4: NUMBER - balance after the change
        5: STRING - reason code, e.g. "client_save", "atm_withdraw"
        6: STRING - (optional) counterpart uid or gang id
        7: STRING - (optional) details
*/
params [
    ["_pid", "", [""]],
    ["_gangId", 0, [0]],
    ["_account", "", [""]],
    ["_delta", 0, [0]],
    ["_balance", 0, [0]],
    ["_reason", "", [""]],
    ["_counterpart", "", [""]],
    ["_meta", "", [""]]
];
if !(localNamespace getVariable ["life_econ_logTable", false]) exitWith {};
if !(_account in ["cash", "bank", "gang"]) exitWith {};
if (!(_pid isEqualTo "") && {!(_pid regexMatch "\d{17}")}) exitWith {};
private _clean = {
    params ["_text", "_length"];
    (_text regexReplace ["[^A-Za-z0-9_.:,;+ -]", ""]) select [0, _length]
};
[format ["INSERT INTO money_transactions (pid, gang_id, account, delta, balance_after, reason, counterpart, meta) VALUES ('%1', '%2', '%3', '%4', '%5', '%6', '%7', '%8')",
    _pid,
    round _gangId,
    _account,
    [round _delta] call DB_fnc_numberSafe,
    [round _balance] call DB_fnc_numberSafe,
    [_reason, 48] call _clean,
    [_counterpart, 32] call _clean,
    [_meta, 255] call _clean
], 1] call DB_fnc_asyncCall;
