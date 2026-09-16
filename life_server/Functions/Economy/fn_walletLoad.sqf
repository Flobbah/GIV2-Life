#include "\life_server\script_macros.hpp"
/*
    File: fn_walletLoad.sqf
    Description:
    Sets a player's server-side wallet from database values (login in DB_fnc_queryRequest).
    Parameters:
        0: STRING - player uid
        1: NUMBER or STRING - cash from the database
        2: NUMBER or STRING - bank from the database
*/
params [["_uid", "", [""]], ["_cash", 0, [0, ""]], ["_bank", 0, [0, ""]]];
if (ECONOMY_MODE isEqualTo 0 || {!(_uid regexMatch "\d{17}")}) exitWith {};
if (_cash isEqualType "") then {_cash = parseNumber _cash};
if (_bank isEqualType "") then {_bank = parseNumber _bank};
private _wallets = localNamespace getVariable "life_econ_wallets";
if (isNil "_wallets") exitWith {};
_wallets set [_uid, [round _cash, round _bank]];
