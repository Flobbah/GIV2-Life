#include "..\..\script_macros.hpp"
/*
    File: fn_garageInit.sqf
    Description:
    Macht ein beliebiges Objekt (NPC, Schild, Gebaeude) zur Garage: Aktion "Garage" und optional
    "Fahrzeug einparken". Ausgeparkt wird ueber das freie Abstellen, Spawnmarker sind nicht noetig.
    Aufruf im Init-Feld des Objekts im Editor, zum Beispiel:
        [this, "Car"] call life_fnc_garageInit;              Autos, alle Fraktionen
        [this, "Air", west] call life_fnc_garageInit;        Luftfahrzeuge, nur Polizei
        [this, "Ship", civilian] call life_fnc_garageInit;   Boote, nur Zivilisten
        [this, "Car", independent, false] call life_fnc_garageInit;   ohne Einparken-Aktion
    Parameter:
        0: OBJECT - Garagenobjekt
        1: STRING - Fahrzeugart "Car", "Air" oder "Ship"
        2: SIDE   - nur fuer diese Fraktion, sideUnknown = alle (Standard)
        3: BOOL   - Aktion "Fahrzeug einparken" hinzufuegen (Standard true)
*/
params [["_object", objNull, [objNull]], ["_type", "Car", [""]], ["_side", sideUnknown, [civilian]], ["_store", true, [true]]];
if (!hasInterface || {isNull _object}) exitWith {};
if !(_type in ["Car", "Air", "Ship"]) exitWith {diag_log format ["[GARAGE] Unbekannte Fahrzeugart %1 an %2", _type, _object];};
private _condition = switch (_side) do {
    case west: {"life_side isEqualTo west"};
    case civilian: {"life_side isEqualTo civilian"};
    case independent: {"life_side isEqualTo independent"};
    default {"true"};
};
_object addAction [localize "STR_Garage_Title", {
    params ["_target", "_caller", "_id", "_type"];
    life_garage_type = _type;
    if (life_HC_isActive) then {
        [getPlayerUID player, life_side, _type, player] remoteExec ["HC_fnc_getVehicles", HC_Life];
    } else {
        [getPlayerUID player, life_side, _type, player] remoteExec ["TON_fnc_getVehicles", RSERV];
    };
    createDialog "Life_impound_menu";
    disableSerialization;
    ctrlSetText [2802, localize "STR_ANOTF_QueryGarage"];
}, _type, 1.5, true, true, "", _condition, 5];
if (_store) then {
    _object addAction [localize "STR_MAR_Store_vehicle_in_Garage", life_fnc_storeVehicle, "", 0, false, false, "", "!life_garage_store", 5];
};
