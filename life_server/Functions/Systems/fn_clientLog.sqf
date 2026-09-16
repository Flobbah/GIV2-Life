#include "\life_server\script_macros.hpp"
/*
    File: fn_clientLog.sqf
    Description:
    Writes a client-reported log line (money_log / advanced_log) with the verified sender
    (security phase 0.2). Replaces the publicVariableServer handlers, which any client could feed
    with lines in someone else's name. The text itself is still reported by the client, the
    [CLIENT LOG] prefix names who really sent it. At most 20 lines per client in 10 seconds.
    Parameters:
        0: STRING - log text
*/
private _owner = CALLER_OWNER;
params [["_text", "", [""]]];
if (_text isEqualTo "") exitWith {};
private _uid = "server";
private _name = "server";
if !(_owner isEqualTo 2) then {
    private _info = [_owner] call TON_fnc_callerInfo;
    _uid = _info param [0, ""];
    _name = _info param [3, ""];
};
if (_uid isEqualTo "") exitWith {};

private _rates = localNamespace getVariable "life_clientlog_rates";
if (isNil "_rates") then {
    _rates = createHashMap;
    localNamespace setVariable ["life_clientlog_rates", _rates];
};
private _rate = _rates getOrDefault [_owner, []];
if (_rate isEqualTo [] || {(diag_tickTime - (_rate select 0)) > 10}) then {
    _rate = [diag_tickTime, 0];
    _rates set [_owner, _rate];
};
_rate set [1, (_rate select 1) + 1];
if ((_rate select 1) > 20) exitWith {
    if ((_rate select 1) isEqualTo 21) then {
        diag_log format ["[SECURITY] TON_fnc_clientLog - owner %1, uid %2, name %3: more than 20 log lines within 10 s, dropping the rest", _owner, _uid, _name];
    };
};
diag_log format ["[CLIENT LOG] %1 (%2): %3", _name, _uid, _text select [0, 1000]];
