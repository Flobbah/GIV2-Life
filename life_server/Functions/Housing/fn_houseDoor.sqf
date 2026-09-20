#include "\life_server\script_macros.hpp"
/*
    File: fn_houseDoor.sqf
    Description:
    Schliesst Haustueren auf und zu (Sicherheitsprüfung, Fund #7). Bisher schrieb jeder Client die
    Variable `bis_disabled_Door_<n>` direkt an das Gebaeude - und weil das eine oeffentliche
    Variable an einem Objekt ist, konnte *jeder* jede Tuer oeffnen: fremde Haeuser, ohne Dietrich,
    ohne Bolzenschneider, ohne in der Naehe zu sein.

    Jetzt entscheidet der Server. Den Besitzer holt er aus seinem eigenen Speicher
    (`house_owner`, seit Sicherheitsphase 0.2), nicht aus einer Variablen am Haus.

    Zustaende:
        own    - der Besitzer schliesst eine einzelne Tuer auf oder zu
        all    - der Besitzer schliesst alle Tueren (Kauf, "Haus abschliessen", Verkauf)
        force  - aufbrechen: Polizei (Razzia) oder Bolzenschneider. Nur oeffnen, nie schliessen.
        repair - Polizei setzt eine aufgebrochene Tuer wieder instand und verschliesst sie
        storage- der Besitzer schaltet das Lagerschloss (Variable "locked"): kommen Fremde an die Kisten?

    Beim Aufbrechen kann der Server nicht pruefen, ob der Fortschrittsbalken wirklich durchlief -
    das entscheidet der Client. Er prueft, was pruefbar ist: Abstand, Fraktion, Taktrate. Jeder
    Fall steht als [HOUSE] im Log.

    Parameter:
        0: OBJECT - das Gebaeude
        1: NUMBER - Tuernummer (bei "all" egal)
        2: NUMBER - 0 = offen, 1 = verschlossen
        3: STRING - own | all | force | repair
*/
private _owner = CALLER_OWNER;
params [["_house", objNull, [objNull]], ["_door", 0, [0]], ["_state", 1, [0]], ["_mode", "own", [""]]];
private _info = [_owner] call TON_fnc_callerInfo;
if (_info isEqualTo []) exitWith {};
_info params ["_uid", "_unit", "_side", "_name"];
_door = round _door;
_state = [0, 1] select (_state > 0);

private _houseOwner = ([_house, "house_owner", []] call TON_fnc_serverGet) param [0, ""];
private _deny = "";
switch (true) do {
    case (!(_mode in ["own", "all", "force", "repair", "storage"])): {_deny = format ["unknown mode %1", _mode]};
    case (isNull _house || {!(_house isKindOf "House_F")}): {_deny = "not a building"};
    case (!alive _unit): {_deny = "sender is dead"};
    case ((_unit distance _house) > 25): {_deny = format ["%1 m away", round (_unit distance _house)]};
    case (_mode in ["own", "all", "storage"] && {!(_houseOwner isEqualTo _uid)}): {_deny = "sender does not own this house"};
    case (_mode isEqualTo "force" && {!(_state isEqualTo 0)}): {_deny = "forcing can only open"};
    case (_mode isEqualTo "force" && {(_unit distance _house) > 12}): {_deny = "too far to force a door"};
    case (_mode isEqualTo "repair" && {!(_side isEqualTo west)}): {_deny = "only police repair doors"};
    case (_mode in ["own", "force", "repair"] && {_door < 1 || {_door > 12}}): {_deny = format ["invalid door %1", _door]};
};
if !(_deny isEqualTo "") exitWith {
    [_owner, "TON_fnc_houseDoor " + _mode, _deny] call TON_fnc_denyCaller;
};

//Aufbrechen hoechstens alle 10 Sekunden je Spieler, damit niemand eine Strasse durchklickt
if (_mode isEqualTo "force") then {
    private _last = [_uid, "doorLast", -1e9] call TON_fnc_serverGet;
    if ((diag_tickTime - _last) < 10) exitWith {
        [_owner, "TON_fnc_houseDoor force", "forcing too fast"] call TON_fnc_denyCaller;
        _deny = "rate";
    };
    [_uid, "doorLast", diag_tickTime] call TON_fnc_serverSet;
};
if (_deny isEqualTo "rate") exitWith {};

if (_mode isEqualTo "storage") exitWith {
    //Lagerschloss: entscheidet, ob Fremde an die Kisten im Haus kommen
    _house setVariable ["locked", _state > 0, true];
    true
};
if (_mode isEqualTo "all") then {
    //So viele Tueren, wie das Gebaeude laut Spiel-Config hat (wie in life_fnc_lockupHouse)
    private _count = getNumber (configFile >> "CfgVehicles" >> (typeOf _house) >> "numberOfDoors");
    if (_count < 1) then {_count = 12};
    for "_i" from 1 to _count do {
        _house setVariable [format ["bis_disabled_Door_%1", _i], _state, true];
    };
    //"locked" haengt am selben Zustand und wird von Razzia und Bolzenschneider gelesen
    _house setVariable ["locked", _state > 0, true];
} else {
    _house setVariable [format ["bis_disabled_Door_%1", _door], _state, true];
    if (_mode isEqualTo "force") then {_house setVariable ["locked", false, true]};
};
if (_mode isEqualTo "repair") then {
    //Wie im Client zuvor: das Haus gilt erst wieder als verschlossen, wenn keine Tuer mehr offen ist
    private _count = getNumber (configFile >> "CfgVehicles" >> (typeOf _house) >> "numberOfDoors");
    private _allLocked = true;
    for "_i" from 1 to (_count max 1) do {
        if ((_house getVariable [format ["bis_disabled_Door_%1", _i], 0]) isEqualTo 0) exitWith {_allLocked = false};
    };
    if (_allLocked) then {_house setVariable ["locked", true, true]};
};
if (_mode in ["force", "repair"]) then {
    diag_log format ["[HOUSE] %1 (%2) %3 door %4 of %5 (owner %6)",
        _name, _uid, ["opened by force", "repaired"] select (_mode isEqualTo "repair"),
        _door, typeOf _house, _houseOwner];
};
true
