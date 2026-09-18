#include "\life_server\script_macros.hpp"
/*
    File: fn_dutySwitch.sqf
    Description:
    Fraktionswechsel im Spiel: prueft in der Datenbank, ob der Spieler die Zielfraktion spielen
    darf (Rang bzw. Adminlevel, Polizei-Sperre, Fahndung), und schickt ihm Lizenzen, Ausruestung,
    Rang, Fahrzeugschluessel sowie fuer Zivilisten Haeuser, Gang und Haftstatus
    (life_fnc_dutyReceive). Bei Ablehnung geht nur der Grund als Stringtable-Schluessel zurueck.
    Muss per remoteExec (nicht remoteExecCall) laufen, weil Haeuser und Gang gewartet werden.
    Parameter:
        0: OBJECT - der Spieler
        1: SIDE   - Zielfraktion west, civilian oder independent
*/
params [["_unit",objNull,[objNull]],["_side",sideUnknown,[civilian]]];
private _owner = remoteExecutedOwner;
if (isNull _unit || {!((owner _unit) isEqualTo _owner)}) exitWith {};
if !(_side in [west,civilian,independent]) exitWith {};
private _uid = getPlayerUID _unit;
if !(_uid regexMatch "\d{17}") exitWith {};
private _flag = switch (_side) do {case west: {"cop"}; case independent: {"med"}; default {"civ"};};
private _allowAdmin = (getNumber (missionConfigFile >> "CfgDuty" >> "allowAdmin")) isEqualTo 1;
private _query = format ["SELECT coplevel, mediclevel, adminlevel, blacklist, arrested, %1_licenses, %1_gear FROM players WHERE pid='%2'",_flag,_uid];
private _res = [_query,2] call DB_fnc_asyncCall;
if (count _res < 7) exitWith {
    diag_log format ["[DUTY] %1 (%2): keine Spielerdaten fuer %3", name _unit, _uid, _side];
    ["STR_DUTY_ErrServer"] remoteExec ["life_fnc_dutyReceive",_owner];
};
private _coplevel = parseNumber (str (_res select 0));
private _mediclevel = parseNumber (str (_res select 1));
private _adminlevel = parseNumber (str (_res select 2));
private _blacklist = [_res select 3,1] call DB_fnc_bool;
private _arrested = [_res select 4,1] call DB_fnc_bool;

//Berechtigung
private _deny = "";
switch (_side) do {
    case west: {
        if (_coplevel < 1 && {!_allowAdmin || {_adminlevel < 1}}) then {_deny = "STR_DUTY_ErrLevel";};
        if (_blacklist) then {_deny = "STR_DUTY_ErrBlacklist";};
    };
    case independent: {
        if (_mediclevel < 1 && {!_allowAdmin || {_adminlevel < 1}}) then {_deny = "STR_DUTY_ErrLevel";};
    };
};
if (_deny isEqualTo "" && {_side in [west,independent]}) then {
    private _wanted = [format ["SELECT wantedID FROM wanted WHERE wantedID='%1' AND active='1'",_uid],2] call DB_fnc_asyncCall;
    if ((count _wanted) > 0) then {_deny = "STR_DUTY_ErrWanted";};
};
if !(_deny isEqualTo "") exitWith {
    diag_log format ["[DUTY] %1 (%2) -> %3 abgelehnt: %4", name _unit, _uid, _side, _deny];
    [_deny] remoteExec ["life_fnc_dutyReceive",_owner];
};

//Lizenzen (wie in DB_fnc_queryRequest)
private _licenses = [_res select 5] call DB_fnc_mresToArray;
if (_licenses isEqualType "") then {_licenses = call compile format ["%1",_licenses];};
if !(_licenses isEqualType []) then {_licenses = [];};
private _clean = [];
{
    if (_x isEqualType [] && {count _x > 1}) then {
        _clean pushBack [_x select 0, [_x select 1,1] call DB_fnc_bool];
    };
} forEach _licenses;
//Ausruestung
private _gear = [_res select 6] call DB_fnc_mresToArray;
if (_gear isEqualType "") then {_gear = call compile format ["%1",_gear];};
if !(_gear isEqualType []) then {_gear = [];};
//Fahrzeugschluessel der Zielfraktion
private _keys = missionNamespace getVariable [format ["%1_KEYS_%2",_uid,_side],[]];
//Haeuser und Gang nur fuer Zivilisten
private _houses = [];
private _gang = [];
if (_side isEqualTo civilian) then {
    private _houseData = _uid spawn TON_fnc_fetchPlayerHouses;
    waitUntil {scriptDone _houseData};
    _houses = missionNamespace getVariable [format ["houses_%1",_uid],[]];
    private _gangData = _uid spawn TON_fnc_queryPlayerGang;
    waitUntil {scriptDone _gangData};
    _gang = missionNamespace getVariable [format ["gang_%1",_uid],[]];
};
[_uid, "side", _side] call TON_fnc_serverSet; //Sicherheitsphase 0.2: Fraktion fuer alle Serverpruefungen
[_uid, "coplevel", _coplevel] call TON_fnc_serverSet; //Gehalt nach Rang (TON_fnc_econPaycheck)
diag_log format ["[DUTY] %1 (%2) wechselt zu %3 (Cop %4, Medic %5)", name _unit, _uid, _side, _coplevel, _mediclevel];
//Inventar-Umbau: die Serverkopie gehoert jetzt zur Ausruestung der neuen Fraktion
[_uid, _gear] call TON_fnc_invLoad;
[_side,_clean,_gear,_coplevel,_mediclevel,_blacklist,_arrested,_keys,_houses,_gang] remoteExec ["life_fnc_dutyReceive",_owner];
