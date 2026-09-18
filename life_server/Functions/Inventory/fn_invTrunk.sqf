#include "\life_server\script_macros.hpp"
/*
    File: fn_invTrunk.sqf
    Description:
    Moving items between a player and a trunk (vehicle, house container, house)
    (docs/INVENTORY_AUTHORITY.md, package 4). Before this both sides were client-side: the player's
    items and the object variable "Trunk". Two players could empty the same trunk at the same time and
    a client could write itself a full one. The server now owns both sides and moves them in one step.
    Parameters:
        0: NUMBER - request id
        1: STRING - "store" (player -> trunk) or "take" (trunk -> player)
        2: OBJECT - trunk object
        3: STRING - item
        4: NUMBER - amount, 0 or less means as much as possible
        5: NUMBER - free carry weight of the player (only needed for "take")
    Answer data: [item, amount, weight in the trunk, capacity], failure ["items"], ["space"], ["full"]
*/
private _owner = CALLER_OWNER;
params [["_id", -1, [0]], ["_kind", "", [""]], ["_obj", objNull, [objNull]], ["_item", "", [""]], ["_amount", 0, [0]], ["_free", 0, [0]]];
if (INVENTORY_MODE isEqualTo 0) exitWith {};
private _info = [_owner] call TON_fnc_callerInfo;
if (_info isEqualTo []) exitWith {};
_info params ["_uid", "_unit", "_side", "_name"];
private _answer = {
    params ["_ok", ["_data", []]];
    [_id, _ok, _data] remoteExecCall ["life_fnc_econReply", _owner];
};
private _deny = {
    [_owner, "TON_fnc_invTrunk " + _kind, _this] call TON_fnc_denyCaller;
    [false, ["denied"]] call _answer;
};
private _itemCfg = missionConfigFile >> "VirtualItems" >> _item;
switch (true) do {
    case (!(_kind in ["store", "take"])): {"unknown kind" call _deny};
    case (isNull _obj): {[false, ["denied"]] call _answer};
    case ((_unit distance _obj) > 15): {"trunk too far from the sender" call _deny};
    case (!isClass _itemCfg): {format ["unknown item %1", _item] call _deny};
    case (_item isEqualTo "goldbar" && {!(_obj isKindOf "LandVehicle")} && {!(_obj isKindOf "House_F")}): {[false, ["denied"]] call _answer};
    default {
        private _trunk = [_obj] call TON_fnc_trunkGet;
        private _items = +(_trunk select 0);
        private _capacity = [_obj] call TON_fnc_trunkSpace;
        private _weight = getNumber (_itemCfg >> "weight");
        private _index = _items findIf {(_x param [0, ""]) isEqualTo _item};
        private _inTrunk = if (_index < 0) then {0} else {(_items select _index) param [1, 0]};
        _amount = round _amount;
        private _move = 0;
        if (_kind isEqualTo "store") then {
            private _fits = if (_weight > 0) then {floor ((_capacity - (_trunk select 1)) / _weight)} else {999999};
            _move = ([_uid, _item] call TON_fnc_invGet) min (0 max _fits);
            if (_amount > 0) then {_move = _move min _amount};
        } else {
            private _fits = if (_weight > 0) then {floor ((0 max _free) / _weight)} else {999999};
            _move = _inTrunk min _fits;
            if (_amount > 0) then {_move = _move min _amount};
        };
        if (_move < 1) exitWith {
            [false, [["space", "full"] select (_kind isEqualTo "take")]] call _answer;
        };
        private _booked = if (_kind isEqualTo "store") then {
            [_uid, _item, -_move, "trunk_store"] call TON_fnc_invChange
        } else {
            [_uid, _item, _move, "trunk_take"] call TON_fnc_invChange
        };
        if (!_booked) exitWith {[false, ["items"]] call _answer};
        if (_kind isEqualTo "store") then {
            if (_index < 0) then {_items pushBack [_item, _move]} else {_items set [_index, [_item, _inTrunk + _move]]};
        } else {
            if (_inTrunk isEqualTo _move) then {_items deleteAt _index} else {_items set [_index, [_item, _inTrunk - _move]]};
        };
        private _new = [_obj, _items] call TON_fnc_trunkSet;
        [true, [_item, _move, _new select 1, _capacity]] call _answer;
    };
};
