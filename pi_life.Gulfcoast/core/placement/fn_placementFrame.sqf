#include "..\..\script_macros.hpp"
/*
    File: fn_placementFrame.sqf
    Description:
    Laeuft jedes Bild waehrend des Abstellens (EachFrame): bricht bei ungueltigem Zustand ab, bewegt
    die Vorschau zum Blickpunkt, prueft gedrosselt den Platz (bei Bewegung alle 0,12 s, sonst alle
    0,6 s), faerbt die Vorschau und aktualisiert die Hinweisleiste nur bei Aenderung.
*/
if (!life_placement_active) exitWith {};
private _cfg = missionConfigFile >> "CfgVehiclePlacement";
private _ghost = life_placement get "ghost";
private _elapsed = diag_tickTime - (life_placement get "start");

//Abbruchbedingungen
private _cancel = switch (true) do {
    case (isNull _ghost): {"STR_PLC_Cancelled"};
    case (!alive player || {!isNull objectParent player}): {"STR_PLC_Cancelled"};
    case ((player getVariable ["restrained",false]) || {life_is_arrested} || {life_istazed} || {life_isknocked}): {"STR_PLC_Cancelled"};
    case (_elapsed > 0.5 && {dialog}): {"STR_PLC_Cancelled"}; //kurze Schonfrist, bis der Garagen- bzw. Haendlerdialog zu ist
    case ((player distance2D (life_placement get "origin")) > getNumber (_cfg >> "maxDistanceStart")): {"STR_PLC_CancelDistance"};
    case (_elapsed > getNumber (_cfg >> "timeout")): {"STR_PLC_CancelTimeout"};
    default {""};
};
if !(_cancel isEqualTo "") exitWith {[false, _cancel] call life_fnc_placementEnd;};

//Vorschau bewegen (erst ausrichten, dann setzen: die Position bezieht sich auf den Bodenkontakt)
([] call life_fnc_placementPose) params ["_pos", "_vDir", "_vUp", "_water", "_slope"];

//Schutz fuer Fahrzeuge und Physikobjekte, die auf diesem Rechner simuliert werden (z. B. das zuletzt
//selbst gefahrene Auto): kommt die Vorschau ihnen nahe, wird sie ausgeblendet (ohne Kollision),
//damit die lokale Physik nichts anstoesst. Der Rahmen bleibt sichtbar.
if ((diag_tickTime - (life_placement get "localsTime")) > 0.5) then {
    private _list = (nearestObjects [ASLToAGL _pos, ["LandVehicle", "Air", "Ship", "ThingX"], (life_placement get "halfDiag") + 40]) select {local _x && {!(_x isEqualTo _ghost)} && {!(_x isKindOf "WeaponHolderSimulated")}};
    life_placement set ["locals", _list apply {[_x, ((boundingBoxReal _x) select 2) / 2]}];
    life_placement set ["localsTime", diag_tickTime];
};
private _reach = (life_placement get "halfDiag") + 0.75;
private _hide = ((life_placement get "locals") findIf {!isNull (_x select 0) && {((_x select 0) distance2D _pos) < (_reach + (_x select 1))}}) > -1;
if !(_hide isEqualTo (isObjectHidden _ghost)) then {_ghost hideObject _hide;};

_ghost setVectorDirAndUp [_vDir, _vUp];
_ghost setPosASL _pos;
life_placement set ["pos", _pos];
life_placement set ["vDir", _vDir];
life_placement set ["vUp", _vUp];
life_placement set ["water", _water];
life_placement set ["slope", _slope];

//Platzpruefung gedrosselt
private _last = life_placement get "checkPose";
private _changed = (_last isEqualTo []) || {((_last select 0) vectorDistance _pos) > 0.05} || {((_last select 1) vectorDotProduct _vDir) < 0.99995} || {((_last select 2) vectorDotProduct _vUp) < 0.99995};
private _age = diag_tickTime - (life_placement get "checkTime");
if ((_changed && {_age > 0.12}) || {_age > 0.6}) then {
    ([] call life_fnc_placementCheck) params ["_ok", "_reason"];
    life_placement set ["valid", _ok];
    life_placement set ["reason", _reason];
    life_placement set ["checkTime", diag_tickTime];
    life_placement set ["checkPose", [_pos, _vDir, _vUp]];
};

//Einfaerbung nur bei Wechsel frei/blockiert
private _valid = life_placement get "valid";
private _tint = [0, 1] select _valid;
if !(_tint isEqualTo (life_placement get "tint")) then {
    life_placement set ["tint", _tint];
    private _col = life_placement get (["colBlocked", "colFree"] select _valid);
    private _tex = format ["#(argb,8,8,3)color(%1,%2,%3,%4)", _col select 0, _col select 1, _col select 2, getNumber (_cfg >> "ghostAlpha")];
    {_ghost setObjectTexture [_forEachIndex, _tex];} forEach (life_placement get "hidden");
};

//Hinweisleiste nur bei Aenderung
private _hudKey = format ["%1|%2", _valid, life_placement get "reason"];
if !(_hudKey isEqualTo (life_placement get "hud")) then {
    private _display = uiNamespace getVariable ["life_placement_hud", displayNull];
    if (!isNull _display) then {
        life_placement set ["hud", _hudKey];
        private _status = if (_valid) then {
            format ["<t color='#5fd88a'>%1</t>", localize "STR_PLC_Ok"]
        } else {
            format ["<t color='#ff7466'>%1</t>", localize (life_placement get "reason")]
        };
        (_display displayCtrl 3101) ctrlSetStructuredText parseText format [
            "<t align='center' size='1.15' font='RobotoCondensedBold'>%1</t><br/><t align='center'>%2</t><br/><t align='center' size='0.85' color='#b8bcc6'>%3</t>",
            life_placement get "name", _status, localize "STR_PLC_Help"
        ];
    };
};
