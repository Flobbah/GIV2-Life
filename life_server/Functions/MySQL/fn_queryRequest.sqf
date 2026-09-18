#include "\life_server\script_macros.hpp"
/*
    File: fn_queryRequest.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Handles the incoming request and sends an asynchronous query
    request to the database.
    Return:
    ARRAY - If array has 0 elements it should be handled as an error in client-side files.
    STRING - The request had invalid handles or an unknown error and is logged to the RPT.
*/
private ["_uid","_side","_query","_queryResult","_tickTime","_tmp"];
_uid = [_this,0,"",[""]] call BIS_fnc_param;
_side = [_this,1,sideUnknown,[civilian]] call BIS_fnc_param;
_ownerID = [_this,2,objNull,[objNull]] call BIS_fnc_param;
if (isNull _ownerID) exitWith {};
//Sicherheitsphase 0.1: nur die eigenen Daten der eigenen Fraktion
if !([CALLER_OWNER, _ownerID, _uid, _side, "DB_fnc_queryRequest"] call TON_fnc_checkCaller) exitWith {};
if !(_side in [west, civilian, independent]) exitWith {};
if (LIFE_SETTINGS(getNumber,"player_deathLog") isEqualTo 1) then {
    _ownerID addMPEventHandler ["MPKilled", {_this call fn_whoDoneIt}];
};
_ownerID = owner _ownerID;
_query = switch (_side) do {
    // West - 11 entries returned
    case west: {format ["SELECT pid, name, cash, bankacc, adminlevel, donorlevel, cop_licenses, coplevel, cop_gear, blacklist, cop_stats, playtime FROM players WHERE pid='%1'",_uid];};
    // Civilian - 12 entries returned
    case civilian: {format ["SELECT pid, name, cash, bankacc, adminlevel, donorlevel, civ_licenses, arrested, civ_gear, civ_stats, civ_alive, civ_position, playtime FROM players WHERE pid='%1'",_uid];};
    // Independent - 10 entries returned
    case independent: {format ["SELECT pid, name, cash, bankacc, adminlevel, donorlevel, med_licenses, mediclevel, med_gear, med_stats, playtime FROM players WHERE pid='%1'",_uid];};
};
_tickTime = diag_tickTime;
_queryResult = [_query,2] call DB_fnc_asyncCall;
if (EXTDB_SETTING(getNumber,"DebugMode") isEqualTo 1) then {
    diag_log "------------- Client Query Request -------------";
    diag_log format ["QUERY: %1",_query];
    diag_log format ["Time to complete: %1 (in seconds)",(diag_tickTime - _tickTime)];
    diag_log format ["Result: %1",_queryResult];
    diag_log "------------------------------------------------";
};
if (_queryResult isEqualType "") exitWith {
    [] remoteExecCall ["SOCK_fnc_insertPlayerInfo",_ownerID];
};
if (count _queryResult isEqualTo 0) exitWith {
    [] remoteExecCall ["SOCK_fnc_insertPlayerInfo",_ownerID];
};
//Sicherheitsphase 0.2: Fraktion serverseitig festhalten. Polizei und Rettungsdienst nur mit Rang oder Adminlevel,
//Polizei nicht bei Sperre (wie fn_initCop/fn_initMedic); sonst behandelt der Server den Spieler als Zivilisten
private _toNumber = {if (_this isEqualType 0) then {_this} else {if (_this isEqualType "") then {parseNumber _this} else {0}}};
private _authSide = _side;
switch (_side) do {
    case west: {
        if ((((_queryResult select 7) call _toNumber) < 1 && {((_queryResult select 4) call _toNumber) < 1}) || {[_queryResult select 9,1] call DB_fnc_bool}) then {_authSide = civilian;};
    };
    case independent: {
        if (((_queryResult select 7) call _toNumber) < 1 && {((_queryResult select 4) call _toNumber) < 1}) then {_authSide = civilian;};
    };
};
if !(_authSide isEqualTo _side) then {
    diag_log format ["[SECURITY] DB_fnc_queryRequest: %1 (%2) logged in as %3 without rank or while blacklisted, the server treats the player as civilian", name (_this select 2), _uid, _side];
};
[_uid, "side", _authSide] call TON_fnc_serverSet;
[_uid, _queryResult select 2, _queryResult select 3] call TON_fnc_walletLoad; //Geld-Umbau Schritt 1
if (_authSide isEqualTo west) then {[_uid, "coplevel", (_queryResult select 7) call _toNumber] call TON_fnc_serverSet}; //Gehalt nach Rang (TON_fnc_econPaycheck)
//Blah conversion thing from a2net->extdb
_tmp = _queryResult select 2;
_queryResult set[2,[_tmp] call DB_fnc_numberSafe];
_tmp = _queryResult select 3;
_queryResult set[3,[_tmp] call DB_fnc_numberSafe];
//Parse licenses (Always index 6)
_new = [(_queryResult select 6)] call DB_fnc_mresToArray;
if (_new isEqualType "") then {_new = call compile format ["%1", _new];};
_queryResult set[6,_new];
//Convert tinyint to boolean
_old = _queryResult select 6;
for "_i" from 0 to (count _old)-1 do {
    _data = _old select _i;
    _old set[_i,[_data select 0, ([_data select 1,1] call DB_fnc_bool)]];
};
_queryResult set[6,_old];
_new = [(_queryResult select 8)] call DB_fnc_mresToArray;
if (_new isEqualType "") then {_new = call compile format ["%1", _new];};
_queryResult set[8,_new];
[_uid, _new] call TON_fnc_invLoad; //Inventar-Umbau: gespeicherte Gegenstaende in die Serverkopie
//Parse data for specific side.
switch (_side) do {
    case west: {
        _queryResult set[9,([_queryResult select 9,1] call DB_fnc_bool)];
        //Parse Stats
        _new = [(_queryResult select 10)] call DB_fnc_mresToArray;
        if (_new isEqualType "") then {_new = call compile format ["%1", _new];};
        _queryResult set[10,_new];
        //Playtime
        _new = [(_queryResult select 11)] call DB_fnc_mresToArray;
        if (_new isEqualType "") then {_new = call compile format ["%1", _new];};
        //Sicherheitsphase 0.2 Welle 2: Spielzeiten bleiben auf dem Server
        private _ptRequest = localNamespace getVariable ["TON_fnc_playtime_values_request", []];
        _index = _ptRequest find [_uid, _new];
        if (_index != -1) then {_ptRequest deleteAt _index};
        _ptRequest pushBack [_uid, _new];
        localNamespace setVariable ["TON_fnc_playtime_values_request", _ptRequest];
        [_uid,_new select 0] call TON_fnc_setPlayTime;
    };
    case civilian: {
        _queryResult set[7,([_queryResult select 7,1] call DB_fnc_bool)];
        //Parse Stats
        _new = [(_queryResult select 9)] call DB_fnc_mresToArray;
        if (_new isEqualType "") then {_new = call compile format ["%1", _new];};
        _queryResult set[9,_new];
        //Position
        _queryResult set[10,([_queryResult select 10,1] call DB_fnc_bool)];
        _new = [(_queryResult select 11)] call DB_fnc_mresToArray;
        if (_new isEqualType "") then {_new = call compile format ["%1", _new];};
        _queryResult set[11,_new];
        //Playtime
        _new = [(_queryResult select 12)] call DB_fnc_mresToArray;
        if (_new isEqualType "") then {_new = call compile format ["%1", _new];};
        //Sicherheitsphase 0.2 Welle 2: Spielzeiten bleiben auf dem Server
        private _ptRequest = localNamespace getVariable ["TON_fnc_playtime_values_request", []];
        _index = _ptRequest find [_uid, _new];
        if (_index != -1) then {_ptRequest deleteAt _index};
        _ptRequest pushBack [_uid, _new];
        localNamespace setVariable ["TON_fnc_playtime_values_request", _ptRequest];
        [_uid,_new select 2] call TON_fnc_setPlayTime;
        /* Make sure nothing else is added under here */
        _houseData = _uid spawn TON_fnc_fetchPlayerHouses;
        waitUntil {scriptDone _houseData};
        _queryResult pushBack (missionNamespace getVariable [format ["houses_%1",_uid],[]]);
        _gangData = _uid spawn TON_fnc_queryPlayerGang;
        waitUntil{scriptDone _gangData};
        _queryResult pushBack (missionNamespace getVariable [format ["gang_%1",_uid],[]]);
    };
    case independent: {
        //Parse Stats
        _new = [(_queryResult select 9)] call DB_fnc_mresToArray;
        if (_new isEqualType "") then {_new = call compile format ["%1", _new];};
        _queryResult set[9,_new];
        //Playtime
        _new = [(_queryResult select 10)] call DB_fnc_mresToArray;
        if (_new isEqualType "") then {_new = call compile format ["%1", _new];};
        //Sicherheitsphase 0.2 Welle 2: Spielzeiten bleiben auf dem Server
        private _ptRequest = localNamespace getVariable ["TON_fnc_playtime_values_request", []];
        _index = _ptRequest find [_uid, _new];
        if !(_index isEqualTo -1) then {_ptRequest deleteAt _index};
        _ptRequest pushBack [_uid, _new];
        localNamespace setVariable ["TON_fnc_playtime_values_request", _ptRequest];
        [_uid,_new select 1] call TON_fnc_setPlayTime;
    };
};
_keyArr = missionNamespace getVariable [format ["%1_KEYS_%2",_uid,_side],[]];
_queryResult pushBack _keyArr;
_queryResult remoteExec ["SOCK_fnc_requestReceived",_ownerID];
