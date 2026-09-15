#include "\life_server\script_macros.hpp"
/*
    File: fn_adminManageQuery.sqf
    Description:
    Liest Cop-Rang, Medic-Rang und die Lizenzen einer Seite eines Spielers aus der Datenbank
    und schickt sie an den anfragenden Admin (life_fnc_adminManageInfo).
    Parameter:
        0: STRING - UID des Spielers
        1: STRING - Seite der Lizenzen: "civ", "cop" oder "med"
*/
params [["_uid","",[""]],["_flag","",[""]]];
private _owner = remoteExecutedOwner;
if !(_uid regexMatch "\d{17}") exitWith {};
if !(_flag in ["civ","cop","med"]) exitWith {};
private _admin = [_owner,3] call TON_fnc_adminManageAuth;
if (isNull _admin) exitWith {["STR_ANOTF_ManageDenied",[],true,false] remoteExec ["life_fnc_adminManageResult",_owner];};
private _query = format ["SELECT coplevel, mediclevel, %1_licenses FROM players WHERE pid='%2'",_flag,_uid];
private _res = [_query,2] call DB_fnc_asyncCall;
if (count _res < 3) exitWith {["STR_ANOTF_ManageOffline",[],true,false] remoteExec ["life_fnc_adminManageResult",_owner];};
private _licenses = [_res select 2] call DB_fnc_mresToArray;
if (_licenses isEqualType "") then {_licenses = call compile format ["%1",_licenses];};
if !(_licenses isEqualType []) then {_licenses = [];};
private _list = [];
{
    if (_x isEqualType [] && {count _x > 1}) then {
        _list pushBack [_x select 0,((_x select 1) isEqualTo 1) || {(_x select 1) isEqualTo true}];
    };
} forEach _licenses;
[_uid,parseNumber (str (_res select 0)),parseNumber (str (_res select 1)),_list] remoteExec ["life_fnc_adminManageInfo",_owner];
