#include "\life_server\script_macros.hpp"
/*
    File: fn_invHarvest.sqf
    Description:
    Catching a fish and gutting an animal (docs/INVENTORY_AUTHORITY.md, package 3). Both turn one
    object in the world into one item, so the server checks the object, books the item and deletes the
    object itself - that also stops two players from harvesting the same animal. Which object gives
    which item is in CfgInventory >> harvest.
    Parameters:
        0: NUMBER - request id
        1: OBJECT - fish or animal carcass
    Answer data: [item], failure ["denied"] or ["full"]
*/
private _owner = CALLER_OWNER;
params [["_id", -1, [0]], ["_obj", objNull, [objNull]]];
if (INVENTORY_MODE isEqualTo 0) exitWith {};
private _info = [_owner] call TON_fnc_callerInfo;
if (_info isEqualTo []) exitWith {};
_info params ["_uid", "_unit", "_side", "_name"];
private _answer = {
    params ["_ok", ["_data", []]];
    [_id, _ok, _data] remoteExecCall ["life_fnc_econReply", _owner];
};
private _deny = {
    [_owner, "TON_fnc_invHarvest", _this] call TON_fnc_denyCaller;
    [false, ["denied"]] call _answer;
};
if (isNull _obj) exitWith {[false, ["denied"]] call _answer};
if ((_unit distance _obj) > 6) exitWith {"object too far from the sender" call _deny};
private _class = toLower (typeOf _obj);
private _item = "";
{
    if ((toLower (_x param [0, ""])) isEqualTo _class) exitWith {_item = _x param [1, ""]};
} forEach (getArray (missionConfigFile >> "CfgInventory" >> "harvest"));
if (_item isEqualTo "" || {!isClass (missionConfigFile >> "VirtualItems" >> _item)}) exitWith {
    format ["%1 cannot be harvested", typeOf _obj] call _deny;
};
if (_obj getVariable ["inUse", false]) exitWith {[false, ["denied"]] call _answer};
_obj setVariable ["inUse", true, true];
if !([_uid, _item, 1, "harvest"] call TON_fnc_invChange) exitWith {
    _obj setVariable ["inUse", false, true];
    [false, ["full"]] call _answer;
};
deleteVehicle _obj;
[true, [_item]] call _answer;
