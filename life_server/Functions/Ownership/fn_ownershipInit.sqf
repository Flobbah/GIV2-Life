#include "\life_server\script_macros.hpp"
/*
    File: fn_ownershipInit.sqf
    Description:
    Prueft beim Start, ob die Besitztabelle da ist (Phase 0.3 aus docs/ROADMAP.md, Migration
    sql/migrations/2026-09-19_002_asset_owners.sql). Fehlt sie, halten sich die Besitzfunktionen
    heraus und der Server laeuft wie vorher - die alten pid-Spalten sind ja noch da.

    Gestartet aus life_server\init.sqf.
*/
private _res = ["SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'asset_owners'", 2] call DB_fnc_asyncCall;
private _hasTable = (_res isEqualType []) && {(_res param [0, 0]) isEqualType 0} && {(_res select 0) > 0};
localNamespace setVariable ["life_asset_table", _hasTable];
if (!_hasTable) exitWith {
    diag_log "[OWNERSHIP] table asset_owners is missing (sql/migrations/2026-09-19_002_asset_owners.sql), ownership stays in the pid columns";
};
private _rows = ["SELECT COUNT(*) FROM asset_owners", 2] call DB_fnc_asyncCall;
private _count = if (_rows isEqualType [] && {(_rows param [0, 0]) isEqualType 0}) then {_rows select 0} else {0};
diag_log format ["[OWNERSHIP] asset_owners ready, %1 entries; the pid columns are still written in parallel", _count];
