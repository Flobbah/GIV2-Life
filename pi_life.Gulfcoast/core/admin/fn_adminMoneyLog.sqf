#include "..\..\script_macros.hpp"
/*
    File: fn_adminMoneyLog.sqf
    Description:
    Transaction log in the admin menu (decision D3 in docs/ECONOMY_AUTHORITY.md). Asks the server for
    the last entries; the server checks the admin level in the database itself.
    Parameters:
        0: NUMBER - 0 = load (with the filter from the text field), -1 = open and load
*/
disableSerialization;
params [["_mode", -1, [0]]];
private _display = findDisplay 9940;
if (isNull _display) exitWith {};
private _list = _display displayCtrl 9941;
private _filter = ctrlText (_display displayCtrl 9942);
private _info = _display displayCtrl 9943;
_info ctrlSetText localize "STR_Admin_MoneyLoading";
lbClear _list;
["TON_fnc_adminMoneyQuery", [_filter, 100], {
    disableSerialization;
    private _display = findDisplay 9940;
    if (isNull _display) exitWith {};
    private _list = _display displayCtrl 9941;
    private _rows = (_this select 0) param [0, []];
    lbClear _list;
    {
        _x params [["_time", ""], ["_pid", ""], ["_gang", 0], ["_account", ""], ["_delta", 0], ["_balance", 0], ["_reason", ""], ["_counterpart", ""], ["_meta", ""]];
        //Was aus der Datenbank kommt, kann Text oder nichts sein - erst zu Zahlen machen, dann rechnen
        if (_delta isEqualType "") then {_delta = parseNumber _delta};
        if (_balance isEqualType "") then {_balance = parseNumber _balance};
        if !(_delta isEqualType 0) then {_delta = 0};
        if !(_balance isEqualType 0) then {_balance = 0};
        private _who = if (_account isEqualTo "gang") then {format ["Gang %1", _gang]} else {
            private _name = _pid;
            {if ((getPlayerUID _x) isEqualTo _pid) exitWith {_name = name _x}} forEach allPlayers;
            _name
        };
        //Aus "2026-09-18 23:40:12" wird "09-18 23:40"
        if !(_time isEqualType "") then {_time = str _time};
        private _line = format ["%1  %2  %3 %4$%5  (=%6)  %7 %8 %9",
            _time select [5, 11],
            _who,
            _account,
            ["-", "+"] select (_delta >= 0),
            [abs _delta] call life_fnc_numberText,
            [_balance] call life_fnc_numberText,
            _reason,
            _counterpart,
            _meta];
        _list lbAdd _line;
        private _color = if (_delta >= 0) then {[0.7, 1, 0.7, 1]} else {[1, 0.6, 0.6, 1]};
        _list lbSetColor [(lbSize _list) - 1, _color];
    } forEach _rows;
    (_display displayCtrl 9943) ctrlSetText format [localize "STR_Admin_MoneyRows", count _rows];
}, {
    disableSerialization;
    private _display = findDisplay 9940;
    if (isNull _display) exitWith {};
    (_display displayCtrl 9943) ctrlSetText localize "STR_Admin_MoneyDenied";
}] call life_fnc_econRequest;
