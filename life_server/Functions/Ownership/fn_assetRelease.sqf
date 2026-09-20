#include "\life_server\script_macros.hpp"
/*
    File: fn_assetRelease.sqf
    Description:
    Beendet den Besitz an einem Gegenstand (Phase 0.3 aus docs/ROADMAP.md): beim Verkauf, beim
    Abreissen, beim Zerstoeren. Ohne Besitzerangabe verlieren *alle* ihren Anspruch - das ist der
    Normalfall, wenn der Gegenstand selbst verschwindet.

    Fremdschluessel koennen das nicht uebernehmen, weil asset_id je nach Art in eine andere Tabelle
    zeigt. Deshalb traegt diese Funktion das Enddatum ein, und wer einen neuen Gegenstandstyp
    einbaut, muss sie aufrufen.

    Server-only: nicht in CfgRemoteExec.

    Parameter:
        0: STRING - Art des Gegenstands
        1: NUMBER - id in der Tabelle des Gegenstands
        2: STRING - (optional) Art des Besitzers, leer = alle
        3: STRING - (optional) Kennung des Besitzers, leer = alle
    Rueckgabe:
        BOOL - true, wenn die Abfrage abgeschickt wurde
*/
params [
    ["_assetType", "", [""]],
    ["_assetId", 0, [0]],
    ["_ownerType", "", [""]],
    ["_ownerId", "", [""]]
];
if !(localNamespace getVariable ["life_asset_table", false]) exitWith {false};
private _clean = {
    params ["_value", ["_len", 16]];
    ((_value regexReplace ["[^A-Za-z0-9_]", ""]) select [0, _len])
};
_assetType = [_assetType] call _clean;
_ownerType = [_ownerType] call _clean;
_ownerId = [_ownerId, 32] call _clean;
_assetId = round _assetId;
if (_assetType isEqualTo "" || {_assetId <= 0}) exitWith {
    diag_log format ["[OWNERSHIP] assetRelease refused: %1 %2", _assetType, _assetId];
    false
};
private _where = format ["asset_type='%1' AND asset_id='%2'", _assetType, _assetId];
if (!(_ownerType isEqualTo "") && {!(_ownerId isEqualTo "")}) then {
    _where = _where + format [" AND owner_type='%1' AND owner_id='%2'", _ownerType, _ownerId];
};
//Kein DELETE: der Datenbank-Benutzer des Servers darf das nicht (wie ueberall in dieser
//Mission). Der Eintrag bekommt ein Enddatum, die Prozedur deleteEndedAssetOwners raeumt
//spaeter auf. Nebenbei bleibt nachvollziehbar, wem etwas frueher gehoert hat.
[format ["UPDATE asset_owners SET until = CURRENT_TIMESTAMP WHERE until IS NULL AND %1", _where], 1] call DB_fnc_asyncCall;
true
