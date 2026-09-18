#include "\life_server\script_macros.hpp"
/*
    File: fn_invAccept.sqf
    Description:
    The receiver of an offer (TON_fnc_invGive) answers how much of it fits into their inventory. The
    server books both sides and tells both players. An offer is valid for 20 seconds and only for the
    player it was sent to.
    Parameters:
        0: NUMBER - token from the offer
        1: NUMBER - how many items the receiver can take
*/
private _owner = CALLER_OWNER;
params [["_token", -1, [0]], ["_accepted", 0, [0]]];
if (INVENTORY_MODE isEqualTo 0) exitWith {};
private _info = [_owner] call TON_fnc_callerInfo;
if (_info isEqualTo []) exitWith {};
_info params ["_uid", "_unit", "_side", "_name"];
private _offers = localNamespace getVariable "life_inv_offers";
if (isNil "_offers") exitWith {};
private _entry = _offers get _token;
if (isNil "_entry") exitWith {};
_entry params ["_fromUid", "_toUid", "_item", "_amount", "_at", "_fromOwner", "_fromName"];
_offers deleteAt _token;
if (!(_toUid isEqualTo _uid) || {(diag_tickTime - _at) > 20}) exitWith {
    [_owner, "TON_fnc_invAccept", "offer does not belong to this player or has expired"] call TON_fnc_denyCaller;
};
_accepted = (round _accepted) min _amount min ([_fromUid, _item] call TON_fnc_invGet);
private _itemName = getText (missionConfigFile >> "VirtualItems" >> _item >> "displayName");
if (_accepted < 1) exitWith {
    ["STR_NOTF_couldNotGive", [], true] remoteExecCall ["life_fnc_econResult", _fromOwner];
};
[_fromUid, _item, -_accepted, "give"] call TON_fnc_invChange;
[_uid, _item, _accepted, "receive"] call TON_fnc_invChange;
["STR_NOTF_GivenItem", [_fromName, str _accepted, _itemName], true] remoteExecCall ["life_fnc_econResult", _owner];
["STR_NOTF_youGaveItem", [_name, str _accepted, _itemName], true] remoteExecCall ["life_fnc_econResult", _fromOwner];
