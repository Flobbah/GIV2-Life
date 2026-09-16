#include "\life_server\script_macros.hpp"
/*
    File: fn_checkCaller.sqf
    Description:
    Standard sender validation for client-callable server functions (security phase 0.1).
    Calls made by the server itself (owner 2, including server-local call/spawn) are trusted.
    For client calls every non-empty argument must belong to the sender:
      unit - the object must be local to the sender (owner)
      uid  - must be the sender's Steam UID
      side - must be the sender's faction (life_side, falls back to the group side)
    Rejections are logged and blocked according to CfgServer >> CallerCheckMode (TON_fnc_denyCaller).
    Parameters:
        0: NUMBER - CALLER_OWNER, evaluated at the top of the calling function
        1: OBJECT - unit claimed by the client (objNull = do not check)
        2: STRING - uid claimed by the client ("" = do not check)
        3: SIDE   - side claimed by the client (sideUnknown = do not check)
        4: STRING - function name for the log
    Returns:
        BOOL - true = continue, false = stop processing
*/
params [
    ["_owner", 0, [0]],
    ["_unit", objNull, [objNull]],
    ["_uid", "", [""]],
    ["_side", sideUnknown, [sideUnknown]],
    ["_fn", "", [""]]
];
if (_owner isEqualTo 2) exitWith {true};
private _reason = "";
private _info = [_owner] call TON_fnc_callerInfo;
if (_info isEqualTo []) then {
    _reason = "unknown sender";
} else {
    _info params ["_senderUid", "", "_senderSide"];
    if (!isNull _unit && {!((owner _unit) isEqualTo _owner)}) then {
        _reason = format ["unit %1 does not belong to the sender", _unit];
    };
    if (_reason isEqualTo "" && {!(_uid isEqualTo "")} && {!(_uid isEqualTo _senderUid)}) then {
        _reason = format ["uid %1 is not the sender's uid", _uid];
    };
    if (_reason isEqualTo "" && {!(_side isEqualTo sideUnknown)} && {!(_senderSide isEqualTo sideUnknown)} && {!(_side isEqualTo _senderSide)}) then {
        _reason = format ["side %1 does not match the sender's side %2", _side, _senderSide];
    };
};
if (_reason isEqualTo "") exitWith {true};
!([_owner, _fn, _reason] call TON_fnc_denyCaller)
