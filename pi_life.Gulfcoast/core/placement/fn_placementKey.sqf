#include "..\..\script_macros.hpp"
/*
    File: fn_placementKey.sqf
    Description:
    Tastatur waehrend des Abstellens, aufgerufen ganz am Anfang von life_fnc_keyHandler.
    Q/E drehen (mit Umschalt fein), Enter/Nummernblock-Enter/Leertaste stellen ab,
    Ruecktaste/Esc brechen ab. Alle anderen Tasten gehen an das Spiel (Laufen, Umsehen),
    die Hotkeys des Frameworks (Telefon, Kofferraum, Schloss ...) sind so lange gesperrt.
    Parameter: wie KeyDown [Display, Tastencode, Umschalt, Strg, Alt]
    Rueckgabe: BOOL - true, wenn die Taste verbraucht wurde
*/
params ["_display", "_code", ["_shift", false], ["_ctrlKey", false], ["_alt", false]];
if (!life_placement_active) exitWith {false};
private _step = getNumber (missionConfigFile >> "CfgVehiclePlacement" >> (["rotateStep", "rotateStepFine"] select _shift));
switch (true) do {
    case (_code isEqualTo 16): {
        life_placement set ["yaw", (life_placement get "yaw") - _step];
        true
    };
    case (_code isEqualTo 18): {
        life_placement set ["yaw", (life_placement get "yaw") + _step];
        true
    };
    case (_code in [28, 156, 57]): {
        //frisch pruefen, die gedrosselte Pruefung kann ein paar Bilder alt sein
        ([] call life_fnc_placementCheck) params ["_ok", "_reason"];
        life_placement set ["valid", _ok];
        life_placement set ["reason", _reason];
        life_placement set ["checkTime", diag_tickTime];
        if (_ok) then {
            [true, ""] call life_fnc_placementEnd;
        } else {
            [localize _reason, true, "fast"] call life_fnc_notification_system;
        };
        true
    };
    case (_code in [1, 14]): {
        [false, "STR_PLC_Cancelled"] call life_fnc_placementEnd;
        true
    };
    default {false};
};
