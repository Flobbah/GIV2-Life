#include "..\..\..\script_macros.hpp"
/*
    File: fn_relaySend.sqf
    Description:
    Sends a player-to-player action (security phase 0.1b).
    With CfgRelay >> enabled = 1 the call goes to the server (TON_fnc_relay), which checks the real
    sender against the rule in config\Config_Relay.hpp and forwards it. With 0 it runs directly
    like in Altis Life 5.0. remoteExec or remoteExecCall is chosen by the rule's "scheduled" field.
    Parameters:
        0: STRING - function name, needs a class in CfgRelay >> Functions
        1: ARRAY  - arguments
        2: ANY    - remoteExec target (object, side, group, number or array)
    Example:
        ["life_fnc_restrain", [player], _unit] call life_fnc_relaySend;
*/
params [
    ["_fn", "", [""]],
    ["_args", [], [[]]],
    ["_target", objNull, [objNull, sideUnknown, grpNull, 0, []]]
];
if (_fn isEqualTo "") exitWith {};
if ((getNumber (missionConfigFile >> "CfgRelay" >> "enabled")) isEqualTo 1) exitWith {
    [_fn, _args, _target] remoteExecCall ["TON_fnc_relay", RSERV];
};
if ((getNumber (missionConfigFile >> "CfgRelay" >> "Functions" >> _fn >> "scheduled")) isEqualTo 1) then {
    _args remoteExec [_fn, _target];
} else {
    _args remoteExecCall [_fn, _target];
};
