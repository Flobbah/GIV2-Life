#include "\life_server\script_macros.hpp"
/*
    File: fn_invGive.sqf
    Description:
    A player wants to give virtual items to another player (docs/INVENTORY_AUTHORITY.md, package 3).
    Before this the sender removed the items itself and told the other client to add them, so a client
    could hand out goods it never had. The server checks the sender's stock in its own copy and then
    asks the receiver how much fits (life_fnc_invOffer -> TON_fnc_invAccept); only then both sides are
    booked. The receiver can only understate the space, which costs the receiver, not the sender.
    Parameters:
        0: NUMBER - request id
        1: OBJECT - receiver
        2: STRING - item
        3: NUMBER - amount
    Answer data: [] on a sent offer, failure ["items"] or ["denied"]
*/
private _owner = CALLER_OWNER;
params [["_id", -1, [0]], ["_target", objNull, [objNull]], ["_item", "", [""]], ["_amount", 0, [0]]];
if (INVENTORY_MODE isEqualTo 0) exitWith {};
private _info = [_owner] call TON_fnc_callerInfo;
if (_info isEqualTo []) exitWith {};
_info params ["_uid", "_unit", "_side", "_name"];
private _answer = {
    params ["_ok", ["_data", []]];
    [_id, _ok, _data] remoteExecCall ["life_fnc_econReply", _owner];
};
private _deny = {
    [_owner, "TON_fnc_invGive", _this] call TON_fnc_denyCaller;
    [false, ["denied"]] call _answer;
};
_amount = round _amount;
private _key = getText (missionConfigFile >> "VirtualItems" >> _item >> "variable");
switch (true) do {
    case (isNull _target || {!(_target isKindOf "CAManBase")} || {!(isPlayer _target)} || {_target isEqualTo _unit}): {"no player as receiver" call _deny};
    case ((_unit distance _target) > 25): {"receiver too far away" call _deny};
    case (_key isEqualTo "" || {_amount < 1} || {_amount > 10000}): {format ["invalid gift %1 x%2", _item, _amount] call _deny};
    case (([_uid, _item] call TON_fnc_invGet) < _amount): {[false, ["items"]] call _answer};
    default {
        private _offers = localNamespace getVariable "life_inv_offers";
        if (isNil "_offers") then {
            _offers = createHashMap;
            localNamespace setVariable ["life_inv_offers", _offers];
        };
        private _token = (localNamespace getVariable ["life_inv_offerId", 0]) + 1;
        localNamespace setVariable ["life_inv_offerId", _token];
        _offers set [_token, [_uid, getPlayerUID _target, _item, _amount, diag_tickTime, _owner, _name]];
        [_token, _item, _amount, _name] remoteExecCall ["life_fnc_invOffer", owner _target];
        [true] call _answer;
    };
};
