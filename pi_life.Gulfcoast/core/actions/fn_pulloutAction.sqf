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
        //Sicherheitsprüfung #7: den Zustand setzt der Server (TON_fnc_custody), nicht der Client
        [_x,"outCar"] remoteExecCall ["TON_fnc_custody",RSERV];
        ["life_fnc_pulloutVeh",[_x],_x] call life_fnc_relaySend;
    };
} forEach _crew;
