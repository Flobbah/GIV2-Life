#include "\life_server\script_macros.hpp"
/*
    File: fn_adminManageAuth.sqf
    Description:
    Prueft serverseitig, ob der Aufrufer eines remoteExec (remoteExecutedOwner) ein Admin mit
    mindestens dem geforderten Level ist. Der Level wird aus der Datenbank gelesen, nicht vom
    Client uebernommen.
    Parameter:
        0: NUMBER - owner-ID des Aufrufers (remoteExecutedOwner)
        1: NUMBER - mindestens noetiger Adminlevel
    Rueckgabe:
        OBJECT - Einheit des Admins oder objNull
*/
params [["_owner",-1,[0]],["_minLevel",5,[0]]];
private _unit = objNull;
{
    if ((owner _x) isEqualTo _owner) exitWith {_unit = _x;};
} forEach playableUnits;
if (isNull _unit) exitWith {objNull};
private _uid = getPlayerUID _unit;
if !(_uid regexMatch "\d{17}") exitWith {objNull};
private _res = [format ["SELECT adminlevel FROM players WHERE pid='%1'",_uid],2] call DB_fnc_asyncCall;
if (count _res isEqualTo 0) exitWith {objNull};
private _level = parseNumber (str (_res select 0));
if (_level < _minLevel) exitWith {
    diag_log format ["[ADMIN MANAGE] Zugriff verweigert: %1 (%2) hat Adminlevel %3, noetig %4",name _unit,_uid,_level,_minLevel];
    objNull
};
_unit
