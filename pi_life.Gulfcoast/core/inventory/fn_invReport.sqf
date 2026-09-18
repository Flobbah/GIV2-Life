#include "..\..\script_macros.hpp"
/*
    File: fn_invReport.sqf
    Description:
    Sends everything this player carries to the server (docs/INVENTORY_AUTHORITY.md). The server asks
    for it regularly (TON_fnc_invSync) and after events that empty the inventory without going through
    life_fnc_handleInv (death, duty switch).
*/
SERVER_ONLY_REMOTE; //Sicherheitsphase 0.1: nur der Server fragt danach
if (INVENTORY_MODE isEqualTo 0) exitWith {};
private _items = [];
{
    private _var = getText (_x >> "variable");
    private _value = missionNamespace getVariable [format ["life_inv_%1", _var], 0];
    if (_value isEqualType 0 && {_value > 0}) then {_items pushBack [_var, round _value]};
} forEach ("true" configClasses (missionConfigFile >> "VirtualItems"));
[_items] remoteExecCall ["TON_fnc_invReport", RSERV];
