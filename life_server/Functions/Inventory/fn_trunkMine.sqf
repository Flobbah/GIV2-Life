#include "\life_server\script_macros.hpp"
/*
    File: fn_trunkMine.sqf
    Description:
    The mining device (Tempest) fills its own trunk (docs/INVENTORY_AUTHORITY.md, package 4). Before
    this the client wrote the trunk itself, which after package 4 would have been overwritten by the
    server on the next save. The server now checks the zone under the vehicle, rolls the amount and
    books it into its own copy of the trunk.
    Parameters:
        0: NUMBER - request id
        1: OBJECT - the device
        2: NUMBER - how much the client thinks fits (only lowers the amount)
    Answer data: [resource, amount], failure ["space"] or ["denied"]
*/
private _owner = CALLER_OWNER;
params [["_id", -1, [0]], ["_veh", objNull, [objNull]], ["_want", 0, [0]]];
if (INVENTORY_MODE isEqualTo 0) exitWith {};
private _info = [_owner] call TON_fnc_callerInfo;
if (_info isEqualTo []) exitWith {};
_info params ["_uid", "_unit", "_side", "_name"];
private _answer = {
    params ["_ok", ["_data", []]];
    [_id, _ok, _data] remoteExecCall ["life_fnc_econReply", _owner];
};
private _deny = {
    [_owner, "TON_fnc_trunkMine", _this] call TON_fnc_denyCaller;
    [false, ["denied"]] call _answer;
};
if (isNull _veh || {!((typeOf _veh) isEqualTo "O_Truck_03_device_F")}) exitWith {"not a mining device" call _deny};
if ((_unit distance _veh) > 30) exitWith {"device too far from the sender" call _deny};
([_veh, ["gather", "mine"]] call TON_fnc_invZone) params [["_resource", ""], ["_max", 0]];
if (_resource isEqualTo "") exitWith {[false, ["denied"]] call _answer};
private _trunk = [_veh] call TON_fnc_trunkGet;
private _items = +(_trunk select 0);
private _weight = getNumber (missionConfigFile >> "VirtualItems" >> _resource >> "weight");
private _amount = 10 + (round (random 10));
if (_want > 0) then {_amount = _amount min (round _want)};
if (_weight > 0) then {_amount = _amount min (floor ((([_veh] call TON_fnc_trunkSpace) - (_trunk select 1)) / _weight))};
if (_amount < 1) exitWith {[false, ["space"]] call _answer};
private _index = _items findIf {(_x param [0, ""]) isEqualTo _resource};
if (_index < 0) then {_items pushBack [_resource, _amount]} else {
    _items set [_index, [_resource, ((_items select _index) param [1, 0]) + _amount]];
};
[_veh, _items] call TON_fnc_trunkSet;
[true, [_resource, _amount]] call _answer;
