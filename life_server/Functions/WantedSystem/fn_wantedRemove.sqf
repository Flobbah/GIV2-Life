#include "\life_server\script_macros.hpp"
/*
    File: fn_wantedRemove.sqf
    Author: Bryan "Tonic" Boardwine"
    Database Persistence By: ColinM
    Assistance by: Paronity
    Stress Tests by: Midgetgrimm
    Description:
    Removes a person from the wanted list.
*/
private _uid = param [0,"",[""]];
if (_uid isEqualTo "") exitWith {}; //Bad data
//Sicherheitsphase 0.1: eigene Fahndung (Haft, Strafzettel, Tod) oder Polizei (Begnadigung)
if !(_uid regexMatch "\d{17}") exitWith {};
private _caller = CALLER_OWNER;
private _deny = "";
if !(_caller isEqualTo 2) then {
    private _info = [_caller] call TON_fnc_callerInfo;
    if (_info isEqualTo []) then {_deny = "unknown sender";} else {
        if (!((_info select 0) isEqualTo _uid) && {!((_info select 2) isEqualTo west)}) then {_deny = "only cops may clear another player's wanted entry";};
    };
};
if (!(_deny isEqualTo "") && {[_caller, "life_fnc_wantedRemove", _deny] call TON_fnc_denyCaller}) exitWith {};
private _query = format ["UPDATE wanted SET active = '0', wantedCrimes = '[]', wantedBounty = 0 WHERE wantedID='%1'",_uid];
[_query,2] call DB_fnc_asyncCall;