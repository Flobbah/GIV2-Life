#include "..\..\script_macros.hpp"
/*
    File: fn_adminHealed.sqf
    Description:
    Executed on the healed player (remoteExec from fn_adminHeal):
    full health, food and water, no fatigue.
*/
params [["_admin",objNull,[objNull]]];
if (isNull _admin || {!alive player}) exitWith {};
player setDamage 0;
player setFatigue 0;
life_hunger = 100;
life_thirst = 100;
[] call life_fnc_hudUpdate;
if !(_admin isEqualTo player) then {
    [ format [localize "STR_ANOTF_Healed",_admin getVariable ["realname",name _admin]],false,"fast"] call life_fnc_notification_system;
};
