#include "..\..\script_macros.hpp"
/*
    File: fn_dutyMenu.sqf
    Description:
    Startet die Telefon-App "Dienst" (Dialog 3020): fragt die Freigaben beim Server ab
    (TON_fnc_dutyInfo -> life_fnc_dutyInfoReceive) und aktualisiert die Anzeige jede Sekunde,
    solange die App offen ist.
*/
disableSerialization;
waitUntil {!isNull (findDisplay 3020)};
life_duty_info = [];
[] call life_fnc_dutyUpdate;
[player] remoteExec ["TON_fnc_dutyInfo",RSERV];
while {!isNull (findDisplay 3020)} do {
    [] call life_fnc_dutyUpdate;
    sleep 1;
};
