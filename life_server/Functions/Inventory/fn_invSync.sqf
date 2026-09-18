#include "\life_server\script_macros.hpp"
/*
    File: fn_invSync.sqf
    Description:
    Asks every player for a full list of their virtual items every CfgInventory >> syncInterval
    seconds (life_fnc_invReport answers to TON_fnc_invReport). Single changes arrive through
    TON_fnc_invTrack; this loop catches everything that never reported, which is exactly what a
    script executor does. Spawned by TON_fnc_invInit.
*/
private _interval = getNumber (missionConfigFile >> "CfgInventory" >> "syncInterval");
if (_interval < 10) exitWith {
    diag_log "[INVENTORY] full compare off (CfgInventory >> syncInterval)";
};
while {true} do {
    uiSleep _interval;
    {
        if ((owner _x) > 2 && {!((getPlayerUID _x) isEqualTo "")}) then {
            [] remoteExecCall ["life_fnc_invReport", owner _x];
        };
    } forEach allPlayers;
};
