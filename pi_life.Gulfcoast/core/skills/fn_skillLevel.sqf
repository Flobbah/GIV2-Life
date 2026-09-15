/*
    File: fn_skillLevel.sqf
    Description:
    Liefert Stufe und Erfahrung eines Skills.
    Parameter:
        0: STRING - Skillname (Klasse in CfgSkills)
    Rueckgabe:
        ARRAY - [Stufe (0..5), XP, XP-Schwelle der aktuellen Stufe, XP-Schwelle der naechsten Stufe (-1 = Maximum)]
*/
params [["_skill","",[""]]];
private _xp = 0;
{
    if ((_x select 0) isEqualTo _skill) exitWith {_xp = _x select 1;};
} forEach (missionNamespace getVariable ["life_skills",[]]);
private _levels = getArray (missionConfigFile >> "CfgSkills" >> "xpLevels");
private _lvl = 0;
{
    if (_xp >= _x) then {_lvl = _forEachIndex + 1;};
} forEach _levels;
private _cur = if (_lvl isEqualTo 0) then {0} else {_levels select (_lvl - 1)};
private _next = if (_lvl >= count _levels) then {-1} else {_levels select _lvl};
[_lvl, _xp, _cur, _next]
