#include "\life_server\script_macros.hpp"
/*
    File: fn_callerInfo.sqf
    Description:
    Identifies the client that sent a remote execution (security phase 0.1).
    Looks the owner id up in allPlayers first and falls back to allUsers/getUserInfo, so players
    whose unit is dead or not yet created are still recognised.
    Parameters:
        0: NUMBER - owner id of the sender (CALLER_OWNER / remoteExecutedOwner)
    Returns:
        ARRAY - [uid, unit, side (server-side store, TON_fnc_serverGet), name]; [] when the sender is the server or unknown
*/
params [["_owner", 0, [0]]];
if (_owner < 3) exitWith {[]};
private _unit = objNull;
{
    if ((owner _x) isEqualTo _owner) exitWith {_unit = _x;};
} forEach allPlayers;
private _uid = if (isNull _unit) then {""} else {getPlayerUID _unit};
private _name = if (isNull _unit) then {""} else {name _unit};
if (_uid isEqualTo "") then {
    {
        private _info = getUserInfo _x;
        if ((count _info) > 2 && {(_info select 1) isEqualTo _owner}) exitWith {
            _uid = _info select 2;
            _name = _info param [3, ""];
            if ((count _info) > 10 && {(_info select 10) isEqualType objNull}) then {_unit = _info select 10;};
        };
    } forEach allUsers;
};
if !(_uid regexMatch "\d{17}") exitWith {[]};
private _side = AUTH_SIDE(_uid); //Sicherheitsphase 0.2: aus dem Server-Speicher, life_side am Objekt ist faelschbar
[_uid, _unit, _side, _name]
