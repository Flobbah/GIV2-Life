#include "\life_server\script_macros.hpp"
/*
    File: fn_assetOwned.sqf
    Description:
    "Was besitzt dieser Spieler, diese Gang, diese Fraktion?" (Phase 0.3 aus docs/ROADMAP.md).
    Genau die Frage, die mit den alten pid-Spalten je Tabelle einzeln gestellt werden musste -
    und die fuer eine Gang gar nicht zu stellen war.

    Server-only: nicht in CfgRemoteExec.

    Parameter:
        0: STRING - Art des Besitzers: player | gang | faction
        1: STRING - Kennung: UID, Gang-id, Fraktionsname
        2: STRING - (optional) nur diese Art von Gegenstand
    Rueckgabe:
        ARRAY - [[assetType, assetId, role], ...]
*/
params [["_ownerType", "", [""]], ["_ownerId", "", [""]], ["_assetType", "", [""]]];
if !(localNamespace getVariable ["life_asset_table", false]) exitWith {[]};
private _clean = {
    params ["_value", ["_len", 16]];
    ((_value regexReplace ["[^A-Za-z0-9_]", ""]) select [0, _len])
};
_ownerType = [_ownerType] call _clean;
_ownerId = [_ownerId, 32] call _clean;
_assetType = [_assetType] call _clean;
if (!(_ownerType in ["player", "gang", "faction"]) || {_ownerId isEqualTo ""}) exitWith {[]};
private _where = format ["until IS NULL AND owner_type='%1' AND owner_id='%2'", _ownerType, _ownerId];
if !(_assetType isEqualTo "") then {_where = _where + format [" AND asset_type='%1'", _assetType]};
private _rows = [format ["SELECT asset_type, asset_id, role FROM asset_owners WHERE %1 ORDER BY asset_type, asset_id", _where], 2] call DB_fnc_asyncCall;
if !(_rows isEqualType []) exitWith {[]};
if (!(_rows isEqualTo []) && {!((_rows select 0) isEqualType [])}) then {_rows = [_rows]};
_rows
