#include "\life_server\script_macros.hpp"
/*
    File: fn_adminMoneyQuery.sqf
    Description:
    Reads the transaction log for the admin view (decision D3 in docs/ECONOMY_AUTHORITY.md). The admin
    level comes from the database, not from the client, and must be at least
    CfgEconomy >> adminViewLevel. The filter is either a player uid, a gang id or a piece of a reason
    code; everything else is thrown away before it reaches the query.
    Parameters:
        0: NUMBER - request id
        1: STRING - filter ("" = the latest entries of everyone)
        2: NUMBER - how many rows, at most 200
    Answer data: [[time, who, account, delta, balance, reason, counterpart, meta], ...]
*/
private _owner = CALLER_OWNER;
params [["_id", -1, [0]], ["_filter", "", [""]], ["_limit", 50, [0]]];
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
    [_owner, "TON_fnc_adminMoneyQuery", format ["admin level %1 is below %2", _level, _needed]] call TON_fnc_denyCaller;
    [false, ["denied"]] call _answer;
};
_limit = (round _limit) max 1 min 200;
_filter = (_filter regexReplace ["[^A-Za-z0-9_]", ""]) select [0, 48];
private _where = "";
if !(_filter isEqualTo "") then {
    _where = switch (true) do {
        case (_filter regexMatch "\d{17}"): {format ["WHERE pid='%1' OR counterpart='%1'", _filter]};
        case (_filter regexMatch "\d{1,9}"): {format ["WHERE gang_id='%1'", _filter]};
        //Arma kennt in format kein %%, das Prozentzeichen kommt deshalb als Argument
        default {format ["WHERE reason LIKE '%1%2%1'", "%", _filter]};
    };
};
//Der Zeitstempel kommt als Text aus der Datenbank: extDB3 liefert TIMESTAMP sonst als Array, und
//dann ist eine einzelne Zeile nicht mehr von mehreren Zeilen zu unterscheiden.
private _rows = [format ["SELECT CAST(created_at AS CHAR) AS at, pid, gang_id, account, delta, balance_after, reason, counterpart, meta FROM money_transactions %1 ORDER BY id DESC LIMIT %2", _where, _limit], 2] call DB_fnc_asyncCall;
if !(_rows isEqualType []) exitWith {[false, ["denied"]] call _answer};
//Eine einzelne Zeile liefert extDB3 flach zurueck, also als neun Felder statt als eine Zeile
if (!(_rows isEqualTo []) && {!((_rows select 0) isEqualType [] && {count (_rows select 0) >= 9})}) then {_rows = [_rows]};
diag_log format ["[ADMIN MANAGE] %1 (%2) read the transaction log (filter '%3', %4 rows)", _name, _uid, _filter, count _rows];
[true, [_rows]] call _answer;
