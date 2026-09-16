#include "..\..\script_macros.hpp"
/*
    File: fn_adminDebugCon.sqf
    Author: ColinM9991
    Description:
    Opens the Debug Console.
*/
if (FETCH_CONST(life_adminlevel) < 5) exitWith {closeDialog 0; [ localize "STR_NOTF_adminDebugCon",true,"fast"] call life_fnc_notification_system;};
life_admin_debug = true;
createDialog "RscDisplayDebugPublic";
["life_fnc_broadcast",[0,format [localize "STR_NOTF_adminHasOpenedDebug",profileName]],RCLIENT] call life_fnc_relaySend;
