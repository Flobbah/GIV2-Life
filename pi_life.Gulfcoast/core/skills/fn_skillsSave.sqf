#include "..\..\script_macros.hpp"
/*
    File: fn_skillsSave.sqf
    Description:
    Schickt die Skills an den Server (TON_fnc_skillsSave), der sie in players.skills speichert.
    Wird von der Speicherschleife (fn_skillsInit) und bei Stufenaufstieg aufgerufen.
*/
if (!(missionNamespace getVariable ["life_skills_loaded",false])) exitWith {};
if (!(missionNamespace getVariable ["life_skills_dirty",false])) exitWith {};
life_skills_dirty = false;
[life_skills] remoteExec ["TON_fnc_skillsSave", RSERV];
