#include "..\..\script_macros.hpp"
/*
    File: fn_adminEconReport.sqf
    Description:
    Wirtschaftsbericht im Admin-Menue: wo kommt Geld in die Wirtschaft, wo verschwindet es wieder.
    Der Server rechnet das in der Datenbank zusammen (TON_fnc_econReport), hier wird es nur
    angezeigt. Grundlage fuer den Balance-Durchgang aus Phase 1 (docs/ROADMAP.md).

    Der Zeitraum steht im Filterfeld: eine Zahl in Stunden, leer bedeutet 24.
*/
disableSerialization;
private _display = findDisplay 9940;
if (isNull _display) exitWith {};
private _list = _display displayCtrl 9941;
private _info = _display displayCtrl 9943;
private _text = ctrlText (_display displayCtrl 9942);
private _hours = parseNumber _text;
if (_hours <= 0) then {_hours = 24};
lbClear _list;
_info ctrlSetStructuredText parseText localize "STR_Admin_MoneyLoading";
["TON_fnc_econReport", [_hours], {
    disableSerialization;
    private _display = findDisplay 9940;
    if (isNull _display) exitWith {};
    private _list = _display displayCtrl 9941;
    ((_this select 0) param [0, []]) params [["_hours", 24], ["_in", 0], ["_out", 0], ["_players", 0], ["_rows", []]];
    private _num = {
        params ["_v"];
        if (_v isEqualType "") then {_v = parseNumber _v};
        if !(_v isEqualType 0) then {0} else {_v}
    };
    _in = [_in] call _num;
    _out = [_out] call _num;
    lbClear _list;
    //Kopfzeile: was herein kam, was heraus ging, und was unterm Strich neu entstanden ist
    _list lbAdd format [localize "STR_Admin_ReportHead",
        _hours,
        [_in] call life_fnc_numberText,
        [abs _out] call life_fnc_numberText,
        [_in + _out] call life_fnc_numberText,
        [_players] call _num];
    _list lbSetColor [(lbSize _list) - 1, [0.85, 0.87, 0.92, 1]];
    {
        _x params [["_reason", ""], ["_count", 0], ["_total", 0]];
        _count = [_count] call _num;
        _total = [_total] call _num;
        private _line = format ["%1   %2x   %3$%4   (%5 $/h)",
            _reason,
            _count,
            ["-", "+"] select (_total >= 0),
            [abs _total] call life_fnc_numberText,
            [round (_total / _hours)] call life_fnc_numberText];
        _list lbAdd _line;
        private _color = if (_total >= 0) then {[0.62, 0.84, 0.64, 1]} else {[0.95, 0.65, 0.65, 1]};
        _list lbSetColor [(lbSize _list) - 1, _color];
    } forEach _rows;
    (_display displayCtrl 9943) ctrlSetStructuredText parseText format [localize "STR_Admin_ReportRows", count _rows, _hours];
}, {
    disableSerialization;
    private _display = findDisplay 9940;
    if (isNull _display) exitWith {};
    (_display displayCtrl 9943) ctrlSetStructuredText parseText localize "STR_Admin_MoneyDenied";
}] call life_fnc_econRequest;
