/*
    File: fn_navMiniMapDraw.sqf
    Description:
    Draw-Handler der Navi-Minikarte. Die Karte selbst ist nicht gedreht; gedreht wird die Geometrie:
    Eine 3x3-Matrix dreht alle Punkte um den Spieler (Fahrtrichtung nach oben) und verschiebt sie auf
    die leere Zeichenflaeche life_nav_miniCanvas. matrixMultiply rechnet alle Punkte in einem nativen
    Befehl, drawTriangle zeichnet jede Ebene in einem Befehl; pro Bild gibt es keine Skriptschleife
    ueber Strassen.
    Zeichenfolge: Strassen (Feldweg, Strasse, Hauptstrasse), Routenrand, Route, Ziel, Pfeil, Norden.
    Parameter: [Kartensteuerelement]
*/
params ["_map"];
if !(missionNamespace getVariable ["life_nav_active", false]) exitWith {};
private _canvas = missionNamespace getVariable ["life_nav_miniCanvas", []];
if (_canvas isEqualTo []) exitWith {};
private _veh = vehicle player;
private _p = getPosVisual _veh;
private _h = getDirVisual _veh;
private _c = cos _h;
private _s = sin _h;
//Zeilenvektor [x, y, 1] * M: x' = x*c - y*s + tx, y' = x*s + y*c + ty (Punkt voraus -> oben)
private _tx = (_canvas select 0) - (((_p select 0) * _c) - ((_p select 1) * _s));
private _ty = (_canvas select 1) - (((_p select 0) * _s) + ((_p select 1) * _c));
private _m = [[_c, _s, 0], [-_s, _c, 0], [_tx, _ty, 1]];
private _fill = "#(rgb,8,8,3)color(1,1,1,1)";

//Strassen
{
    _x params ["_verts", "_color"];
    if ((count _verts) > 2) then {_map drawTriangle [_verts matrixMultiply _m, _color, _fill];};
} forEach (missionNamespace getVariable ["life_nav_miniRoadLayers", []]);

//Route: vorberechnete Abschnitte plus das Stueck vom Spieler zum naechsten Routenpunkt
(missionNamespace getVariable ["life_nav_miniRoute", [[], [], false, [0, 0], [0,0,0,0], [0,0,0,0]]]) params ["_outline", "_route", "_fromPlayer", "_widths", "_colOut", "_colRoute"];
private _dynOut = [];
private _dynRoute = [];
private _path = missionNamespace getVariable ["life_nav_path", []];
if (_fromPlayer && {(count _path) >= 2}) then {
    private _q = _path select 1;
    private _dx = (_q select 0) - (_p select 0);
    private _dy = (_q select 1) - (_p select 1);
    private _len = sqrt ((_dx * _dx) + (_dy * _dy));
    if (_len > 0.5) then {
        private _ux = _dx / _len;
        private _uy = _dy / _len;
        {
            private _hw = _widths select _forEachIndex;
            private _nx = -_uy * _hw;
            private _ny = _ux * _hw;
            private _ax = (_p select 0);
            private _ay = (_p select 1);
            private _bx = (_q select 0) + (_ux * _hw);
            private _by = (_q select 1) + (_uy * _hw);
            _x append [
                [_ax + _nx, _ay + _ny, 1], [_ax - _nx, _ay - _ny, 1], [_bx - _nx, _by - _ny, 1],
                [_ax + _nx, _ay + _ny, 1], [_bx - _nx, _by - _ny, 1], [_bx + _nx, _by + _ny, 1]
            ];
        } forEach [_dynOut, _dynRoute];
    };
};
{
    _x params ["_verts", "_color"];
    if ((count _verts) > 2) then {_map drawTriangle [_verts matrixMultiply _m, _color, _fill];};
} forEach [[_outline, _colOut], [_dynOut, _colOut], [_route, _colRoute], [_dynRoute, _colRoute]];

//Ziel
private _target = missionNamespace getVariable ["life_nav_target", []];
if ((count _target) >= 2) then {
    private _t = ([[_target select 0, _target select 1, 1]] matrixMultiply _m) select 0;
    _map drawIcon ["\a3\ui_f\data\map\markers\military\flag_CA.paa", [0.20, 0.62, 1, 1], [_t select 0, _t select 1], 24, 24, 0, "", 0];
};

//Pfeil (zeigt immer nach oben) und Norden am Rand
(ctrlPosition _map) params ["_mx", "_my", "_mw", "_mh"];
private _center = _map ctrlMapScreenToWorld [_mx + (_mw / 2), _my + (_mh / 2)];
private _half = (_map ctrlMapScreenToWorld [_mx, _my + (_mh / 2)]) distance2D _center;
private _icon = "\a3\ui_f\data\map\markers\military\arrow2_ca.paa";
_map drawIcon [_icon, [0.03, 0.08, 0.20, 1], _canvas, 34, 34, 0, "", 0];
_map drawIcon [_icon, [1, 1, 1, 1], _canvas, 26, 26, 0, "", 0];
private _north = [(_center select 0) - (_s * _half * 0.84), (_center select 1) + (_c * _half * 0.84)];
private _clear = "#(argb,8,8,3)color(0,0,0,0)";
_map drawIcon [_clear, [0.03, 0.08, 0.20, 0.9], _north, 0, 0, 0, "N", 0, 0.052, "RobotoCondensedBold", "center"];
_map drawIcon [_clear, [1, 1, 1, 1], _north, 0, 0, 0, "N", 0, 0.045, "RobotoCondensedBold", "center"];
