#include "\life_server\script_macros.hpp"
/*
    File: fn_econInit.sqf
    Description:
    Starts the server-side economy (docs/ECONOMY_AUTHORITY.md). Creates the wallet store, checks
    whether the transaction log table exists and removes entries older than the retention period.
    Mode from CfgServer >> EconomyMode: 0 = off (Altis Life 5.0), 1 = shadow mode, 2 = enforce
    (not built yet, runs as shadow mode).
*/
private _mode = ECONOMY_MODE;
localNamespace setVariable ["life_econ_wallets", createHashMap];
localNamespace setVariable ["life_econ_logTable", false];
if (_mode isEqualTo 0) exitWith {
    diag_log "[ECONOMY] EconomyMode 0: server-side economy is off";
};
if (_mode > 1) then {
    diag_log format ["[ECONOMY] EconomyMode %1 is not built yet, running in shadow mode (1)", _mode];
};
[] spawn TON_fnc_econPaycheck; //Schritt 2: Gehalt zahlt der Server
private _res = ["SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'money_transactions'", 2] call DB_fnc_asyncCall;
private _hasTable = (_res isEqualType []) && {(_res param [0, 0]) isEqualType 0} && {(_res select 0) > 0};
localNamespace setVariable ["life_econ_logTable", _hasTable];
if (!_hasTable) exitWith {
    diag_log "[ECONOMY] table money_transactions is missing (sql/migrations/2026-09-16_001_money_transactions.sql), shadow checks log to the RPT only";
};
private _days = getNumber (missionConfigFile >> "CfgEconomy" >> "transactionRetentionDays");
if (_days > 0) then {
    //Stored procedure from the migration: the database user has no DELETE right, like the other cleanup procedures
    private _proc = ["SELECT COUNT(*) FROM information_schema.routines WHERE routine_schema = DATABASE() AND routine_name = 'deleteOldMoneyTransactions'", 2] call DB_fnc_asyncCall;
    if ((_proc isEqualType []) && {(_proc param [0, 0]) isEqualType 0} && {(_proc select 0) > 0}) then {
        [format ["CALL deleteOldMoneyTransactions(%1)", round _days], 1] call DB_fnc_asyncCall;
    } else {
        diag_log "[ECONOMY] procedure deleteOldMoneyTransactions is missing (migration 001), old transactions are not removed";
    };
};
diag_log format ["[ECONOMY] shadow mode active, transaction log on, retention %1 days", _days];
