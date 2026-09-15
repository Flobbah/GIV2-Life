/*
    File: fn_phoneStatus.sqf
    Description:
    Fuellt die Statusleiste eines Telefon-Dialogs (Uhrzeit links, Spielername rechts)
    und haelt die Uhrzeit aktuell, solange der Dialog offen ist.
    Wird aus dem onLoad der Telefon-Dialoge mit [_this select 0] aufgerufen.

    Parameter:
        0: DISPLAY - der geoeffnete Dialog
*/
params [["_display",displayNull,[displayNull]]];
if (isNull _display) exitWith {};
[_display] spawn {
    params ["_display"];
    disableSerialization;
    private _name = _display displayCtrl 2097;
    if (!isNull _name) then {
        _name ctrlSetText (player getVariable ["realname",name player]);
    };
    private _clock = _display displayCtrl 2098;
    if (isNull _clock) exitWith {};
    while {!isNull _display} do {
        _clock ctrlSetText ([daytime,"HH:MM"] call BIS_fnc_timeToString);
        sleep 10;
    };
};
