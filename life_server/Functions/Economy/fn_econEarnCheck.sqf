#include "\life_server\script_macros.hpp"
/*
    File: fn_econEarnCheck.sqf
    Description:
    Earning limits per player and income source within a rolling hour (docs/ECONOMY_AUTHORITY.md,
    step 3). Used for income the server cannot verify exactly yet because the goods come from client
    inventories. CfgEconomy >> EarningLimits >> mode: 0 = off, 1 = log only ([ECONOMY], at most every
    10 minutes per player and source), 2 = refuse the payout.
    Parameters:
        0: STRING - player uid
        1: STRING - source, a number entry in CfgEconomy >> EarningLimits (e.g. "itemSale")
        2: NUMBER - amount about to be paid
        3: STRING - (optional) player name for the log
    Returns:
        BOOL - true = pay, false = limit reached in blocking mode
*/
params [["_uid", "", [""]], ["_source", "", [""]], ["_amount", 0, [0]], ["_name", "", [""]]];
private _cfg = missionConfigFile >> "CfgEconomy" >> "EarningLimits";
private _mode = getNumber (_cfg >> "mode");
private _limit = getNumber (_cfg >> _source);
if (_mode isEqualTo 0 || {_limit <= 0} || {_amount <= 0}) exitWith {true};
private _store = localNamespace getVariable "life_econ_earnings";
if (isNil "_store") then {
    _store = createHashMap;
    localNamespace setVariable ["life_econ_earnings", _store];
};
private _key = _uid + "|" + _source;
private _entries = (_store getOrDefault [_key, []]) select {(diag_tickTime - (_x select 0)) < 3600};
private _sum = 0;
{_sum = _sum + (_x select 1)} forEach _entries;
private _allowed = true;
if ((_sum + _amount) > _limit) then {
    private _warnKey = _key + "|warn";
    if ((diag_tickTime - (_store getOrDefault [_warnKey, -1e9])) > 600) then {
        _store set [_warnKey, diag_tickTime];
        diag_log format ["[ECONOMY] earning limit %1: %2 (%3) earned $%4 in the last hour, limit $%5, next payout $%6 %7",
            _source, _name, _uid, [_sum] call DB_fnc_numberSafe, [_limit] call DB_fnc_numberSafe, [_amount] call DB_fnc_numberSafe,
            ["logged only (mode 1)", "refused (mode 2)"] select (_mode >= 2)];
    };
    if (_mode >= 2) then {_allowed = false};
};
if (_allowed) then {_entries pushBack [diag_tickTime, _amount]};
_store set [_key, _entries];
_allowed
