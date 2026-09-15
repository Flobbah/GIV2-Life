#include "..\..\script_macros.hpp"
/*
    File: fn_placementPose.sqf
    Description:
    Berechnet aus dem Blick des Spielers die Lage der Vorschau: Zielpunkt auf Boden, Objekt oder
    Wasseroberflaeche, waagerecht auf den erlaubten Abstand begrenzt, dann senkrecht die Standflaeche
    gesucht (Gelaende, Gebaeudeboden, Steg) und das Fahrzeug an deren Neigung ausgerichtet.
    Rueckgabe: ARRAY - [PosASL, VectorDir, VectorUp, aufWasser, Neigung in Grad]
*/
private _ghost = life_placement get "ghost";
private _maxDist = life_placement get "maxDist";
private _minDist = (life_placement get "halfDiag") + 1.5;
private _playerASL = getPosASL player;

//1. Zielpunkt entlang der Kamerablickrichtung (1st und 3rd Person)
private _cam = AGLToASL (positionCameraToWorld [0,0,0]);
private _dir = vectorNormalized ((AGLToASL (positionCameraToWorld [0,0,10])) vectorDiff _cam);
private _range = _maxDist + 30;
private _aim = _cam vectorAdd (_dir vectorMultiply _range);
private _aimDist = _range;
private _hits = lineIntersectsSurfaces [_cam, _aim, player, _ghost, true, 1, "GEOM", "NONE", true];
if (count _hits > 0) then {
    _aim = (_hits select 0) select 0;
    _aimDist = _cam vectorDistance _aim;
};
//Wasseroberflaeche erkennt lineIntersectsSurfaces nicht: Schnitt mit Meereshoehe 0
if (((_dir select 2) < -0.01) && {(_cam select 2) > 0}) then {
    private _t = -(_cam select 2) / (_dir select 2);
    if (_t < _aimDist) then {
        private _wp = _cam vectorAdd (_dir vectorMultiply _t);
        if (surfaceIsWater _wp) then {_aim = _wp;};
    };
};

//2. Waagerecht auf Mindest- und Hoechstabstand zum Spieler begrenzen
private _flat = [(_aim select 0) - (_playerASL select 0), (_aim select 1) - (_playerASL select 1), 0];
private _dirFlat = vectorNormalized _flat;
if ((vectorMagnitude _dirFlat) < 0.5) then {
    _dirFlat = vectorNormalized [_dir select 0, _dir select 1, 0];
    if ((vectorMagnitude _dirFlat) < 0.5) then {_dirFlat = [sin (getDir player), cos (getDir player), 0];};
};
private _dist = ((vectorMagnitude _flat) max _minDist) min _maxDist;
private _xy = _playerASL vectorAdd (_dirFlat vectorMultiply _dist);

//3. Standflaeche senkrecht suchen, Start knapp ueber Augenhoehe (so zaehlen Hallendaecher nicht)
private _terrainZ = getTerrainHeightASL _xy;
private _top = ((_playerASL select 2) + 2.7) max (_terrainZ + 0.5);
private _pos = [_xy select 0, _xy select 1, _terrainZ];
private _up = surfaceNormal _xy;
private _onObject = false;
private _probe = lineIntersectsSurfaces [[_xy select 0, _xy select 1, _top], [_xy select 0, _xy select 1, _terrainZ - 1], player, _ghost, true, 1, "GEOM", "NONE", true];
if (count _probe > 0) then {
    (_probe select 0) params ["_hitPos", "_hitNormal", "_hitObj"];
    _pos = _hitPos;
    _up = _hitNormal;
    _onObject = !isNull _hitObj;
};
private _water = false;
if (!_onObject && {surfaceIsWater _xy} && {_terrainZ < 0}) then {
    _water = true;
    _pos = [_xy select 0, _xy select 1, 0];
    _up = [0,0,1];
};
if ((_up select 2) < 0) then {_up = _up vectorMultiply -1;};
_up = vectorNormalized _up;
if ((vectorMagnitude _up) < 0.5) then {_up = [0,0,1];};

//4. Neigung und Ausrichtung (Drehung um die Hochachse der Flaeche)
private _slope = acos (((_up select 2) min 1) max -1);
if (_slope > 35) then {_up = [0,0,1];};
private _yaw = life_placement get "yaw";
private _fwd = [sin _yaw, cos _yaw, 0];
private _vDir = vectorNormalized (_fwd vectorDiff (_up vectorMultiply (_fwd vectorDotProduct _up)));
if ((vectorMagnitude _vDir) < 0.5) then {_vDir = _fwd;};
[_pos, _vDir, _up, _water, _slope]
