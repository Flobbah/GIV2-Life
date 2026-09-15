#include "..\..\script_macros.hpp"
/*
    File: fn_skillsInit.sqf
    Description:
    Startet das Skill-System beim Client: Standardwerte setzen, Skills vom Server laden und
    eine Schleife starten, die geaenderte Skills regelmaessig in der Datenbank speichert.
    life_skills = [[Skillname, XP], ...]
    Wird einmal aus core\init.sqf aufgerufen (nach dem Login).
*/
if (!hasInterface) exitWith {};
life_skills = [];
life_skills_dirty = false;
life_skills_loaded = false;
[] remoteExec ["TON_fnc_skillsLoad", RSERV];
[] spawn {
    private _interval = (getNumber (missionConfigFile >> "CfgSkills" >> "saveInterval")) max 10;
    while {true} do {
        sleep _interval;
        if (life_skills_dirty) then {[] call life_fnc_skillsSave;};
    };
};
