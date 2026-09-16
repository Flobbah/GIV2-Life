#include "..\..\script_macros.hpp"
/*
    File: fn_freezePlayer.sqf
    Author: ColinM9991
    Description:
    Freezes selected player.
*/
RELAY_ONLY_REMOTE; //Sicherheitsphase 0.1b: Aufrufe anderer Spieler nur ueber den Server (CfgRelay)
private ["_admin"];
_admin = [_this,0,objNull,[objNull]] call BIS_fnc_param;
if (life_frozen) then {
    [ localize "STR_NOTF_Unfrozen",true,"fast"] call life_fnc_notification_system;
    ["life_fnc_broadcast",[1,format [localize "STR_ANOTF_Unfrozen",profileName]],_admin] call life_fnc_relaySend;
    disableUserInput false;
    life_frozen = false;
} else {
    [ localize "STR_NOTF_Frozen",true,"fast"] call life_fnc_notification_system;
    ["life_fnc_broadcast",[1,format [localize "STR_ANOTF_Frozen",profileName]],_admin] call life_fnc_relaySend;
    disableUserInput true;
    life_frozen = true;
};
