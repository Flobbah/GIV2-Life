#include "\life_server\script_macros.hpp"
/*
    File: fn_assetOwners.sqf
    Description:
    "Wem gehoert das hier?" - alle aktuellen Besitzer eines Gegenstands (Phase 0.3 aus
    docs/ROADMAP.md). Beendete Eintraege (until gesetzt) bleiben aussen vor.

    Server-only: nicht in CfgRemoteExec.

    Parameter:
        0: STRING - Art des Gegenstands
        1: NUMBER - id in der Tabelle des Gegenstands
    Rueckgabe:
        ARRAY - [[ownerType, ownerId, role], ...], leer wenn niemandem
*/
params [["_assetType", "", [""]], ["_assetId", 0, [0]]];
if !(localNamespace getVariable ["life_asset_table", false]) exitWith {[]};
_assetType = ((_assetType regexReplace ["[^A-Za-z0-9_]", ""]) select [0, 16]);
_assetId = round _assetId;
if (_assetType isEqualTo "" || {_assetId <= 0}) exitWith {[]};
private _rows = [format [
    "SELECT owner_type, owner_id, role FROM asset_owners WHERE until IS NULL AND asset_type='%1' AND asset_id='%2'",
    _assetType, _assetId], 2] call DB_fnc_asyncCall;
if !(_rows isEqualType []) exitWith {[]};
//Eine einzelne Zeile liefert extDB3 flach zurueck (wie in TON_fnc_adminMoneyQuery)
if (!(_rows isEqualTo []) && {!((_rows select 0) isEqualType [])}) then {_rows = [_rows]};
_rows
