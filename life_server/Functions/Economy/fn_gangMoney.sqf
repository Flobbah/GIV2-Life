#include "\life_server\script_macros.hpp"
/*
    File: fn_gangMoney.sqf
    Description:
    The server's way to change a gang bank (docs/ECONOMY_AUTHORITY.md, step 2 package 4). The
    balance is loaded once from the database and then kept on the server; the public group variable
    gang_bank only mirrors it for the clients' display. A change below zero is refused.
    Server-only, never with an amount a client chose without checking it first.
    Parameters:
        0: NUMBER - gang id
        1: NUMBER - signed change
        2: STRING - reason code for the transaction log
        3: STRING - (optional) player uid involved
        4: STRING - (optional) details
    Returns:
        BOOL - true when the change was applied
*/
params [["_gangId", -1, [0]], ["_delta", 0, [0]], ["_reason", "", [""]], ["_counterpart", "", [""]], ["_meta", "", [""]]];
if (ECONOMY_MODE isEqualTo 0 || {_gangId < 0} || {_reason isEqualTo ""}) exitWith {false};
_gangId = round _gangId;
_delta = round _delta;
private _gangs = localNamespace getVariable "life_econ_gangs";
if (isNil "_gangs") then {
    _gangs = createHashMap;
    localNamespace setVariable ["life_econ_gangs", _gangs];
};
private _bank = _gangs get _gangId;
if (isNil "_bank") then {
    private _res = [format ["SELECT bank FROM gangs WHERE id='%1' AND active='1'", _gangId], 2] call DB_fnc_asyncCall;
    if (_res isEqualType [] && {count _res > 0}) then {
        _bank = _res select 0;
        if (_bank isEqualType "") then {_bank = parseNumber _bank};
        if !(_bank isEqualType 0) then {_bank = 0};
        _gangs set [_gangId, _bank];
    };
};
if (isNil "_bank") exitWith {false};
private _new = _bank + _delta;
if (_new < 0) exitWith {false};
_gangs set [_gangId, _new];
[format ["UPDATE gangs SET bank='%1' WHERE id='%2'", [_new] call DB_fnc_numberSafe, _gangId], 1] call DB_fnc_asyncCall;
["", _gangId, "gang", _delta, _new, _reason, _counterpart, _meta] call TON_fnc_moneyLog;
{
    if (((_x getVariable ["gang_id", -1]) isEqualTo _gangId)) then {_x setVariable ["gang_bank", _new, true]};
} forEach allGroups;
true
