#include "..\..\script_macros.hpp"
/*
    File: fn_adminManage.sqf
    Description:
    Dialog "Spieler verwalten" (idd 9930): Lizenzen erteilen/entziehen, Cop- und Medic-Rang setzen.
    Alle Aktionen gehen ueber den Server (TON_fnc_adminManageAction), der den Adminlevel des
    Aufrufers in der Datenbank prueft. Die Daten des Spielers kommen per TON_fnc_adminManageQuery
    und werden in fn_adminManageInfo eingetragen.
    Parameter 0 (Modus):
        -1 = Dialog initialisieren (onLoad)
         0 = gewaehlte Lizenz erteilen
         1 = gewaehlte Lizenz entziehen
         2 = Cop-Rang setzen (Adminlevel 4)
         3 = Medic-Rang setzen (Adminlevel 4)
         4 = Daten neu laden
*/
params [["_mode",-1,[0]]];
disableSerialization;
if (FETCH_CONST(life_adminlevel) < 3) exitWith {closeDialog 0; [ localize "STR_ANOTF_ErrorLevel",true,"fast"] call life_fnc_notification_system;};
private _display = findDisplay 9930;
if (isNull _display) exitWith {};
private _target = missionNamespace getVariable ["life_admin_target",objNull];
if (isNull _target || {!(_target in playableUnits)}) exitWith {closeDialog 0; [ localize "STR_ANOTF_NoTarget",true,"fast"] call life_fnc_notification_system;};
private _flag = switch (SIDE_OF(_target)) do {case west: {"cop"}; case civilian: {"civ"}; case independent: {"med"}; default {""};};
if (_flag isEqualTo "") exitWith {closeDialog 0; [ localize "STR_ANOTF_Error",true,"fast"] call life_fnc_notification_system;};
private _buttons = [9933,9934,9936,9938];
private _targetName = _target getVariable ["realname",name _target];

if (_mode in [-1,4]) exitWith {
    life_admin_manageUID = getPlayerUID _target;
    life_admin_manageFlag = _flag;
    (_display displayCtrl 9931) ctrlSetStructuredText parseText format ["<t size='0.9'>%1<br/>%2<br/>%3</t>",
        format [localize "STR_Admin_ManageInfo",_targetName,_flag],
        format [localize "STR_Admin_ManageUID",life_admin_manageUID],
        localize "STR_Admin_ManageLoading"];
    //Lizenzen der aktuellen Seite des Spielers (Status kommt vom Server)
    private _licCombo = _display displayCtrl 9932;
    lbClear _licCombo;
    {
        private _idx = _licCombo lbAdd (localize (getText (_x >> "displayName")));
        _licCombo lbSetData [_idx,configName _x];
    } forEach (format ["getText(_x >> 'side') isEqualTo '%1'",_flag] configClasses (missionConfigFile >> "Licenses"));
    //Raenge
    private _copCombo = _display displayCtrl 9935;
    lbClear _copCombo;
    for "_i" from 0 to 13 do {
        private _idx = _copCombo lbAdd str _i;
        _copCombo lbSetValue [_idx,_i];
    };
    private _medCombo = _display displayCtrl 9937;
    lbClear _medCombo;
    for "_i" from 0 to 8 do {
        private _idx = _medCombo lbAdd str _i;
        _medCombo lbSetValue [_idx,_i];
    };
    {(_display displayCtrl _x) ctrlEnable false;} forEach _buttons;
    [life_admin_manageUID,_flag] remoteExec ["TON_fnc_adminManageQuery",RSERV];
};

//Seite gewechselt seit dem Oeffnen? Dann passen Lizenzliste und Ziel nicht mehr.
if !(life_admin_manageFlag isEqualTo _flag) exitWith {[ localize "STR_ANOTF_ManageSideMismatch",true,"fast"] call life_fnc_notification_system; [4] call life_fnc_adminManage;};

if (_mode in [0,1]) then {
    private _sel = lbCurSel 9932;
    if (_sel isEqualTo -1) exitWith {[ localize "STR_ANOTF_ManageNoLicense",true,"fast"] call life_fnc_notification_system;};
    private _cls = lbData [9932,_sel];
    {(_display displayCtrl _x) ctrlEnable false;} forEach _buttons;
    [_target,"license",[_cls,_flag,_mode isEqualTo 0]] remoteExec ["TON_fnc_adminManageAction",RSERV];
};
if (_mode in [2,3]) then {
    if (FETCH_CONST(life_adminlevel) < 4) exitWith {[ localize "STR_ANOTF_ErrorLevel",true,"fast"] call life_fnc_notification_system;};
    private _idc = [9935,9937] select (_mode isEqualTo 3);
    private _sel = lbCurSel _idc;
    if (_sel isEqualTo -1) exitWith {};
    private _level = lbValue [_idc,_sel];
    private _action = ["coplevel","mediclevel"] select (_mode isEqualTo 3);
    private _rankName = localize (["STR_Admin_ManageCopRank","STR_Admin_ManageMedicRank"] select (_mode isEqualTo 3));
    private _ok = [
        format [localize "STR_ANOTF_ManageRankWarn",_targetName,_rankName,_level],
        localize "STR_Admin_Manage",
        localize "STR_Global_Yes",
        localize "STR_Global_No"
    ] call BIS_fnc_guiMessage;
    if (!_ok) exitWith {};
    {(_display displayCtrl _x) ctrlEnable false;} forEach _buttons;
    [_target,_action,[_level]] remoteExec ["TON_fnc_adminManageAction",RSERV];
};
