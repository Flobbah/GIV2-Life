#include "..\..\script_macros.hpp"
/*
    File: fn_pulloutAction.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Pulls civilians out of a car if it's stopped.
*/
private ["_crew"];
_crew = crew cursorObject;
{
    if !(SIDE_OF(_x) isEqualTo west) then {
        _x setVariable ["transporting",false,true]; _x setVariable ["Escorting",false,true];
        ["life_fnc_pulloutVeh",[_x],_x] call life_fnc_relaySend;
    };
} forEach _crew;
