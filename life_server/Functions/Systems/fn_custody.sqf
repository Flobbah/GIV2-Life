#include "\life_server\script_macros.hpp"
/*
    File: fn_custody.sqf
    Description:
    Anfrage, den Zustand eines Festgenommenen zu aendern (Sicherheitsprüfung, Fund #7). Der Server
    prueft Absender, Fraktion und Abstand und setzt die Variablen dann selbst ueber
    TON_fnc_custodySet. Der Client setzt "restrained", "Escorting" und "transporting" nicht mehr.

    Die Fraktion kommt aus dem Serverspeicher (AUTH_SIDE), nicht aus der Variablen am Spieler -
    die kann ein Client faelschen.

    Zustaende:
        restrain | release | escort | stopEscort | inCar | outCar | jail   nur Polizei
        pick      Dietrich: ein Mitspieler befreit einen Gefesselten (jede Fraktion, 5 m)
        dead      Selbstmeldung des Gestorbenen; der Server prueft, dass er wirklich tot ist

    Parameter:
        0: OBJECT - der Festgenommene
        1: STRING - Zustand
*/
private _owner = CALLER_OWNER;
params [["_target", objNull, [objNull]], ["_state", "", [""]]];
private _info = [_owner] call TON_fnc_callerInfo;
if (_info isEqualTo []) exitWith {};
_info params ["_uid", "_unit", "_side", "_name"];

//Hoechstabstand je Zustand: Fesseln und Begleiten aus der Naehe, Einsteigen und Gefaengnis weiter
private _range = switch (_state) do {
    case "restrain": {15};
    case "release": {15};
    case "escort": {15};
    case "stopEscort": {25};
    case "inCar": {25};
    case "outCar": {25};
    case "jail": {30};
    case "pick": {5};
    case "dead": {0};
    default {-1};
};
private _self = _state isEqualTo "dead";
private _copOnly = !(_state in ["pick", "dead"]);
private _deny = "";
switch (true) do {
    case (_range < 0): {_deny = format ["unknown state %1", _state]};
    case (isNull _target || {!isPlayer _target}): {_deny = "target is not a player"};
    //Selbstmeldung: nur fuer sich selbst und nur wirklich tot
    case (_self && {!(_target isEqualTo _unit)}): {_deny = "dead is only for yourself"};
    case (_self && {alive _target}): {_deny = "reported dead while alive"};
    case (!_self && {_target isEqualTo _unit}): {_deny = "sender is the target"};
    case (!_self && {!alive _unit}): {_deny = "sender is dead"};
    case (_copOnly && {!(_side isEqualTo west)}): {_deny = format ["side %1 cannot take people into custody", _side]};
    case (!_self && {(_unit distance _target) > _range}): {_deny = format ["%1 m away, at most %2", round (_unit distance _target), _range]};
    //Ein Dietrich hilft nur jemandem, der wirklich gefesselt ist
    case (_state isEqualTo "pick" && {!(_target getVariable ["restrained", false])}): {_deny = "target is not restrained"};
    //Polizisten fesselt niemand
    case (_state isEqualTo "restrain" && {(AUTH_SIDE(getPlayerUID _target)) isEqualTo west}): {_deny = "target is police"};
};
if !(_deny isEqualTo "") exitWith {
    [_owner, "TON_fnc_custody " + _state, _deny] call TON_fnc_denyCaller;
};
[_target, _state, _unit] call TON_fnc_custodySet;
