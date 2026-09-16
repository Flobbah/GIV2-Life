#include "\life_server\script_macros.hpp"
/*
    File: fn_serverSet.sqf
    Description:
    Writes a value into the server-only data store (security phase 0.2, see TON_fnc_serverGet).
    Arrays are copied so later changes to a public variable never reach the stored value.
    Parameters:
        0: STRING, OBJECT or GROUP - key owner (player uid, or object/group by netId)
        1: STRING - field name
        2: ANY    - new value; nil removes the field
*/
params [["_key", "", ["", objNull, grpNull]], ["_field", "", [""]], "_value"];
if !(_key isEqualType "") then {
    _key = if (isNull _key) then {""} else {netId _key};
};
if (_key isEqualTo "" || {_field isEqualTo ""}) exitWith {};
private _store = localNamespace getVariable "life_server_data";
if (isNil "_store") then {
    _store = createHashMap;
    localNamespace setVariable ["life_server_data", _store];
};
private _id = format ["%1|%2", _key, _field];
if (isNil "_value") exitWith {_store deleteAt _id;};
if (_value isEqualType []) then {_value = +_value};
_store set [_id, _value];
