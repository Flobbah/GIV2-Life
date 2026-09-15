#include "\life_server\script_macros.hpp"
/*
    File: fn_skillsLoad.sqf
    Description:
    Liest die Skills des anfragenden Spielers aus players.skills und schickt sie zurueck
    (life_fnc_skillsReceive). Der Spieler wird ueber remoteExecutedOwner ermittelt.
    Fehlt die Spalte (Migration skills_migration.sql nicht ausgefuehrt), meldet extDB3 einen
    Fehler und der Spieler bleibt ohne Skills.
*/
private _owner = remoteExecutedOwner;
private _unit = objNull;
{
    if ((owner _x) isEqualTo _owner) exitWith {_unit = _x;};
} forEach playableUnits;
if (isNull _unit) exitWith {};
private _uid = getPlayerUID _unit;
if !(_uid regexMatch "\d{17}") exitWith {};
private _res = [format ["SELECT skills FROM players WHERE pid='%1'",_uid],2] call DB_fnc_asyncCall;
if (count _res isEqualTo 0) exitWith {diag_log format ["[SKILLS] Keine Daten fuer %1 (Spalte players.skills vorhanden?)",_uid];};
private _skills = [_res select 0] call DB_fnc_mresToArray;
if (_skills isEqualType "") then {_skills = call compile format ["%1",_skills];};
if !(_skills isEqualType []) then {_skills = [];};
[_skills] remoteExec ["life_fnc_skillsReceive", _owner];
