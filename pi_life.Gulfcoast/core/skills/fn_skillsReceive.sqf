#include "..\..\script_macros.hpp"
/*
    File: fn_skillsReceive.sqf
    Description:
    Antwort des Servers (TON_fnc_skillsLoad) mit den gespeicherten Skills des Spielers.
    Parameter:
        0: ARRAY - [[Skillname, XP], ...]
*/
params [["_skills",[],[[]]]];
if !(remoteExecutedOwner isEqualTo 2) exitWith {};
life_skills = _skills select {_x isEqualType [] && {count _x isEqualTo 2} && {(_x select 0) isEqualType ""} && {(_x select 1) isEqualType 0}};
life_skills_loaded = true;
life_skills_dirty = false;
life_maxWeight = [] call life_fnc_skillMaxWeight;
