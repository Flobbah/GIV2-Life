#include "\life_server\script_macros.hpp"
/*
    File: fn_serverGet.sqf
    Description:
    Reads a value from the server-only data store (security phase 0.2).
    Every client can overwrite public object variables (setVariable [..., true]) and
    missionNamespace globals (publicVariable). Values the server bases decisions on (faction,
    vehicle, house and container ownership, database ids) are therefore kept in localNamespace,
    which is never synchronised. The public variables with the same meaning still exist for the
    clients' own UI. Counterpart: TON_fnc_serverSet.
    Parameters:
        0: STRING, OBJECT or GROUP - key owner (player uid, or object/group by netId)
        1: STRING - field name
        2: ANY    - (optional) default when nothing is stored
    Returns:
        ANY - stored value, the default or nil
*/
params [["_key", "", ["", objNull, grpNull]], ["_field", "", [""]], "_default"];
if !(_key isEqualType "") then {
    _key = if (isNull _key) then {""} else {netId _key};
};
if (_key isEqualTo "" || {_field isEqualTo ""}) exitWith {_default};
private _store = localNamespace getVariable "life_server_data";
if (isNil "_store") exitWith {_default};
private _value = _store get format ["%1|%2", _key, _field];
if (isNil "_value") exitWith {_default};
_value
