#include "..\..\script_macros.hpp"
/*
    File: fn_knockoutAction.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Knocks out the target.
*/
private "_target";
_target = param [0,objNull,[objNull]];
//Error checks
if (isNull _target) exitWith {};
if (!isPlayer _target) exitWith {};
if (player distance _target > 4) exitWith {};
life_knockout = true;
["life_fnc_animSync",[player,"AwopPercMstpSgthWrflDnon_End2"],RCLIENT] call life_fnc_relaySend;
sleep 0.08;
["life_fnc_knockedOut",[_target,profileName],_target] call life_fnc_relaySend;
sleep 3;
life_knockout = false;
