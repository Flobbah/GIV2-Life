#include "\life_server\script_macros.hpp"
/*
    File: fn_vehicleKeys.sqf
    Description:
    Verwaltet die Schluessel eines Fahrzeugs (Sicherheitsprüfung, Fund #7). Frueher stand die Liste
    als oeffentliche Variable am Fahrzeug und jeder Client konnte sie setzen - ein Spieler brauchte
    nur "vehicle_info_owners" auf sich selbst zu schreiben, um jedes Auto aufzuschliessen.

    Jetzt fuehrt der Server die Liste (Serverspeicher, Feld "keys") und schreibt die Variable am
    Objekt nur noch als Anzeige fuer die Menues der Clients.

    Zustaende:
        give  - der Absender gibt einem Mitspieler einen Schluessel (er muss selbst einen haben)
        drop  - der Absender gibt seinen eigenen Schluessel ab
        pick  - Dietrich: der Absender verschafft sich einen Schluessel
        rent  - Mietfahrzeug: der Absender loest eine bezahlte Miete ein

    Beim Dietrich kann der Server nicht pruefen, ob das Schloss wirklich aufging - diese Entscheidung
    faellt im Client (Wuerfel und Skill). Er prueft, was er pruefen kann: Abstand, dass es ein
    Fahrzeug ist, und dass nicht im Sekundentakt gepickt wird. Jeder Fall steht als [KEYS] im Log,
    und die Fahndung schreibt der Client ohnehin schon mit.

    Parameter:
        0: OBJECT - das Fahrzeug
        1: STRING - give | drop | pick
        2: OBJECT - (nur bei give) der Beschenkte
*/
private _owner = CALLER_OWNER;
params [["_vehicle", objNull, [objNull]], ["_action", "", [""]], ["_target", objNull, [objNull]]];
private _info = [_owner] call TON_fnc_callerInfo;
if (_info isEqualTo []) exitWith {};
_info params ["_uid", "_unit", "_side", "_name"];

private _deny = "";
private _range = switch (_action) do {
    case "give": {15};
    case "drop": {1e9};   //abgeben geht immer, auch aus der Ferne
    case "pick": {6};
    case "rent": {30};
    default {-1};
};
switch (true) do {
    case (_range < 0): {_deny = format ["unknown action %1", _action]};
    case (isNull _vehicle): {_deny = "no vehicle"};
    case (!(_vehicle isKindOf "AllVehicles")): {_deny = format ["%1 is not a vehicle", typeOf _vehicle]};
    case (!alive _unit): {_deny = "sender is dead"};
    case ((_unit distance _vehicle) > _range): {_deny = format ["%1 m away, at most %2", round (_unit distance _vehicle), _range]};
    case (_action isEqualTo "give" && {isNull _target || {!isPlayer _target}}): {_deny = "target is not a player"};
    case (_action isEqualTo "give" && {!([_vehicle, _uid] call TON_fnc_hasKey)}): {_deny = "sender has no key"};
    case (_action isEqualTo "give" && {(_unit distance _target) > 15}): {_deny = "target too far away"};
};
if !(_deny isEqualTo "") exitWith {
    [_owner, "TON_fnc_vehicleKeys " + _action, _deny] call TON_fnc_denyCaller;
};

//Dietrich: hoechstens alle 15 Sekunden, damit niemand einen Parkplatz durchprobiert
if (_action isEqualTo "pick") then {
    private _last = [_uid, "pickLast", -1e9] call TON_fnc_serverGet;
    if ((diag_tickTime - _last) < 15) exitWith {
        [_owner, "TON_fnc_vehicleKeys pick", "picking too fast"] call TON_fnc_denyCaller;
        _deny = "rate";
    };
    [_uid, "pickLast", diag_tickTime] call TON_fnc_serverSet;
};
if (_deny isEqualTo "rate") exitWith {};

//Miete: Der Server hat die Zahlung gebucht (TON_fnc_econShop) und gibt den Schluessel genau
//einmal dafuer heraus - und nur fuer die bezahlte Fahrzeugart innerhalb von zehn Minuten.
if (_action isEqualTo "rent" && {ECONOMY_MODE >= 1}) then {
    private _class = toLower (typeOf _vehicle);
    private _found = false;
    //Miete und Kauf zaehlen beide: Fahrzeuge aus "vehicleShop_rentalOnly" werden gekauft, aber
    //nicht in die Datenbank eingetragen - auch die laufen deshalb ueber diesen Weg.
    {
        private _list = [_uid, _x, []] call TON_fnc_serverGet;
        private _i = _list findIf {
            ((toLower (_x param [0, ""])) isEqualTo _class) && {(diag_tickTime - (_x param [1, 0])) < 600}
        };
        if (_i > -1 && {!_found}) then {
            _found = true;
            _list deleteAt _i;
            [_uid, _x, _list] call TON_fnc_serverSet;
        };
    } forEach ["vehiclesRented", "vehiclesPaid"];
    if (!_found) exitWith {
        [_owner, "TON_fnc_vehicleKeys rent", format ["nothing paid for %1", typeOf _vehicle]] call TON_fnc_denyCaller;
        _deny = "rent";
    };
};
if (_deny isEqualTo "rent") exitWith {};

//Die Liste hat dieselbe Form wie die Anzeige am Fahrzeug: [[uid, name], ...]
private _keys = [_vehicle, "keys", []] call TON_fnc_serverGet;
if !(_keys isEqualType []) then {_keys = []};
switch (_action) do {
    case "give": {
        private _tuid = getPlayerUID _target;
        private _tname = _target getVariable ["realname", name _target];
        if ((_keys findIf {(_x param [0, ""]) isEqualTo _tuid}) isEqualTo -1) then {
            _keys pushBack [_tuid, _tname];
        };
        diag_log format ["[KEYS] %1 (%2) gave a key for %3 to %4", _name, _uid, typeOf _vehicle, _tname];
    };
    case "drop": {
        _keys = _keys select {!((_x param [0, ""]) isEqualTo _uid)};
        diag_log format ["[KEYS] %1 (%2) dropped the key for %3", _name, _uid, typeOf _vehicle];
    };
    case "pick": {
        if ((_keys findIf {(_x param [0, ""]) isEqualTo _uid}) isEqualTo -1) then {
            _keys pushBack [_uid, _name];
        };
        diag_log format ["[KEYS] %1 (%2) picked the lock of %3", _name, _uid, typeOf _vehicle];
    };
    case "rent": {
        if ((_keys findIf {(_x param [0, ""]) isEqualTo _uid}) isEqualTo -1) then {
            _keys pushBack [_uid, _name];
        };
        diag_log format ["[KEYS] %1 (%2) rented %3", _name, _uid, typeOf _vehicle];
    };
};
[_vehicle, _keys] call TON_fnc_vehicleKeysSet;
