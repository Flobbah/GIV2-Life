/*
    File: fn_placementDraw.sqf
    Description:
    Zeichnet waehrend des Abstellens (Draw3D) den Rahmen der Vorschau, einen Pfeil in Fahrtrichtung
    und den Fahrzeugnamen darueber, gruen fuer frei und rot fuer blockiert.
*/
if (!life_placement_active) exitWith {};
private _ghost = life_placement get "ghost";
if (isNull _ghost) exitWith {};
(life_placement get "min") params ["_x0","_y0","_z0"];
(life_placement get "max") params ["_x1","_y1","_z1"];
private _col = life_placement get (["colBlocked", "colFree"] select (life_placement get "valid"));
private _p = [[_x0,_y0,_z0],[_x1,_y0,_z0],[_x1,_y1,_z0],[_x0,_y1,_z0],[_x0,_y0,_z1],[_x1,_y0,_z1],[_x1,_y1,_z1],[_x0,_y1,_z1]] apply {_ghost modelToWorldVisual _x};
{
    drawLine3D [_p select (_x select 0), _p select (_x select 1), _col, 4];
} forEach [[0,1],[1,2],[2,3],[3,0],[4,5],[5,6],[6,7],[7,4],[0,4],[1,5],[2,6],[3,7]];
//Fahrtrichtung: vorne ist +Y im Modell
private _xm = (_x0 + _x1) / 2;
private _len = 1.2 max ((_y1 - _y0) * 0.2);
private _tip = _ghost modelToWorldVisual [_xm, _y1 + _len, _z0];
drawLine3D [_ghost modelToWorldVisual [_xm, _y1, _z0], _tip, _col, 4];
drawLine3D [_ghost modelToWorldVisual [_xm - 0.5, (_y1 + _len) - 0.6, _z0], _tip, _col, 4];
drawLine3D [_ghost modelToWorldVisual [_xm + 0.5, (_y1 + _len) - 0.6, _z0], _tip, _col, 4];
drawIcon3D ["", _col, _ghost modelToWorldVisual [_xm, (_y0 + _y1) / 2, _z1 + 0.7], 0, 0, 0, life_placement get "name", 2, 0.04, "RobotoCondensedBold", "center"];
