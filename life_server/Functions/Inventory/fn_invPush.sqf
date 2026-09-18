#include "\life_server\script_macros.hpp"
/*
    File: fn_invPush.sqf
    Description:
    Sends one item count of the server-side copy to its owner (life_fnc_invUpdate). Server-only.
    Parameters:
        0: STRING - player uid
        1: STRING - item variable, as it is stored in the server copy
        2: NUMBER - new count
    Returns:
        BOOL - true when a client was reached
*/
params [["_uid", "", [""]], ["_key", "", [""]], ["_count", 0, [0]]];
if (_key isEqualTo "") exitWith {false};
private _owner = 0;
{
    if ((getPlayerUID _x) isEqualTo _uid) exitWith {_owner = owner _x};
} forEach allPlayers;
if (_owner < 3) exitWith {false};
[_key, _count] remoteExecCall ["life_fnc_invUpdate", _owner];
true
