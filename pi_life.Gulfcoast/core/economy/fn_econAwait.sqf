#include "..\..\script_macros.hpp"
/*
    File: fn_econAwait.sqf
    Description:
    Scheduled variant of life_fnc_econRequest for long running actions (robberies): sends the
    request and waits for the server's answer. Only call it from scheduled code (spawn/execVM/actions).
    Parameters:
        0: STRING - server function
        1: ARRAY  - arguments after the request id
        2: NUMBER - (optional) timeout in seconds, default 15
    Returns:
        ARRAY - [ok, data]; on timeout [false, ["timeout"]]
*/
params [["_function", "", [""]], ["_args", [], [[]]], ["_timeout", 15, [0]]];
private _results = localNamespace getVariable "life_econ_results";
if (isNil "_results") then {
    _results = createHashMap;
    localNamespace setVariable ["life_econ_results", _results];
};
private _token = format ["%1_%2", diag_tickTime, floor random 1e6];
[_function, _args, {
    (localNamespace getVariable "life_econ_results") set [(_this select 1) select 0, [true, _this select 0]];
}, {
    (localNamespace getVariable "life_econ_results") set [(_this select 1) select 0, [false, _this select 0]];
}, [_token]] call life_fnc_econRequest;
private _end = diag_tickTime + _timeout;
waitUntil {(_token in _results) || {diag_tickTime > _end}};
private _result = _results getOrDefault [_token, [false, ["timeout"]]];
_results deleteAt _token;
_result
