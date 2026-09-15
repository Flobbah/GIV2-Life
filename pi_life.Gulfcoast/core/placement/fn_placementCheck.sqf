#include "..\..\script_macros.hpp"
/*
    File: fn_placementCheck.sqf
    Description:
    Prueft, ob die Vorschau an ihrer aktuellen Stelle abgestellt werden darf. Reihenfolge von billig
    nach teuer, der erste Grund gewinnt:
      1. Hoehenunterschied zum Spieler
      2. Wasser (Boote brauchen Tiefe, alles andere darf nicht ins Wasser)
      3. Neigung der Standflaeche
      4. Gelaende ragt in das Fahrzeug (z. B. Boden unter einem Hallenboden)
      5. Fahrzeuge, Personen und Physikobjekte ueberlappen den Grundriss (inkl. Sicherheitsabstand)
      6. Strahlen durch das Volumen gegen die Kollisionsgeometrie aller Objekte (Waende, Zaeune,
         Pfosten, Baeume, Decken). Innen in einer ausreichend grossen Halle ist also erlaubt.
    Rueckgabe: ARRAY - [BOOL erlaubt, STRING Stringtable-Schluessel des Grundes]
*/
private _cfg = missionConfigFile >> "CfgVehiclePlacement";
private _ghost = life_placement get "ghost";
private _kind = life_placement get "kind";
private _pos = life_placement get "pos";
private _water = life_placement get "water";
private _isShip = _kind isEqualTo "Ship";
(life_placement get "min") params ["_x0","_y0","_z0"];
(life_placement get "max") params ["_x1","_y1","_z1"];
private _c = getNumber (_cfg >> "clearance");
private _xm = (_x0 + _x1) / 2;
private _ym = (_y0 + _y1) / 2;
private _bottom = [[_x0,_y0],[_x1,_y0],[_x1,_y1],[_x0,_y1],[_xm,_y0],[_xm,_y1],[_x0,_ym],[_x1,_ym]] apply {_ghost modelToWorldWorld [_x select 0, _x select 1, _z0]};
private _top = [[_x0,_y0],[_x1,_y0],[_x1,_y1],[_x0,_y1]] apply {_ghost modelToWorldWorld [_x select 0, _x select 1, _z1]};

//1.-4.
if ((abs ((_pos select 2) - ((getPosASL player) select 2))) > getNumber (_cfg >> "maxHeightDiff")) exitWith {[false, "STR_PLC_ErrHeight"]};
if (_isShip && {!_water}) exitWith {[false, "STR_PLC_ErrNoWater"]};
private _minDepth = getNumber (_cfg >> "minWaterDepth");
if (_isShip && {((getTerrainHeightASL _pos) > -_minDepth) || {(_bottom findIf {(getTerrainHeightASL _x) > -(_minDepth / 2)}) > -1}}) exitWith {[false, "STR_PLC_ErrShallow"]};
if (!_isShip && {_water}) exitWith {[false, "STR_PLC_ErrWater"]};
private _maxSlope = getNumber (_cfg >> (["maxSlope", "maxSlopeAir"] select (_kind isEqualTo "Air")));
if (!_isShip && {(life_placement get "slope") > _maxSlope}) exitWith {[false, "STR_PLC_ErrSlope"]};
if (!_isShip && {(_bottom findIf {(getTerrainHeightASL _x) > ((_x select 2) + 0.35)}) > -1}) exitWith {[false, "STR_PLC_ErrTerrain"]};

//5. Fahrzeuge, Personen, Physikobjekte: gedrehte Grundrisse (Trennachsen) plus Hoehenbereich
private _fnc_overlap = {
    params ["_a", "_b"];
    private _separated = false;
    {
        private _poly = _x;
        for "_i" from 0 to 1 do {
            private _p1 = _poly select _i;
            private _p2 = _poly select (_i + 1);
            private _ax = -((_p2 select 1) - (_p1 select 1));
            private _ay = (_p2 select 0) - (_p1 select 0);
            private _pa = _a apply {((_x select 0) * _ax) + ((_x select 1) * _ay)};
            private _pb = _b apply {((_x select 0) * _ax) + ((_x select 1) * _ay)};
            if (((selectMax _pa) < (selectMin _pb)) || {(selectMax _pb) < (selectMin _pa)}) exitWith {_separated = true;};
        };
        if (_separated) exitWith {};
    } forEach [_a, _b];
    !_separated
};
private _rect = [[_x0 - _c, _y0 - _c], [_x1 + _c, _y0 - _c], [_x1 + _c, _y1 + _c], [_x0 - _c, _y1 + _c]] apply {
    private _w = _ghost modelToWorldWorld [_x select 0, _x select 1, _z0];
    [_w select 0, _w select 1]
};
private _gz0 = selectMin (_bottom apply {_x select 2});
private _gz1 = (selectMax (_top apply {_x select 2})) + _c;
private _ignore = [_ghost, player] + (attachedObjects _ghost);
private _center = _ghost modelToWorldWorld [_xm, _ym, _z0];
private _near = ((nearestObjects [ASLToAGL _center, ["AllVehicles", "ThingX"], (life_placement get "halfDiag") + 12]) - _ignore) select {
    !(_x isKindOf "WeaponHolderSimulated") && {!isObjectHidden _x}
};
private _blocker = objNull;
{
    private _e = _x;
    (boundingBoxReal _e) params ["_emin", "_emax"];
    private _erect = [[_emin select 0, _emin select 1], [_emax select 0, _emin select 1], [_emax select 0, _emax select 1], [_emin select 0, _emax select 1]] apply {
        private _w = _e modelToWorldWorld [_x select 0, _x select 1, _emin select 2];
        [_w select 0, _w select 1]
    };
    private _ez0 = (_e modelToWorldWorld [0, 0, _emin select 2]) select 2;
    private _ez1 = (_e modelToWorldWorld [0, 0, _emax select 2]) select 2;
    if ((_ez1 > _gz0) && {_ez0 < _gz1} && {[_rect, _erect] call _fnc_overlap}) exitWith {_blocker = _e;};
} forEach _near;
if (!isNull _blocker) exitWith {[false, ["STR_PLC_ErrVehicle", "STR_PLC_ErrPerson"] select (_blocker isKindOf "Man")]};

//6. Kollisionsgeometrie per Strahlen (Gelaendetreffer zaehlen nicht, die deckt Punkt 4 ab)
private _hit = (life_placement get "rays") findIf {
    private _res = lineIntersectsSurfaces [_ghost modelToWorldWorld (_x select 0), _ghost modelToWorldWorld (_x select 1), _ghost, player, false, 3, "GEOM", "NONE", false];
    (_res findIf {
        private _o = _x select 2;
        !isNull _o && {!(_o in _ignore)} && {!((_x select 3) in _ignore)} && {!(_o isKindOf "WeaponHolderSimulated")}
    }) > -1
};
if (_hit > -1) exitWith {[false, "STR_PLC_ErrObject"]};
[true, ""]
