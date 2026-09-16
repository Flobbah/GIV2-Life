#include "\life_server\script_macros.hpp"
/*
    File: fn_wantedFetch.sqf
    Author: Bryan "Tonic" Boardwine"
    Database Persistence By: ColinM
    Assistance by: Paronity
    Stress Tests by: Midgetgrimm
    Description:
    Displays wanted list information sent from the server.
*/
private _ret = param [0,objNull,[objNull]];
if (isNull _ret) exitWith {};
//Sicherheitsphase 0.1: Fahndungsliste nur fuer Polizei
private _caller = CALLER_OWNER; //Sicherheitsphase 0.1: Absender pruefen
if !([_caller, _ret, "", sideUnknown, "life_fnc_wantedFetch"] call TON_fnc_checkCaller) exitWith {};
if (!(_caller isEqualTo 2) && {!((AUTH_SIDE(getPlayerUID _ret)) isEqualTo west)} && {[_caller, "life_fnc_wantedFetch", "sender is not a cop"] call TON_fnc_denyCaller}) exitWith {};
_ret = owner _ret;
private _inStatement = "";
private _list = [];
private _units = [];
{
    if ((AUTH_SIDE(getPlayerUID _x)) isEqualTo civilian) then {_units pushBack (getPlayerUID _x)};
    false
} count playableUnits;
if (count _units isEqualTo 0) exitWith {[_list] remoteExec ["life_fnc_wantedList",_ret];};
{
    if (count _units > 1) then {
        if (_inStatement isEqualTo "") then {
            _inStatement = "'" + _x + "'";
        } else {
            _inStatement = _inStatement + ", '" + _x + "'";
        };
    } else {
        _inStatement = _x;
    };
} forEach _units;
private _query = format ["SELECT wantedID, wantedName FROM wanted WHERE active='1' AND wantedID in (%1)",_inStatement];
private _queryResult = [_query,2,true] call DB_fnc_asyncCall;
if (EXTDB_SETTING(getNumber,"DebugMode") isEqualTo 1) then {
    diag_log format ["Query: %1",_query];
};
{
    _list pushBack _x;
    false
} count _queryResult;
if (count _list isEqualTo 0) exitWith {[_list] remoteExec ["life_fnc_wantedList",_ret];};
[_list] remoteExec ["life_fnc_wantedList",_ret];
