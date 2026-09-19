#include "\life_server\script_macros.hpp"
/*
    File: fn_walletShadow.sqf
    Description:
    Compares the balances a client saves with the server-side wallet (docs/ECONOMY_AUTHORITY.md).
    Shadow mode (EconomyMode 1): the wallet follows the client and every difference is written to the
    transaction log as "client_save"; it is a money change the server did not make itself.
    Enforce mode (2): the client's values are ignored. A difference is either a flow the server does
    not book yet or manipulation; it is logged as "client_drift" (at most every
    CfgEconomy >> driftLogSeconds per player) and the client gets the server's balances back at once.
    Parameters:
        0: STRING - player uid
        1: NUMBER - saved cash (nil = not part of this save)
        2: NUMBER - saved bank (nil = not part of this save)
        3: STRING - source, e.g. "updatePartial 0"
*/
params [["_uid", "", [""]], "_cash", "_bank", ["_source", "", [""]]];
if (ECONOMY_MODE isEqualTo 0 || {!(_uid regexMatch "\d{17}")}) exitWith {};
private _enforce = ECONOMY_MODE >= 2;
private _wallets = localNamespace getVariable "life_econ_wallets";
if (isNil "_wallets") exitWith {};
private _wallet = [_uid] call TON_fnc_walletEnsure;
if (_wallet isEqualTo []) exitWith {
    if (_enforce) exitWith {
        diag_log format ["[ECONOMY] save from %1 without a wallet (%2), ignored", _uid, _source];
    };
    //Schattenmodus ohne Datenbankzeile: mit den gespeicherten Werten anfangen
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
private _drift = [];
{
    _x params ["_account", "_value", "_index"];
    if (!isNil "_value" && {_value isEqualType 0}) then {
        _value = round _value;
        private _delta = _value - (_wallet select _index);
        if !(_delta isEqualTo 0) then {
            if (_enforce) then {
                _drift pushBack [_account, _index, _delta, _value];
            } else {
                _wallet set [_index, _value];
                _net = _net + _delta;
                _changed pushBack _account;
                [_uid, 0, _account, _delta, _value, "client_save", "", _source] call TON_fnc_moneyLog;
                if (_value < 0) then {
                    diag_log format ["[ECONOMY] %1 (%2): %3 is negative (%4) after save (%5)", _name, _uid, _account, _value call _text, _source];
                };
            };
        };
    };
} forEach [["cash", _cash, 0], ["bank", _bank, 1]];
if (_enforce) exitWith {
    if (_drift isEqualTo []) exitWith {};
    //Der Client bekommt sofort die Werte des Servers zurueck
    [_uid] call TON_fnc_walletPush;
    //Hat der Server gerade erst gebucht (Kauf, Gehalt, Strafe), speichert der Client oft noch seinen
    //alten Stand, bevor der Push ankommt. Bis zur Hoehe des gerade Gebuchten ist das der Wettlauf und
    //kein Fund - still korrigieren. Alles darueber bleibt im Log, ein erfundener Betrag faellt also
    //nicht hinter einem Einkauf durch.
    private _recent = localNamespace getVariable ["life_econ_recent", createHashMap];
    (_recent getOrDefault [_uid, [-1e9, 0]]) params ["_since", "_sum"];
    if ((diag_tickTime - _since) <= (getNumber (missionConfigFile >> "CfgEconomy" >> "driftGraceSeconds"))) then {
        _drift = _drift select {abs (_x select 2) > _sum};
    };
    if (_drift isEqualTo []) exitWith {};
    private _store = localNamespace getVariable "life_econ_drift";
    if (isNil "_store") then {
        _store = createHashMap;
        localNamespace setVariable ["life_econ_drift", _store];
    };
    if ((diag_tickTime - (_store getOrDefault [_uid, -1e9])) < (getNumber (missionConfigFile >> "CfgEconomy" >> "driftLogSeconds"))) exitWith {};
    _store set [_uid, diag_tickTime];
    {
        _x params ["_account", "_index", "_delta", "_value"];
        [_uid, 0, _account, _delta, _wallet select _index, "client_drift", "", _source] call TON_fnc_moneyLog;
        diag_log format ["[ECONOMY] %1 (%2) saved %3 %4, the server has %5 (difference %6, %7); the client was corrected",
            _name, _uid, _account, _value call _text, (_wallet select _index) call _text, _delta call _text, _source];
    } forEach _drift;
};
//Warn on the net rise over both accounts, so moving money between cash and bank (ATM) stays quiet
private _warn = getNumber (missionConfigFile >> "CfgEconomy" >> (["shadowWarnCash", "shadowWarnBank"] select ("bank" in _changed)));
if (!(_changed isEqualTo []) && {_net >= _warn}) then {
    diag_log format ["[ECONOMY] %1 (%2): +%3 in one save (%4, %5), now cash %6, bank %7", _name, _uid, _net call _text, _source, _changed joinString "+", (_wallet select 0) call _text, (_wallet select 1) call _text];
};
