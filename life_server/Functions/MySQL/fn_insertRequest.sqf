#include "\life_server\script_macros.hpp"
/*
    File: fn_insertRequest.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Adds a player to the database upon first joining of the server.
    Recieves information from core\sesison\fn_insertPlayerInfo.sqf
*/
private ["_queryResult","_query","_alias"];
params [
    "_uid",
    "_name",
    ["_money",-1,[0]],
    ["_bank",-1,[0]],
    ["_returnToSender",objNull,[objNull]]
];
//Error checks
if ((_uid isEqualTo "") || (_name isEqualTo "")) exitWith {systemChat "Bad UID or name";}; //Let the client be 'lost' in 'transaction'
if (isNull _returnToSender) exitWith {systemChat "ReturnToSender is Null!";}; //No one to send this to!
//Sicherheitsphase 0.1: nur der eigene Eintrag; Startgeld bestimmt der Server, nicht der Client
if !([CALLER_OWNER, _returnToSender, _uid, sideUnknown, "DB_fnc_insertRequest"] call TON_fnc_checkCaller) exitWith {};
private _startSide = AUTH_SIDE(_uid); //Sicherheitsphase 0.2: neue Spieler sind vor der ersten Abfrage unbekannt -> Zivilist
private _bankKey = switch (_startSide) do {case west: {"bank_cop"}; case independent: {"bank_med"}; default {"bank_civ"};};
_money = 0;
_bank = LIFE_SETTINGS(getNumber,_bankKey);
_query = format ["SELECT pid, name FROM players WHERE pid='%1'",_uid];
_tickTime = diag_tickTime;
_queryResult = [_query,2] call DB_fnc_asyncCall;
if (EXTDB_SETTING(getNumber,"DebugMode") isEqualTo 1) then {
    diag_log "------------- Insert Query Request -------------";
    diag_log format ["QUERY: %1",_query];
    diag_log format ["Time to complete: %1 (in seconds)",(diag_tickTime - _tickTime)];
    diag_log format ["Result: %1",_queryResult];
    diag_log "------------------------------------------------";
};
//Double check to make sure the client isn't in the database...
if (_queryResult isEqualType "") exitWith {[] remoteExecCall ["SOCK_fnc_dataQuery",(owner _returnToSender)];}; //There was an entry!
if !(count _queryResult isEqualTo 0) exitWith {[] remoteExecCall ["SOCK_fnc_dataQuery",(owner _returnToSender)];};
//Clense and prepare some information.
_name = [_name] call DB_fnc_mresString; //Clense the name of bad chars.
_alias = [[_name]] call DB_fnc_mresArray;
_money = [_money] call DB_fnc_numberSafe;
_bank = [_bank] call DB_fnc_numberSafe;
//Prepare the query statement..
_query = format ["INSERT INTO players (pid, name, cash, bankacc, aliases, cop_licenses, med_licenses, civ_licenses, civ_gear, cop_gear, med_gear) VALUES('%1', '%2', '%3', '%4', '%5','""[]""','""[]""','""[]""','""[]""','""[]""','""[]""')",
    _uid,
    _name,
    _money,
    _bank,
    _alias
];
[_query,1] call DB_fnc_asyncCall;
[] remoteExecCall ["SOCK_fnc_dataQuery",(owner _returnToSender)];
