#include "..\..\script_macros.hpp"
/*
    File: fn_hudSetup.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Setups the hud for the player?
*/
disableSerialization;
//Frische Steuerelemente -> in fn_hudUpdate alles einmal neu zeichnen.
//0-4: Konto, Bargeld, Polizei, Rettungsdienst, Zivilisten; 5-7: Warnstufe von Leben, Hunger, Durst
life_hud_cache = [-1,-1,-1,-1,-1,-1,-1,-1];
cutRsc ["new_HUD", "PLAIN", 2, false];
[] call life_fnc_hudUpdate;
