#include "..\..\script_macros.hpp"
/*
    File: fn_skillAddXP.sqf
    Description:
    Schreibt einem Skill Erfahrung gut, meldet Stufenaufstiege und markiert die Skills zum Speichern.
    Parameter:
        0: STRING - Skillname
        1: NUMBER - Erfahrung (Standard: xpPerAction aus CfgSkills)
*/
params [["_skill","",[""]],["_amount",-1,[0]]];
private _cfg = missionConfigFile >> "CfgSkills" >> _skill;
if (!isClass _cfg) exitWith {};
if (!(missionNamespace getVariable ["life_skills_loaded",false])) exitWith {}; //noch nicht geladen: nichts ueberschreiben
if (_amount < 0) then {_amount = getNumber (_cfg >> "xpPerAction");};
if (_amount <= 0) exitWith {};
private _levels = getArray (missionConfigFile >> "CfgSkills" >> "xpLevels");
private _max = _levels select ((count _levels) - 1);
private _before = ([_skill] call life_fnc_skillLevel) select 0;
private _idx = life_skills findIf {(_x select 0) isEqualTo _skill};
if (_idx < 0) then {
    life_skills pushBack [_skill, 0];
    _idx = (count life_skills) - 1;
};
private _entry = life_skills select _idx;
private _xp = ((_entry select 1) + _amount) min _max;
if (_xp isEqualTo (_entry select 1)) exitWith {};
_entry set [1, _xp];
life_skills_dirty = true;
private _after = ([_skill] call life_fnc_skillLevel) select 0;
if (_after > _before) then {
    [ format [localize "STR_SK_LevelUp", localize (getText (_cfg >> "displayName")), _after], false, ""] call life_fnc_notification_system;
    playSound "FD_Finish_F";
    if (_skill isEqualTo "carry") then {life_maxWeight = [] call life_fnc_skillMaxWeight;};
    [] call life_fnc_skillsSave;
};
