#include "\life_server\script_macros.hpp"
/*
    File: fn_skillsSave.sqf
    Description:
    Speichert die Skills des sendenden Spielers in players.skills. Es werden nur bekannte Skills
    (Klassen in CfgSkills) uebernommen, die Erfahrung wird auf 0..Maximalwert begrenzt.
    Parameter:
        0: ARRAY - [[Skillname, XP], ...]
*/
params [["_skills",[],[[]]]];
private _owner = remoteExecutedOwner;
private _unit = objNull;
{
    if ((owner _x) isEqualTo _owner) exitWith {_unit = _x;};
} forEach playableUnits;
if (isNull _unit) exitWith {};
private _uid = getPlayerUID _unit;
if !(_uid regexMatch "\d{17}") exitWith {};
private _names = ("true" configClasses (missionConfigFile >> "CfgSkills")) apply {configName _x};
private _levels = getArray (missionConfigFile >> "CfgSkills" >> "xpLevels");
private _max = _levels select ((count _levels) - 1);
private _clean = [];
{
    if (_x isEqualType [] && {count _x isEqualTo 2} && {(_x select 0) isEqualType ""} && {(_x select 1) isEqualType 0} && {(_x select 0) in _names}) then {
        private _xp = (round ((_x select 1) * 10)) / 10; //eine Nachkommastelle (Bruchteile durch Gewichts-/Stueck-XP)
        _clean pushBack [_x select 0, (_xp max 0) min _max];
    };
} forEach _skills;
[format ["UPDATE players SET skills='%1' WHERE pid='%2'",[_clean] call DB_fnc_mresArray,_uid],1] call DB_fnc_asyncCall;
