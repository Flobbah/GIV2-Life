#include "\life_server\script_macros.hpp"
/*
    File: fn_econReport.sqf
    Description:
    Wirtschaftsbericht aus dem Transaktionsprotokoll (docs/ECONOMY_AUTHORITY.md, Entscheidung D3).
    Zeigt, wo in einem Zeitraum Geld in die Wirtschaft kommt und wo es wieder verschwindet -
    die Grundlage fuer den Balance-Durchgang aus Phase 1 der Planung.

    Gerechnet wird in der Datenbank (GROUP BY), nicht im Spiel: es geht um Zehntausende Zeilen.
    Die Adminstufe kommt wie bei TON_fnc_adminMoneyQuery aus der Datenbank, nicht vom Client.

    Parameter:
        0: NUMBER - Anfrage-Nummer (life_fnc_econRequest)
        1: NUMBER - Zeitraum in Stunden (1 bis 720, Standard 24)
    Antwort:
        [_hours, _in, _out, _players, [[grund, anzahl, summe], ...]]
        _in  = Summe aller Gutschriften, _out = Summe aller Abbuchungen (negativ),
        _players = Zahl der beteiligten Spieler, Liste absteigend nach Summe.
*/
private _owner = CALLER_OWNER;
params [["_id", -1, [0]], ["_hours", 24, [0]]];
private _info = [_owner] call TON_fnc_callerInfo;
if (_info isEqualTo []) exitWith {};
_info params ["_uid", "_unit", "_side", "_name"];
private _answer = {
    params ["_ok", ["_data", []]];
    [_id, _ok, _data] remoteExecCall ["life_fnc_econReply", _owner];
};
private _needed = getNumber (missionConfigFile >> "CfgEconomy" >> "adminViewLevel");
private _res = [format ["SELECT adminlevel FROM players WHERE pid='%1'", _uid], 2] call DB_fnc_asyncCall;
private _level = _res param [0, 0];
if (_level isEqualType "") then {_level = parseNumber _level};
if (!(_level isEqualType 0) || {_level < _needed}) exitWith {
    [_owner, "TON_fnc_econReport", format ["admin level %1 is below %2", _level, _needed]] call TON_fnc_denyCaller;
    [false, ["denied"]] call _answer;
};
//_hours ist nach round/max/min eine Zahl zwischen 1 und 720 - der einzige Wert vom Client, der in
//die Abfrage geht (sql_audit.py meldet _since deshalb als "pruefen", hier steht das Ergebnis).
_hours = (round _hours) max 1 min 720;
private _since = format ["created_at > (NOW() - INTERVAL %1 HOUR)", _hours];

//Nach Grund gruppiert: was bringt Geld herein, was nimmt es heraus
private _rows = [format [
    "SELECT reason, COUNT(*) AS n, SUM(delta) AS total FROM money_transactions WHERE %1 GROUP BY reason ORDER BY total DESC LIMIT 60",
    _since], 2] call DB_fnc_asyncCall;
if !(_rows isEqualType []) exitWith {[false, ["denied"]] call _answer};
//Eine einzelne Zeile liefert extDB3 flach zurueck (siehe TON_fnc_adminMoneyQuery)
if (!(_rows isEqualTo []) && {!((_rows select 0) isEqualType [] && {count (_rows select 0) >= 3})}) then {_rows = [_rows]};

//Summen ueber alles: herein, heraus, beteiligte Spieler
private _sums = [format [
    "SELECT COALESCE(SUM(GREATEST(delta,0)),0), COALESCE(SUM(LEAST(delta,0)),0), COUNT(DISTINCT pid) FROM money_transactions WHERE %1",
    _since], 2] call DB_fnc_asyncCall;
if (!(_sums isEqualTo []) && {(_sums select 0) isEqualType []}) then {_sums = _sums select 0};
private _number = {
    params ["_v"];
    if (_v isEqualType "") then {_v = parseNumber _v};
    if !(_v isEqualType 0) then {0} else {_v}
};
private _in = [_sums param [0, 0]] call _number;
private _out = [_sums param [1, 0]] call _number;
private _players = [_sums param [2, 0]] call _number;

diag_log format ["[ADMIN MANAGE] %1 (%2) read the economy report (%3 h, %4 reasons)", _name, _uid, _hours, count _rows];
[true, [[_hours, _in, _out, _players, _rows]]] call _answer;
