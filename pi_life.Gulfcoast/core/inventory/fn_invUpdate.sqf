#include "..\..\script_macros.hpp"
/*
    File: fn_invUpdate.sqf
    Description:
    The server changed one of this player's item counts (TON_fnc_invChange,
    docs/INVENTORY_AUTHORITY.md). The count is taken as it comes and the carry weight follows.
    Parameters:
        0: STRING - item variable (life_inv_<variable>)
        1: NUMBER - new count
*/
SERVER_ONLY_REMOTE;
params [["_var", "", [""]], ["_count", 0, [0]]];
if (_var isEqualTo "" || {!isClass (missionConfigFile >> "VirtualItems" >> _var)}) exitWith {};
_count = (round _count) max 0;
private _name = format ["life_inv_%1", _var];
private _old = missionNamespace getVariable [_name, 0];
if !(_old isEqualType 0) then {_old = 0};
missionNamespace setVariable [_name, _count];
life_carryWeight = (life_carryWeight + ((_count - _old) * ([_var] call life_fnc_itemWeight))) max 0;
if (!isNull (findDisplay 2001)) then {[] call life_fnc_p_updateMenu};
