#include "..\..\script_macros.hpp"
/*
    File: fn_placementStart.sqf
    Description:
    Startet das freie Abstellen eines Fahrzeugs (Garage, Fahrzeughaendler). Erzeugt eine lokale
    Vorschau ohne Simulation und Schaden, die dem Blick des Spielers folgt, gruen oder rot eingefaerbt
    ist und einen Rahmen mit Fahrtrichtungspfeil zeigt.
    Steuerung: Blick = Position, Q/E oder Mausrad = drehen (Umschalt = fein),
    Enter oder Leertaste = abstellen, Ruecktaste oder Esc = abbrechen.
    Parameter:
        0: STRING - Klassenname des Fahrzeugs
        1: CODE   - bei Bestaetigung, gespawnt mit [Argumente, PosASL, VectorDir, VectorUp, aufWasser, Klassenname]
        2: CODE   - bei Abbruch, gespawnt mit [Argumente]
        3: ANY    - Argumente fuer die Rueckrufe
    Rueckgabe: BOOL - true, wenn das Abstellen gestartet wurde
*/
params [["_class","",[""]],["_onConfirm",{},[{}]],["_onCancel",{},[{}]],["_args",[]]];
if (life_placement_active) exitWith {[localize "STR_PLC_Busy",true,"fast"] call life_fnc_notification_system; false};
if !(isClass (configFile >> "CfgVehicles" >> _class)) exitWith {false};
if (!alive player || {!isNull objectParent player}) exitWith {false};
private _cfg = missionConfigFile >> "CfgVehiclePlacement";
private _kind = switch (true) do {
    case (_class isKindOf "Ship"): {"Ship"};
    case (_class isKindOf "Air"): {"Air"};
    default {"Car"};
};

//Vorschau: nur auf diesem Rechner, ohne Simulation, Schaden und Zugang
private _ghost = _class createVehicleLocal [0,0,1000];
if (isNull _ghost) exitWith {
    diag_log format ["[PLACEMENT] Vorschau fuer %1 konnte nicht erzeugt werden", _class];
    false
};
_ghost enableSimulation false;
_ghost allowDamage false;
_ghost lock 2;
(boundingBoxReal _ghost) params ["_min","_max"];
_min params ["_x0","_y0","_z0"];
_max params ["_x1","_y1","_z1"];
private _halfDiag = ([_x0, _y0, 0] distance [_x1, _y1, 0]) / 2;
private _maxDist = (getNumber (_cfg >> ("maxDistance" + _kind))) max ((_halfDiag * 2) + 4);

//Pruefstrahlen im Modellraum, einmal berechnet; die Pruefung transformiert sie nur noch
private _c = getNumber (_cfg >> "clearance");
private _zb = _z0 + (0.45 min ((_z1 - _z0) * 0.3)); //knapp ueber dem Boden, damit die Standflaeche nicht zaehlt
private _zt = _z1 + _c;
private _sx = (_x1 - _x0) + (2 * _c);
private _sy = (_y1 - _y0) + (2 * _c);
private _step = ((_sx max _sy) / 14) max 0.5;
private _nx = ceil (_sx / _step);
private _ny = ceil (_sy / _step);
private _xs = [];
for "_i" from 0 to _nx do {_xs pushBack ((_x0 - _c) + ((_sx * _i) / _nx));};
private _ys = [];
for "_i" from 0 to _ny do {_ys pushBack ((_y0 - _c) + ((_sy * _i) / _ny));};
private _zs = [_zb, (_zb + _z1) / 2, _z1 - 0.05];
private _rays = [];
//senkrecht von oben (Pfosten, Baeume, Decken)
{
    private _xx = _x;
    {_rays pushBack [[_xx, _x, _zt], [_xx, _x, _zb]];} forEach _ys;
} forEach _xs;
//senkrecht von unten, schachbrettartig (Decken, in die der obere Strahl hineinstartet)
{
    private _xx = _x;
    private _ix = _forEachIndex;
    {
        if (((_ix + _forEachIndex) % 2) isEqualTo 0) then {_rays pushBack [[_xx, _x, _zb], [_xx, _x, _zt]];};
    } forEach _ys;
} forEach _xs;
//waagerecht laengs und quer in drei Hoehen (Waende, Zaeune, Fahrzeuge)
{
    private _xx = _x;
    {_rays pushBack [[_xx, _y0 - _c, _x], [_xx, _y1 + _c, _x]];} forEach _zs;
} forEach _xs;
{
    private _yy = _x;
    {_rays pushBack [[_x0 - _c, _yy, _x], [_x1 + _c, _yy, _x]];} forEach _zs;
} forEach _ys;

private _name = getText (configFile >> "CfgVehicles" >> _class >> "displayName");
_name = (_name splitString "<>&") joinString "";
life_placement = createHashMapFromArray [
    ["class", _class], ["kind", _kind], ["ghost", _ghost], ["name", _name],
    ["min", _min], ["max", _max], ["halfDiag", _halfDiag], ["maxDist", _maxDist], ["rays", _rays],
    ["yaw", (getDir player) + 90], ["origin", getPosASL player], ["start", diag_tickTime],
    ["onConfirm", _onConfirm], ["onCancel", _onCancel], ["args", _args],
    ["pos", getPosASL player], ["vDir", [0,1,0]], ["vUp", [0,0,1]], ["water", false], ["slope", 0],
    ["valid", false], ["reason", "STR_PLC_Checking"], ["checkTime", -1], ["checkPose", []],
    ["tint", -1], ["hud", ""], ["locals", []], ["localsTime", -1],
    ["colFree", (getArray (_cfg >> "colorFree")) + [1]],
    ["colBlocked", (getArray (_cfg >> "colorBlocked")) + [1]],
    ["hidden", getArray (configFile >> "CfgVehicles" >> _class >> "hiddenSelections")]
];
life_placement_active = true;

("life_placement" call BIS_fnc_rscLayer) cutRsc ["Life_PlacementHud", "PLAIN", 0, false];
life_placement set ["ehFrame", addMissionEventHandler ["EachFrame", {[] call life_fnc_placementFrame;}]];
life_placement set ["ehDraw", addMissionEventHandler ["Draw3D", {[] call life_fnc_placementDraw;}]];
life_placement set ["ehWheel", (findDisplay 46) displayAddEventHandler ["MouseZChanged", {
    params ["", "_scroll"];
    if (life_placement_active && {_scroll != 0}) then {
        private _step = getNumber (missionConfigFile >> "CfgVehiclePlacement" >> "rotateStep");
        life_placement set ["yaw", (life_placement get "yaw") + ([-_step, _step] select (_scroll > 0))];
    };
    false
}]];
//Aktionsmenue sperren: Mausrad dreht das Fahrzeug, Leertaste stellt ab
{inGameUISetEventHandler [_x, "true"];} forEach ["PrevAction", "NextAction", "Action"];
[] call life_fnc_placementFrame;
true
