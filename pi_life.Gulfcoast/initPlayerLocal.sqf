#include "script_macros.hpp"
/*
    File: initPlayerLocal.sqf
    Author:
    Description:
    Starts the initialization of the player.
*/
if (!hasInterface && !isServer) exitWith {
    [] call compile preprocessFileLineNumbers "\life_hc\initHC.sqf";
};
//Fraktion schon vor core\init.sqf setzen: Aktionsbedingungen in mission.sqm fragen life_side ab
if (isNil "life_side") then {life_side = playerSide;};
[] execVM "core\init.sqf";
[] execVM "briefing.sqf";
