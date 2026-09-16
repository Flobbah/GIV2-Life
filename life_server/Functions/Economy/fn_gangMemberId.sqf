#include "\life_server\script_macros.hpp"
/*
    File: fn_gangMemberId.sqf
    Description:
    Returns the gang id of a player's group if the player is a member of that gang in the database
    (docs/ECONOMY_AUTHORITY.md, step 2 package 4). The group variable gang_id alone can be set by any
    client, the members list in the database cannot.
    Parameters:
        0: STRING - player uid
        1: OBJECT - player unit
    Returns:
        NUMBER - gang id, -1 when the player is not a member
*/
params [["_uid", "", [""]], ["_unit", objNull, [objNull]]];
if (isNull _unit || {!(_uid regexMatch "\d{17}")}) exitWith {-1};
private _gangId = (group _unit) getVariable ["gang_id", -1];
if (!(_gangId isEqualType 0) || {_gangId < 0}) exitWith {-1};
private _res = [format ["SELECT members FROM gangs WHERE id='%1' AND active='1'", round _gangId], 2] call DB_fnc_asyncCall;
if (!(_res isEqualType []) || {count _res isEqualTo 0}) exitWith {-1};
private _members = _res select 0;
private _isMember = switch (true) do {
    case (_members isEqualType ""): {(_members find _uid) > -1};
    case (_members isEqualType []): {_uid in _members};
    default {false};
};
[-1, round _gangId] select _isMember
