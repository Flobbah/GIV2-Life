#include "\life_server\script_macros.hpp"
/*
    File: fn_custodySet.sqf
    Description:
    Der einzige Ort, an dem "restrained", "Escorting" und "transporting" gesetzt werden
    (Sicherheitsprüfung, Fund #7). Frueher setzte sie der Client des Polizisten *und* der des
    Festgenommenen - wer die Variable selbst setzte, fesselte ohne jede Pruefung oder befreite sich.
    Jetzt schreibt sie nur der Server; ein Client, der es versucht, faellt dem BattlEye-Filter auf.

    Server-only: nicht in CfgRemoteExec. Aufrufer sind TON_fnc_custody (geprueft) und
    TON_fnc_custodyWatch (Zeitablauf, Tod).

    Parameter:
        0: OBJECT - der Festgenommene
        1: STRING - restrain | release | escort | stopEscort | inCar | outCar | jail
        2: OBJECT - (optional) der Polizist, fuer die Aufsicht ueber das Begleiten
*/
params [["_target", objNull, [objNull]], ["_state", "", [""]], ["_cop", objNull, [objNull]]];
if (isNull _target || {_state isEqualTo ""}) exitWith {};
private _uid = getPlayerUID _target;

//[gefesselt seit, Polizist beim Begleiten, zuletzt ein Polizist in der Naehe]
private _custody = localNamespace getVariable "life_custody";
if (isNil "_custody") then {
    _custody = createHashMap;
    localNamespace setVariable ["life_custody", _custody];
};
private _entry = _custody getOrDefault [_uid, [0, objNull, 0]];

private _set = {
    params ["_name", "_value"];
    _target setVariable [_name, _value, true];
};
switch (_state) do {
    case "restrain": {
        ["restrained", true] call _set;
        ["Escorting", false] call _set;
        ["transporting", false] call _set;
        ["playerSurrender", false] call _set;
        _custody set [_uid, [time, objNull, time]];
    };
    case "escort": {
        ["Escorting", true] call _set;
        ["transporting", false] call _set;
        _entry set [1, _cop];
        _custody set [_uid, _entry];
    };
    case "stopEscort": {
        ["Escorting", false] call _set;
        _entry set [1, objNull];
        _custody set [_uid, _entry];
    };
    case "inCar": {
        ["transporting", true] call _set;
        ["Escorting", false] call _set;
        _entry set [1, objNull];
        _custody set [_uid, _entry];
    };
    case "outCar": {
        ["transporting", false] call _set;
        ["Escorting", false] call _set;
        _entry set [1, objNull];
        _custody set [_uid, _entry];
    };
    //release und jail beenden den Gewahrsam vollstaendig
    default {
        ["restrained", false] call _set;
        ["Escorting", false] call _set;
        ["transporting", false] call _set;
        _custody deleteAt _uid;
    };
};
true
