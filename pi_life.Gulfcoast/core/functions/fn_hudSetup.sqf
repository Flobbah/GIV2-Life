#include "..\..\script_macros.hpp"
/*
    File: fn_hudSetup.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Setups the hud for the player?
*/
disableSerialization;
life_hud_cache = [-1,-1,-1,-1,-1]; //Fresh controls -> force a full redraw in fn_hudUpdate
cutRsc ["new_HUD", "PLAIN", 2, false];
[] call life_fnc_hudUpdate;
