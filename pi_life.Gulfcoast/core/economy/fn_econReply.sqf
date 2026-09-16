#include "..\..\script_macros.hpp"
/*
    File: fn_econReply.sqf
    Description:
    Server answer to life_fnc_econRequest: runs the stored success or failure callback once.
    Parameters:
        0: NUMBER - request id
        1: BOOL   - true = the server booked the money
        2: ARRAY  - data for the callback
*/
SERVER_ONLY_REMOTE;
params [["_id", -1, [0]], ["_ok", false, [false]], ["_data", [], [[]]]];
private _pending = localNamespace getVariable "life_econ_pending";
if (isNil "_pending") exitWith {};
private _entry = _pending get _id;
if (isNil "_entry") exitWith {};
_pending deleteAt _id;
[_data, _entry select 2] call (_entry select ([1, 0] select _ok));
