#include "..\..\script_macros.hpp"
/*
    File: fn_adminDeleteVeh.sqf
    Description:
    Deletes the (empty) vehicle the admin looks at (max. 25m).
    Persistent vehicles are handed to the server "impound" routine so they are
    flagged inactive in the database and can be taken out of the garage again.
*/
if (FETCH_CONST(life_adminlevel) < 4) exitWith {closeDialog 0; [ localize "STR_ANOTF_ErrorLevel",true,"fast"] call life_fnc_notification_system;};
private _veh = cursorObject;
private _types = ["LandVehicle","Air","Ship"];
if (isNull _veh || {!(KINDOF_ARRAY(_veh,_types))} || {player distance _veh > 25}) exitWith {[ localize "STR_ANOTF_NoVehicle",true,"fast"] call life_fnc_notification_system;};
if !((crew _veh) isEqualTo []) exitWith {[ localize "STR_ANOTF_VehOccupied",true,"fast"] call life_fnc_notification_system;};
closeDialog 0;
private _name = getText (configFile >> "CfgVehicles" >> (typeOf _veh) >> "displayName");
if (LIFE_HC_ACTIVE) then {
    [_veh,true,player,""] remoteExecCall ["HC_fnc_vehicleStore",HC_Life];
} else {
    [_veh,true,player,""] remoteExecCall ["TON_fnc_vehicleStore",RSERV];
};
if (LIFE_SETTINGS(getNumber,"player_advancedLog") isEqualTo 1) then {
    advanced_log = format ["[ADMIN VEHICLE] %1 (%2) deleted %3",profileName,getPlayerUID player,typeOf _veh];
    [advanced_log] remoteExecCall ["TON_fnc_clientLog",RSERV];
};
[ format [localize "STR_ANOTF_VehDeleted",_name],false,"fast"] call life_fnc_notification_system;
