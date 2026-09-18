#include "\life_server\script_macros.hpp"
/*
    File: fn_invDropped.sqf
    Description:
    A player died and their items fell on the ground (life_fnc_dropItems creates the objects). The
    server takes the items out of its copy and remembers what lies in that object, so picking it up
    gives exactly that and not what a client claims (docs/INVENTORY_AUTHORITY.md, package 3).
    Parameters:
        0: OBJECT - the object on the ground
        1: STRING - item
        2: NUMBER - amount
*/
private _owner = CALLER_OWNER;
params [["_obj", objNull, [objNull]], ["_item", "", [""]], ["_amount", 0, [0]]];
if (INVENTORY_MODE isEqualTo 0) exitWith {};
private _info = [_owner] call TON_fnc_callerInfo;
if (_info isEqualTo []) exitWith {};
_info params ["_uid", "_unit"];
_amount = round _amount;
private _key = getText (missionConfigFile >> "VirtualItems" >> _item >> "variable");
if (_key isEqualTo "" || {_amount < 1} || {isNull _obj}) exitWith {};
//Die Leiche zaehlt mit: beim Tod liegt der Spieler schon woanders
private _corpse = ((localNamespace getVariable ["life_relay_deaths", createHashMap]) getOrDefault [_owner, []]) param [1, objNull, [objNull]];
if ((_obj distance _unit) > 30 && {isNull _corpse || {(_obj distance _corpse) > 30}}) exitWith {
    [_owner, "TON_fnc_invDropped", "object too far from the sender"] call TON_fnc_denyCaller;
};
private _have = [_uid, _item] call TON_fnc_invGet;
private _stored = _amount min _have;
if (_stored < 1) exitWith {
    [_uid, "", format ["dropped %1 %2 but the server had %3", _amount, _key, _have]] call TON_fnc_invWarn;
};
[_uid, _item, -_stored, "death_drop"] call TON_fnc_invChange;
[_obj, "drop", [_item, _stored]] call TON_fnc_serverSet;
if !(_stored isEqualTo _amount) then {
    _obj setVariable ["item", [_item, _stored], true];
};
