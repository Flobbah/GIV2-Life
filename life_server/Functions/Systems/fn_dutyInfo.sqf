#include "\life_server\script_macros.hpp"
/*
    File: fn_dutyInfo.sqf
    Description:
    Liefert dem Spieler seine Freigaben fuer die Telefon-App "Dienst": Cop-Rang, Medic-Rang,
    Adminlevel, Polizei-Sperre und ob er aktuell gesucht wird (life_fnc_dutyInfoReceive).
    Parameter:
        0: OBJECT - der anfragende Spieler
*/
params [["_unit",objNull,[objNull]]];
private _owner = remoteExecutedOwner;
if (isNull _unit || {!((owner _unit) isEqualTo _owner)}) exitWith {};
private _uid = getPlayerUID _unit;
if !(_uid regexMatch "\d{17}") exitWith {};
private _res = [format ["SELECT coplevel, mediclevel, adminlevel, blacklist FROM players WHERE pid='%1'",_uid],2] call DB_fnc_asyncCall;
if (count _res < 4) exitWith {};
private _wanted = [format ["SELECT wantedID FROM wanted WHERE wantedID='%1' AND active='1'",_uid],2] call DB_fnc_asyncCall;
[
    parseNumber (str (_res select 0)),
    parseNumber (str (_res select 1)),
    parseNumber (str (_res select 2)),
    [_res select 3,1] call DB_fnc_bool,
    (count _wanted) > 0
] remoteExec ["life_fnc_dutyInfoReceive",_owner];
