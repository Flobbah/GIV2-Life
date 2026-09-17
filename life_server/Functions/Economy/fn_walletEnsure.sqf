#include "\life_server\script_macros.hpp"
/*
    File: fn_walletEnsure.sqf
    Description:
    Returns a player's server-side wallet (docs/ECONOMY_AUTHORITY.md). Normally it was loaded at
    login by TON_fnc_walletLoad; if it is missing (money booked for a player who already left, a
    save that arrives before the login query) the balances are read from the database. Server-only.
    Parameters:
        0: STRING - player uid
    Returns:
        ARRAY - [cash, bank], the stored array itself (changing it changes the wallet), [] on failure
*/
params [["_uid", "", [""]]];
if (!(_uid regexMatch "\d{17}")) exitWith {[]};
private _wallets = localNamespace getVariable "life_econ_wallets";
if (isNil "_wallets") exitWith {[]};
private _wallet = _wallets get _uid;
if (!isNil "_wallet") exitWith {_wallet};
private _res = [format ["SELECT cash, bankacc FROM players WHERE pid='%1'", _uid], 2] call DB_fnc_asyncCall;
if (!(_res isEqualType []) || {count _res < 2}) exitWith {[]};
private _cash = _res select 0;
private _bank = _res select 1;
if (_cash isEqualType "") then {_cash = parseNumber _cash};
if (_bank isEqualType "") then {_bank = parseNumber _bank};
if (!(_cash isEqualType 0) || {!(_bank isEqualType 0)}) exitWith {[]};
_wallet = [round _cash, round _bank];
_wallets set [_uid, _wallet];
diag_log format ["[ECONOMY] wallet %1 loaded from the database (cash %2, bank %3)", _uid, [_wallet select 0] call DB_fnc_numberSafe, [_wallet select 1] call DB_fnc_numberSafe];
_wallet
