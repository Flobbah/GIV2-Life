#include "..\..\script_macros.hpp"
/*
    File: fn_adminRankReceive.sqf
    Description:
    Wird vom Server (TON_fnc_adminManageAction) auf dem Zielspieler ausgefuehrt, nachdem der
    Rang in der Datenbank gesetzt wurde. Aktualisiert den Rang sofort fuer Shops und Menues;
    Gehalt und Startausruestung greifen erst nach dem naechsten Login.
    Parameter:
        0: STRING - "coplevel" oder "mediclevel"
        1: NUMBER - neuer Rang
        2: STRING - Name des Admins
*/
params [["_which","",[""]],["_level",0,[0]],["_admin","",[""]]];
if !(remoteExecutedOwner isEqualTo 2) exitWith {};
if !(_which in ["coplevel","mediclevel"]) exitWith {};
_level = round _level;
if (_which isEqualTo "coplevel" && {life_side isEqualTo west}) then {
    CONST_MUTABLE(life_coplevel,_level);
};
if (_which isEqualTo "mediclevel" && {life_side isEqualTo independent}) then {
    CONST_MUTABLE(life_medicLevel,_level);
};
private _rankName = localize (["STR_Admin_ManageCopRank","STR_Admin_ManageMedicRank"] select (_which isEqualTo "mediclevel"));
[ format [localize "STR_ANOTF_RankSet",_admin,_rankName,_level],false,""] call life_fnc_notification_system;
