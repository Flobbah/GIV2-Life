#include "\life_server\script_macros.hpp"
/*
    File: fn_sqlCustomTest.sqf
    Description:
    Selbsttest fuer die vorbereiteten Anweisungen (Phase 0.3 aus docs/ROADMAP.md). Laeuft einmal
    beim Serverstart und beantwortet genau eine Frage: Kommt ueber SQL_CUSTOM dasselbe heraus wie
    ueber die bisherige Abfrage?

    Solange das nicht bewiesen ist, wird keine echte Abfrage umgestellt. Das Ergebnis steht als
    [SQLCUSTOM] im Server-RPT.

    Gestartet aus life_server\init.sqf.
*/
private _id = missionNamespace getVariable ["life_sql_custom_id", -1];
if (_id < 0) exitWith {
    diag_log "[SQLCUSTOM] protocol not registered, everything keeps using the built queries";
};

//1. Ohne Parameter: die Zahl der Spieler, einmal ueber beide Wege
private _custom = ["probeCount", [], 2] call DB_fnc_customCall;
private _plain = ["SELECT COUNT(*) FROM players", 2] call DB_fnc_asyncCall;
private _flat = {
    params ["_value"];
    private _v = _value;
    while {_v isEqualType [] && {count _v > 0}} do {_v = _v select 0};
    if (_v isEqualType "") then {_v = parseNumber _v};
    if (_v isEqualType 0) then {_v} else {-1}
};
private _a = [_custom] call _flat;
private _b = [_plain] call _flat;
if (_a isEqualTo _b && {_a >= 0}) then {
    diag_log format ["[SQLCUSTOM] probeCount ok: %1 players over both paths", _a];
} else {
    diag_log format ["[SQLCUSTOM] probeCount MISMATCH: prepared %1, built %2 (raw: %3)", _a, _b, _custom];
};


//2. Mit einem Parameter: der Name zu einer UID. Genommen wird die erste vorhandene, damit der Test
//   auch auf einer leeren Datenbank keine Fehlmeldung erzeugt.
private _uidRow = ["SELECT pid FROM players ORDER BY pid LIMIT 1", 2] call DB_fnc_asyncCall;
private _uid = _uidRow param [0, ""];
if (_uid isEqualType []) then {_uid = _uid param [0, ""]};
if !(_uid isEqualType "") exitWith {
    diag_log "[SQLCUSTOM] probeName skipped, no player row to read";
};
if (_uid isEqualTo "") exitWith {
    diag_log "[SQLCUSTOM] probeName skipped, no player row to read";
};
private _nameCustom = ["probeName", [_uid], 2] call DB_fnc_customCall;
private _namePlain = [format ["SELECT name FROM players WHERE pid='%1'", _uid], 2] call DB_fnc_asyncCall;
private _text = {
    params ["_value"];
    private _v = _value;
    while {_v isEqualType [] && {count _v > 0}} do {_v = _v select 0};
    if (_v isEqualType "") then {_v} else {str _v}
};
private _x = [_nameCustom] call _text;
private _y = [_namePlain] call _text;
if (_x isEqualTo _y) then {
    diag_log format ["[SQLCUSTOM] probeName ok: both paths return '%1'", _x];
} else {
    diag_log format ["[SQLCUSTOM] probeName MISMATCH: prepared '%1', built '%2'", _x, _y];
};
