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
    private _clock = _display displayCtrl 2098;
    private _status = _display displayCtrl 2097;
    if (isNull _clock && {isNull _status}) exitWith {};
    private _last = sideUnknown;
    while {!isNull _display} do {
        if !(isNull _clock) then {
            _clock ctrlSetText ([daytime,"HH:MM"] call BIS_fnc_timeToString);
        };
        //Rechts stand frueher der Spielername - der steht auf der Startseite gleich darunter noch
        //einmal. Jetzt die Fraktion: die sieht man sonst nur in der Dienst-App, und sie aendert
        //sich im Spiel. Farbe wie die Dienst-Kachel, damit es auf einen Blick geht.
        if (!isNull _status && {!(life_side isEqualTo _last)}) then {
            _last = life_side;
            switch (life_side) do {
                case west: {
                    _status ctrlSetText localize "STR_PM_Status_Cop";
                    _status ctrlSetTextColor [0.45, 0.62, 0.95, 1];
                };
                case independent: {
                    _status ctrlSetText localize "STR_PM_Status_Med";
                    _status ctrlSetTextColor [0.35, 0.78, 0.72, 1];
                };
                default {
                    _status ctrlSetText localize "STR_PM_Status_Civ";
                    _status ctrlSetTextColor [0.85, 0.86, 0.90, 1];
                };
            };
        };
        sleep 5;
    };
};
