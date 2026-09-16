#include "..\..\script_macros.hpp"
/*
    File: fn_requestMedic.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    N/A
*/
private "_medicsOnline";
_medicsOnline = {!(_x isEqualTo player) && {SIDE_OF(_x) isEqualTo independent} && {alive _x}} count playableUnits > 0; //Check if medics (indep) are in the room.
life_corpse setVariable ["Revive",false,true]; //Set the corpse to a revivable state.
if (_medicsOnline) then {
    //There is medics let's send them the request.
    ["life_fnc_medicRequest",[life_corpse,profileName],independent] call life_fnc_relaySend;
} else {
    //No medics were online, send it to the police.
    ["life_fnc_medicRequest",[life_corpse,profileName],west] call life_fnc_relaySend;
};
//Create a thread to monitor duration since last request (prevent spammage).
[] spawn  {
    ((findDisplay 7300) displayCtrl 7303) ctrlEnable false;
    sleep (2 * 60);
    ((findDisplay 7300) displayCtrl 7303) ctrlEnable true;
};
