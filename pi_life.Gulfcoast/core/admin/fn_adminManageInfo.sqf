#include "..\..\script_macros.hpp"
/*
    File: fn_adminManageInfo.sqf
    Description:
    Antwort des Servers (TON_fnc_adminManageQuery) auf die Datenabfrage im Dialog "Spieler verwalten".
    Parameter:
        0: STRING - UID des Spielers
        1: NUMBER - Cop-Rang
        2: NUMBER - Medic-Rang
        3: ARRAY  - Lizenzen der Seite als [[Variablenname,BOOL],...]
*/
params [["_uid","",[""]],["_copLevel",0,[0]],["_medLevel",0,[0]],["_licenses",[],[[]]]];
if !(remoteExecutedOwner isEqualTo 2) exitWith {};
disableSerialization;
private _display = findDisplay 9930;
if (isNull _display) exitWith {};
if !(_uid isEqualTo (missionNamespace getVariable ["life_admin_manageUID",""])) exitWith {};
private _flag = missionNamespace getVariable ["life_admin_manageFlag","civ"];
private _target = missionNamespace getVariable ["life_admin_target",objNull];
private _targetName = if (isNull _target) then {"-"} else {_target getVariable ["realname",name _target]};
(_display displayCtrl 9931) ctrlSetStructuredText parseText format ["<t size='0.9'>%1<br/>%2<br/>%3</t>",
    format [localize "STR_Admin_ManageInfo",_targetName,_flag],
    format [localize "STR_Admin_ManageUID",_uid],
    format [localize "STR_Admin_ManageRanks",_copLevel,_medLevel]];
//Lizenzliste mit Status neu aufbauen, Auswahl beibehalten
private _licCombo = _display displayCtrl 9932;
private _keep = lbCurSel _licCombo;
lbClear _licCombo;
{
    private _cls = configName _x;
    private _var = LICENSE_VARNAME(_cls,_flag);
    private _has = false;
    {
        if ((_x select 0) isEqualTo _var) exitWith {_has = (_x select 1) isEqualTo true || {(_x select 1) isEqualTo 1}};
    } forEach _licenses;
    private _idx = _licCombo lbAdd format ["%1 (%2)",localize (getText (_x >> "displayName")),localize (["STR_Admin_ManageMissing","STR_Admin_ManageHas"] select _has)];
    _licCombo lbSetData [_idx,_cls];
    _licCombo lbSetColor [_idx,[[1,0.55,0.55,1],[0.55,1,0.55,1]] select _has];
} forEach (format ["getText(_x >> 'side') isEqualTo '%1'",_flag] configClasses (missionConfigFile >> "Licenses"));
if (_keep >= 0 && {_keep < lbSize _licCombo}) then {_licCombo lbSetCurSel _keep;};
//Aktuelle Raenge vorauswaehlen
(_display displayCtrl 9935) lbSetCurSel ((_copLevel max 0) min 13);
(_display displayCtrl 9937) lbSetCurSel ((_medLevel max 0) min 8);
//Buttons freigeben (Raenge erst ab Adminlevel 4)
private _rankAllowed = FETCH_CONST(life_adminlevel) >= 4;
(_display displayCtrl 9933) ctrlEnable true;
(_display displayCtrl 9934) ctrlEnable true;
(_display displayCtrl 9936) ctrlEnable _rankAllowed;
(_display displayCtrl 9938) ctrlEnable _rankAllowed;
