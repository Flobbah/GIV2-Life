#include "\life_server\script_macros.hpp"
/*
    File: fn_hasKey.sqf
    Description:
    Hat dieser Spieler einen Schluessel fuer dieses Fahrzeug? (Sicherheitsprüfung, Fund #7)

    Die Liste liegt im Serverspeicher (Feld "keys", Form [[uid, name], ...]), nicht als oeffentliche
    Variable am Fahrzeug. "vehicle_info_owners" am Objekt bleibt als Anzeige fuer die Menues der
    Clients bestehen, wird aber nur noch vom Server geschrieben (TON_fnc_vehicleKeysSet).

    Server-only: nicht in CfgRemoteExec. Benutzt unter anderem von der Relay-Regel fuer
    life_fnc_lockVehicle (Config_Relay.hpp) - damit prueft der Server beim Auf- und Zuschliessen
    zum ersten Mal, ob der Absender ueberhaupt einen Schluessel hat.

    Parameter:
        0: OBJECT - das Fahrzeug
        1: STRING - UID des Spielers
    Rueckgabe:
        BOOL
*/
params [["_vehicle", objNull, [objNull]], ["_uid", "", [""]]];
if (isNull _vehicle || {_uid isEqualTo ""}) exitWith {false};
private _keys = [_vehicle, "keys", []] call TON_fnc_serverGet;
if !(_keys isEqualType []) exitWith {false};
(_keys findIf {(_x param [0, ""]) isEqualTo _uid}) > -1
