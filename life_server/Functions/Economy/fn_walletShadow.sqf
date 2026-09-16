#include "\life_server\script_macros.hpp"
/*
    File: fn_walletShadow.sqf
    Description:
    Shadow mode (docs/ECONOMY_AUTHORITY.md, step 1): compares the balances a client saves with the
    server-side wallet. Every difference is a money change the server did not make itself; it is
    written to the transaction log with reason "client_save", and the wallet follows the client.
    Large increases and negative balances are logged as [ECONOMY]. Once money flows run through
    TON_fnc_moneyChange, differences here only come from unconverted flows or manipulation.
    Parameters:
        0: STRING - player uid
        1: NUMBER - saved cash (nil = not part of this save)
        2: NUMBER - saved bank (nil = not part of this save)
        3: STRING - source, e.g. "updatePartial 0"
*/
params [["_uid", "", [""]], "_cash", "_bank", ["_source", "", [""]]];
if (ECONOMY_MODE isEqualTo 0 || {!(_uid regexMatch "\d{17}")}) exitWith {};
private _wallets = localNamespace getVariable "life_econ_wallets";
if (isNil "_wallets") exitWith {};
private _wallet = _wallets get _uid;
if (isNil "_wallet") exitWith {
    //No login seen (for example a server restart during the session): start from the saved values
    private _start = [0, 0];
    if (!isNil "_cash" && {_cash isEqualType 0}) then {_start set [0, round _cash]};
    if (!isNil "_bank" && {_bank isEqualType 0}) then {_start set [1, round _bank]};
    _wallets set [_uid, _start];
};
private _name = "";
{
    if ((getPlayerUID _x) isEqualTo _uid) exitWith {_name = name _x};
} forEach allPlayers;
private _text = {[_this] call DB_fnc_numberSafe};
private _net = 0;
private _changed = [];
{
    _x params ["_account", "_value", "_index"];
    if (!isNil "_value" && {_value isEqualType 0}) then {
        _value = round _value;
        private _delta = _value - (_wallet select _index);
        if !(_delta isEqualTo 0) then {
            _wallet set [_index, _value];
            _net = _net + _delta;
            _changed pushBack _account;
            [_uid, 0, _account, _delta, _value, "client_save", "", _source] call TON_fnc_moneyLog;
            if (_value < 0) then {
                diag_log format ["[ECONOMY] %1 (%2): %3 is negative (%4) after save (%5)", _name, _uid, _account, _value call _text, _source];
            };
        };
    };
} forEach [["cash", _cash, 0], ["bank", _bank, 1]];
//Warn on the net rise over both accounts, so moving money between cash and bank (ATM) stays quiet
private _warn = getNumber (missionConfigFile >> "CfgEconomy" >> (["shadowWarnCash", "shadowWarnBank"] select ("bank" in _changed)));
if (!(_changed isEqualTo []) && {_net >= _warn}) then {
    diag_log format ["[ECONOMY] %1 (%2): +%3 in one save (%4, %5), now cash %6, bank %7", _name, _uid, _net call _text, _source, _changed joinString "+", (_wallet select 0) call _text, (_wallet select 1) call _text];
};
