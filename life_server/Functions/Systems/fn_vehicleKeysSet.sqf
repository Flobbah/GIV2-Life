#include "\life_server\script_macros.hpp"
/*
    File: fn_vehicleKeysSet.sqf
    Description:
    Die einzige Stelle, die die Schluesselliste eines Fahrzeugs schreibt (Sicherheitsprüfung,
    Fund #7). Sie legt die Liste in den Serverspeicher und spiegelt sie in die oeffentliche
    Variable "vehicle_info_owners" am Fahrzeug - die lesen die Menues der Clients (Schluesselbund,
    Beschlagnahmung, Garage) unveraendert weiter.

    Server-only: nicht in CfgRemoteExec. Aufrufer sind TON_fnc_vehicleKeys (Spieleranfragen),
    TON_fnc_vehicleCreate (Kauf) und TON_fnc_spawnVehicle (Garage).

    Parameter:
        0: OBJECT - das Fahrzeug
        1: ARRAY  - [[uid, name], ...]
*/
params [["_vehicle", objNull, [objNull]], ["_keys", [], [[]]]];
if (isNull _vehicle) exitWith {};
//Nur saubere Paare aus UID und Name, damit weder Speicher noch Anzeige Unsinn enthalten
private _clean = [];
{
    if (_x isEqualType [] && {count _x >= 2} && {(_x select 0) isEqualType ""} && {(_x select 1) isEqualType ""}) then {
        if ((_x select 0) regexMatch "\d{17}") then {_clean pushBack [_x select 0, _x select 1]};
    };
} forEach _keys;
[_vehicle, "keys", _clean] call TON_fnc_serverSet;
_vehicle setVariable ["vehicle_info_owners", _clean, true];
