#include "\life_server\script_macros.hpp"
/*
    File: fn_customCall.sqf
    Description:
    Ruft eine vorbereitete Anweisung aus @extDB3\sql_custom\pilife.ini auf (Phase 0.3 aus
    docs/ROADMAP.md). Der Unterschied zu DB_fnc_asyncCall: Die Anweisung steht fertig in der
    ini-Datei, die Werte kommen als gebundene Parameter dazu und koennen die Abfrage nicht mehr
    veraendern - egal, was ein Spieler in ein Textfeld schreibt.

    Ist das Protokoll nicht angemeldet (ini fehlt, alte extDB3-Fassung), wird der mitgegebene
    Ersatzweg benutzt. So bleibt ein Server lauffaehig, auf dem die Datei noch nicht liegt.

    Parameter:
        0: STRING - Name der Abfrage, wie er in pilife.ini in eckigen Klammern steht
        1: ARRAY  - Werte fuer die Fragezeichen, in der Reihenfolge von SQL1_INPUTS
        2: NUMBER - 1 = schreiben ohne Rueckgabe, 2 = lesen mit Rueckgabe (wie DB_fnc_asyncCall)
        3: CODE   - (optional) Ersatz mit der alten Abfrage; bekommt die Werte als _this
    Rueckgabe:
        wie DB_fnc_asyncCall: true beim Schreiben, sonst das Ergebnis; [] wenn nichts ging
*/
params [
    ["_name", "", [""]],
    ["_args", [], [[]]],
    ["_mode", 2, [0]],
    ["_fallback", {}, [{}]]
];
private _id = missionNamespace getVariable ["life_sql_custom_id", -1];
if (_name isEqualTo "" || {_id < 0}) exitWith {
    //Kein Protokoll: der alte Weg, damit der Server nicht stehenbleibt
    if !(_fallback isEqualTo {}) exitWith {_args call _fallback};
    if (_mode isEqualTo 1) then {false} else {[]}
};
//Die Werte haengen mit ":" hinter dem Namen - ein Doppelpunkt im Wert wuerde die Zerlegung
//verschieben, deshalb kommt er hier nicht durch. Alles andere darf drinbleiben: der Wert landet
//als gebundener Parameter in der Anweisung und kann sie nicht mehr veraendern.
private _clean = _args apply {
    private _v = _x;
    if !(_v isEqualType "") then {_v = str _v};
    _v regexReplace [":", " "]
};
private _payload = _name;
if !(_clean isEqualTo []) then {_payload = _name + ":" + (_clean joinString ":")};

private _key = EXTDB format ["%1:%2:%3", _mode, _id, _payload];
if (_mode isEqualTo 1) exitWith {true};
_key = call compile format ["%1", _key];
if !(_key isEqualType []) exitWith {
    diag_log format ["[SQLCUSTOM] %1: no handle (%2)", _name, _key];
    if !(_fallback isEqualTo {}) exitWith {_args call _fallback};
    []
};
_key = _key select 1;
private _result = EXTDB format ["4:%1", _key];
//extDB3 antwortet mit [3], solange das Ergebnis noch nicht da ist
if (_result isEqualTo "[3]") then {
    for "_i" from 0 to 1 step 0 do {
        if (!(_result isEqualTo "[3]")) exitWith {};
        _result = EXTDB format ["4:%1", _key];
    };
};
//Mehrteilige Antwort wie in DB_fnc_asyncCall
if (_result isEqualTo "[5]") then {
    private _loop = true;
    for "_i" from 0 to 1 step 0 do {
        _result = "";
        for "_j" from 0 to 1 step 0 do {
            private _pipe = EXTDB format ["5:%1", _key];
            if (_pipe isEqualTo "") exitWith {_loop = false};
            _result = _result + _pipe;
        };
        if (!_loop) exitWith {};
    };
};
_result = call compile _result;
if !(_result isEqualType []) exitWith {
    diag_log format ["[SQLCUSTOM] %1: unexpected answer %2", _name, _result];
    if !(_fallback isEqualTo {}) exitWith {_args call _fallback};
    []
};
//extDB3 antwortet [1, Daten] bei Erfolg und [0, "Fehler"] sonst
if ((_result param [0, 0]) isEqualTo 0) exitWith {
    diag_log format ["[SQLCUSTOM] %1 failed: %2", _name, _result param [1, ""]];
    if !(_fallback isEqualTo {}) exitWith {_args call _fallback};
    []
};
_result param [1, []]
