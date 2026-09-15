#include "..\..\script_macros.hpp"
/*
    File: fn_adminManageResult.sqf
    Description:
    Rueckmeldung des Servers an den Admin nach einer Aktion im Dialog "Spieler verwalten".
    Parameter:
        0: STRING - Stringtable-Schluessel
        1: ARRAY  - Parameter fuer format (max. 3)
        2: BOOL   - true = Fehler (rot)
        3: BOOL   - true = Dialogdaten neu laden
*/
params [["_key","",[""]],["_params",[],[[]]],["_error",false,[false]],["_refresh",false,[false]]];
if !(remoteExecutedOwner isEqualTo 2) exitWith {};
if (_key isEqualTo "") exitWith {};
//Parameter, die Stringtable-Schluessel sind, hier uebersetzen (der Server schickt nur Schluessel)
_params = _params apply {if (_x isEqualType "" && {isLocalized _x}) then {localize _x} else {_x}};
private _text = format ([localize _key] + _params);
[_text,_error,"fast"] call life_fnc_notification_system;
if (isNull (findDisplay 9930)) exitWith {};
if (_refresh) then {
    //Datenbank-Update laeuft asynchron, kurz warten bevor neu gelesen wird
    [] spawn {
        sleep 1;
        if (!isNull (findDisplay 9930)) then {[4] call life_fnc_adminManage;};
    };
} else {
    {ctrlEnable [_x,true];} forEach [9933,9934];
    private _rankAllowed = FETCH_CONST(life_adminlevel) >= 4;
    {ctrlEnable [_x,_rankAllowed];} forEach [9936,9938];
};
