#include "\life_server\script_macros.hpp"
/*
    File: fn_walletPush.sqf
    Description:
    Sends a player's balances to their client (life_fnc_moneyUpdate, docs/ECONOMY_AUTHORITY.md).
    In shadow mode (EconomyMode 1) the client only applies the two changes and keeps its own value,
    in enforce mode (2) it takes the balances as they are. Server-only.
    Parameters:
        0: STRING - player uid
        1: NUMBER - (optional) cash change that led to this push
        2: NUMBER - (optional) bank change
    Returns:
        BOOL - true when a client was reached
*/
params [["_uid", "", [""]], ["_deltaCash", 0, [0]], ["_deltaBank", 0, [0]]];
if (ECONOMY_MODE isEqualTo 0 || {!(_uid regexMatch "\d{17}")}) exitWith {false};
private _wallet = (localNamespace getVariable ["life_econ_wallets", createHashMap]) getOrDefault [_uid, []];
if (!(count _wallet isEqualTo 2)) exitWith {false};
private _owner = 0;
{
    if ((getPlayerUID _x) isEqualTo _uid) exitWith {_owner = owner _x};
} forEach allPlayers;
if (_owner < 3) exitWith {false};
[_wallet select 0, _wallet select 1, _deltaCash, _deltaBank] remoteExecCall ["life_fnc_moneyUpdate", _owner];
true
