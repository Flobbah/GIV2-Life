#include "\life_server\script_macros.hpp"
/*
    File: fn_walletSync.sqf
    Description:
    A client asks for its own balances (docs/ECONOMY_AUTHORITY.md, step 4). Used after events that
    reset the local display (respawn, being searched). Nothing the client sends is taken over, the
    answer always holds the server's values. Rate limit: one request every 3 seconds per player.
*/
private _owner = CALLER_OWNER;
if (ECONOMY_MODE isEqualTo 0) exitWith {};
private _info = [_owner] call TON_fnc_callerInfo;
if (_info isEqualTo []) exitWith {};
private _uid = _info select 0;
private _store = localNamespace getVariable "life_econ_sync";
if (isNil "_store") then {
    _store = createHashMap;
    localNamespace setVariable ["life_econ_sync", _store];
};
if ((diag_tickTime - (_store getOrDefault [_uid, -1e9])) < 3) exitWith {};
_store set [_uid, diag_tickTime];
[_uid] call TON_fnc_walletEnsure;
[_uid] call TON_fnc_walletPush;
