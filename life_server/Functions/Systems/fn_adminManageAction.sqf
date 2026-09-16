#include "\life_server\script_macros.hpp"
/*
    File: fn_adminManageAction.sqf
    Description:
    Fuehrt eine Aktion aus dem Dialog "Spieler verwalten" aus, nachdem der Adminlevel des
    Aufrufers in der Datenbank geprueft wurde. Texte werden als Stringtable-Schluessel
    verschickt und erst auf dem Client uebersetzt.
    Parameter:
        0: OBJECT - Zielspieler
        1: STRING - "license" | "coplevel" | "mediclevel"
        2: ARRAY  - license: [Lizenzklasse, Seite, BOOL erteilen]; Raenge: [Level]
*/
params [["_target",objNull,[objNull]],["_action","",[""]],["_data",[],[[]]]];
private _owner = remoteExecutedOwner;
if !(_action in ["license","coplevel","mediclevel"]) exitWith {};
private _minLevel = [4,3] select (_action isEqualTo "license");
private _admin = [_owner,_minLevel] call TON_fnc_adminManageAuth;
if (isNull _admin) exitWith {["STR_ANOTF_ManageDenied",[],true,false] remoteExec ["life_fnc_adminManageResult",_owner];};
if (isNull _target || {!(_target in playableUnits)}) exitWith {["STR_ANOTF_ManageOffline",[],true,false] remoteExec ["life_fnc_adminManageResult",_owner];};
private _uid = getPlayerUID _target;
if !(_uid regexMatch "\d{17}") exitWith {};
private _adminName = _admin getVariable ["realname",name _admin];
private _targetName = _target getVariable ["realname",name _target];
private _targetFlag = switch (AUTH_SIDE(_uid)) do {case west: {"cop"}; case civilian: {"civ"}; case independent: {"med"}; default {""};};

if (_action isEqualTo "license") exitWith {
    _data params [["_cls","",[""]],["_flag","",[""]],["_grant",true,[true]]];
    if !(isClass (missionConfigFile >> "Licenses" >> _cls)) exitWith {};
    if !(_flag isEqualTo _targetFlag) exitWith {["STR_ANOTF_ManageSideMismatch",[],true,true] remoteExec ["life_fnc_adminManageResult",_owner];};
    private _var = LICENSE_VARNAME(_cls,_flag);
    private _nameKey = getText (missionConfigFile >> "Licenses" >> _cls >> "displayName");
    private _stateKey = ["STR_ANOTF_ManageRevoked","STR_ANOTF_ManageGranted"] select _grant;
    [_var,_grant,_adminName,_nameKey] remoteExec ["life_fnc_adminLicenseReceive",_target];
    diag_log format ["[ADMIN MANAGE] %1 (%2) -> %3 (%4): Lizenz %5 %6",_adminName,getPlayerUID _admin,_targetName,_uid,_var,["entzogen","erteilt"] select _grant];
    ["STR_ANOTF_ManageLicenseDone",[_targetName,_nameKey,_stateKey],false,true] remoteExec ["life_fnc_adminManageResult",_owner];
};

//Raenge: coplevel 0-13, mediclevel 0-8 (ENUM-Spalten in der Tabelle players)
_data params [["_level",0,[0]]];
_level = round _level;
private _max = [13,8] select (_action isEqualTo "mediclevel");
if (_level < 0 || {_level > _max}) exitWith {};
[format ["UPDATE players SET %1='%2' WHERE pid='%3'",_action,_level,_uid],1] call DB_fnc_asyncCall;
if (_action isEqualTo "coplevel") then {[_uid, "coplevel", _level] call TON_fnc_serverSet}; //Gehalt nach Rang
[_action,_level,_adminName] remoteExec ["life_fnc_adminRankReceive",_target];
diag_log format ["[ADMIN MANAGE] %1 (%2) -> %3 (%4): %5 = %6",_adminName,getPlayerUID _admin,_targetName,_uid,_action,_level];
private _rankKey = ["STR_Admin_ManageCopRank","STR_Admin_ManageMedicRank"] select (_action isEqualTo "mediclevel");
["STR_ANOTF_ManageRankDone",[_targetName,_rankKey,_level],false,true] remoteExec ["life_fnc_adminManageResult",_owner];
