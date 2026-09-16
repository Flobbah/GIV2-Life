#include "\life_server\script_macros.hpp"
/*
    File: fn_publishProtected.sqf
    Description:
    Publishes a global that only the server may change (security phase 0.2). Keeps the real value
    in localNamespace, broadcasts it, and restores it at once if a client broadcasts something else
    ([SECURITY] log). Server checks read the localNamespace copy:
        localNamespace getVariable ["life_protected_<name>", default]
    Parameters:
        0: STRING - variable name
        1: ANY    - value
*/
params [["_name", "", [""]], "_value"];
if (_name isEqualTo "" || {isNil "_value"}) exitWith {};
missionNamespace setVariable [_name, _value];
localNamespace setVariable ["life_protected_" + _name, _value];
publicVariable _name;
private _handled = localNamespace getVariable "life_protected_handlers";
if (isNil "_handled") then {
    _handled = [];
    localNamespace setVariable ["life_protected_handlers", _handled];
};
if (_name in _handled) exitWith {};
_handled pushBack _name;
_name addPublicVariableEventHandler {
    params ["_name", "_value"];
    private _real = localNamespace getVariable ("life_protected_" + _name);
    if (isNil "_real" || {_value isEqualTo _real}) exitWith {};
    diag_log format ["[SECURITY] publicVariable %1 = %2 was sent by a client, restored to %3", _name, _value, _real];
    missionNamespace setVariable [_name, _real];
    publicVariable _name;
};
