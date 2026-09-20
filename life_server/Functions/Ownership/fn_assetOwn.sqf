#include "\life_server\script_macros.hpp"
/*
    File: fn_assetOwn.sqf
    Description:
    Traegt einen Besitzer in asset_owners ein (Phase 0.3 aus docs/ROADMAP.md). Ersetzt auf Dauer
    die pid-Spalten in vehicles, houses und containers; bis alle Leser umgestellt sind, wird
    beides geschrieben.

    Server-only: nicht in CfgRemoteExec. Aufrufer sind die Funktionen, die einen Gegenstand
    anlegen oder den Besitzer wechseln.

    Parameter:
        0: STRING - Art des Gegenstands: vehicle | house | container | ... (frei erweiterbar)
        1: NUMBER - id in der Tabelle des Gegenstands
        2: STRING - Art des Besitzers: player | gang | faction
        3: STRING - Kennung des Besitzers: UID, Gang-id oder Fraktionsname
        4: STRING - (optional) Rolle: owner (Standard), coowner, employee
    Rueckgabe:
        BOOL - true, wenn der Eintrag geschrieben wurde
*/
params [
    ["_assetType", "", [""]],
    ["_assetId", 0, [0]],
    ["_ownerType", "", [""]],
    ["_ownerId", "", [""]],
    ["_role", "owner", [""]]
];
if !(localNamespace getVariable ["life_asset_table", false]) exitWith {false};

//Alles, was in die Abfrage geht, wird vorher auf harmlose Zeichen reduziert - die Tabelle wird
//spaeter von vielen Stellen benutzt, da soll niemand ueber einen neuen Aufrufer Unsinn einbauen.
private _clean = {
    params ["_value", ["_len", 16]];
    ((_value regexReplace ["[^A-Za-z0-9_]", ""]) select [0, _len])
};
_assetType = [_assetType] call _clean;
_ownerType = [_ownerType] call _clean;
_ownerId = [_ownerId, 32] call _clean;
_role = [_role] call _clean;
_assetId = round _assetId;

private _deny = "";
switch (true) do {
    case (_assetType isEqualTo ""): {_deny = "asset type is empty"};
    case (_assetId <= 0): {_deny = format ["invalid asset id %1", _assetId]};
    case (!(_ownerType in ["player", "gang", "faction"])): {_deny = format ["unknown owner type %1", _ownerType]};
    case (_ownerId isEqualTo ""): {_deny = "owner id is empty"};
    case (!(_role in ["owner", "coowner", "employee"])): {_deny = format ["unknown role %1", _role]};
    case (_ownerType isEqualTo "player" && {!(_ownerId regexMatch "\d{17}")}): {_deny = "owner id is not a uid"};
};
if !(_deny isEqualTo "") exitWith {
    diag_log format ["[OWNERSHIP] assetOwn refused: %1 (%2 %3 -> %4 %5)", _deny, _assetType, _assetId, _ownerType, _ownerId];
    false
};

//ON DUPLICATE KEY: derselbe Besitzer in derselben Rolle bleibt eine Zeile (uniq_owner).
//until = NULL heisst: gehoert ihm wieder - wer sein Haus zurueckkauft, bekommt keine zweite Zeile.
[format [
    "INSERT INTO asset_owners (asset_type, asset_id, owner_type, owner_id, role) VALUES ('%1', '%2', '%3', '%4', '%5') ON DUPLICATE KEY UPDATE since = CURRENT_TIMESTAMP, until = NULL",
    _assetType, _assetId, _ownerType, _ownerId, _role], 1] call DB_fnc_asyncCall;
true
