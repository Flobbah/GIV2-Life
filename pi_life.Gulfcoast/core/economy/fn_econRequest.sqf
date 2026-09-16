#include "..\..\script_macros.hpp"
/*
    File: fn_econRequest.sqf
    Description:
    Sends a money request to the server and continues the action when the answer arrives
    (docs/ECONOMY_AUTHORITY.md). The callbacks stay on this client; only the request id travels.
    SQF code does not keep the caller's local variables, so everything a callback needs goes into
    the context array. Callbacks run unscheduled (use spawn inside for sleeps) with
    _this = [data from the server, context].
    Parameters:
        0: STRING - server function, e.g. "TON_fnc_econFee"
        1: ARRAY  - arguments after the request id
        2: CODE   - on success
        3: CODE   - (optional) on failure; data e.g. ["money", price], ["cooldown"], ["denied"]
        4: ARRAY  - (optional) context for the callbacks
    Example:
        ["TON_fnc_econFee", ["hospital"], {player setDamage 0}, {hint "no money"}] call life_fnc_econRequest;
*/
params [["_function", "", [""]], ["_args", [], [[]]], ["_onSuccess", {}, [{}]], ["_onFail", {}, [{}]], ["_context", [], [[]]]];
if (_function isEqualTo "") exitWith {};
//localNamespace: never synchronised, so no other client can replace the stored callbacks via publicVariable
private _pending = localNamespace getVariable "life_econ_pending";
if (isNil "_pending") then {
    _pending = createHashMap;
    localNamespace setVariable ["life_econ_pending", _pending];
};
private _id = (localNamespace getVariable ["life_econ_nextId", 0]) + 1;
localNamespace setVariable ["life_econ_nextId", _id];
_pending set [_id, [_onSuccess, _onFail, _context]];
([_id] + _args) remoteExecCall [_function, RSERV];
