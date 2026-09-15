#include "..\..\script_macros.hpp"
/*
    File: fn_adminLicenseReceive.sqf
    Description:
    Wird vom Server (TON_fnc_adminManageAction) auf dem Zielspieler ausgefuehrt:
    setzt eine Lizenz der aktuellen Seite und speichert sie in der Datenbank.
    Parameter:
        0: STRING - Variablenname der Lizenz (license_<seite>_<name>)
        1: BOOL   - true = erteilen, false = entziehen
        2: STRING - Name des Admins
        3: STRING - Stringtable-Schluessel des Lizenznamens
*/
params [["_var","",[""]],["_grant",true,[true]],["_admin","",[""]],["_displayName","",[""]]];
if !(remoteExecutedOwner isEqualTo 2) exitWith {};
private _flag = switch (life_side) do {case west: {"cop"}; case civilian: {"civ"}; case independent: {"med"}; default {""};};
if (_flag isEqualTo "") exitWith {};
//Nur Lizenzvariablen der eigenen Seite akzeptieren
if !((_var find format ["license_%1_",_flag]) isEqualTo 0) exitWith {};
missionNamespace setVariable [_var,_grant];
[2] call SOCK_fnc_updatePartial;
if (isLocalized _displayName) then {_displayName = localize _displayName;};
[ format [localize (["STR_ANOTF_LicenseRevoked","STR_ANOTF_LicenseGranted"] select _grant),_admin,_displayName],!_grant,"fast"] call life_fnc_notification_system;
