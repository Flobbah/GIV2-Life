#include "\life_server\script_macros.hpp"
/*
    File: fn_denyCaller.sqf
    Description:
    Logs a rejected client request as [SECURITY] and decides whether it is blocked (phase 0.1/0.4).
    CfgServer >> CallerCheckMode in description.ext: 0 = checks off, 1 = log only, 2 = log and block.
    A missing setting counts as 2.
    Parameters:
        0: NUMBER - owner id of the sender
        1: STRING - function name
        2: STRING - reason (English, for the server log)
    Returns:
        BOOL - true = the request must be stopped
*/
params [["_owner", 0, [0]], ["_fn", "", [""]], ["_reason", "", [""]]];
private _cfg = missionConfigFile >> "CfgServer" >> "CallerCheckMode";
private _mode = if (isNumber _cfg) then {getNumber _cfg} else {2};
if (_mode isEqualTo 0) exitWith {false};
private _info = [_owner] call TON_fnc_callerInfo;
diag_log format ["[SECURITY] %1 %2 - owner %3, uid %4, name %5: %6",
    _fn,
    ["logged (CallerCheckMode 1, not blocked)", "rejected"] select (_mode isEqualTo 2),
    _owner, _info param [0, "?"], _info param [3, "?"], _reason
];
_mode isEqualTo 2
