/*
    File: fn_navSimplify.sqf
    Description:
    Reduziert eine Punktfolge auf die Eckpunkte (Ramer-Douglas-Peucker, iterativ). Punkte, die
    weniger als die Toleranz von der Verbindungslinie ihrer Nachbarn abweichen, fallen weg.
    Aus mehreren tausend Pfadpunkten der Pfadsuche werden so meist ein- bis zweihundert, ohne
    dass Kurven verloren gehen. Das haelt das Zeichnen der Route pro Frame billig.
    Parameter:
        0: ARRAY  - Punkte [[x,y],...]
        1: NUMBER - Toleranz in Metern (Standard 4)
    Rueckgabe:
        ARRAY - reduzierte Punkte
*/
params [["_pts",[],[[]]],["_eps",4,[0]]];
private _n = count _pts;
if (_n < 3) exitWith {_pts};
private _keep = [];
_keep resize _n;
_keep = _keep apply {false};
_keep set [0, true];
_keep set [_n - 1, true];
private _stack = [[0, _n - 1]];
while {count _stack > 0} do {
    (_stack deleteAt ((count _stack) - 1)) params ["_s", "_e"];
    if (_e - _s < 2) then {continue};
    private _a = _pts select _s;
    private _b = _pts select _e;
    private _ax = _a select 0;
    private _ay = _a select 1;
    private _dx = (_b select 0) - _ax;
    private _dy = (_b select 1) - _ay;
    private _len = sqrt (_dx * _dx + _dy * _dy);
    private _maxD = -1;
    private _idx = -1;
    for "_i" from (_s + 1) to (_e - 1) do {
        private _p = _pts select _i;
        private _d = if (_len < 0.001) then {
            _p distance2D _a
        } else {
            (abs (_dx * ((_p select 1) - _ay) - _dy * ((_p select 0) - _ax))) / _len
        };
        if (_d > _maxD) then {_maxD = _d; _idx = _i;};
    };
    if (_maxD > _eps) then {
        _keep set [_idx, true];
        _stack pushBack [_s, _idx];
        _stack pushBack [_idx, _e];
    };
};
private _out = [];
{
    if (_keep select _forEachIndex) then {_out pushBack _x;};
} forEach _pts;
_out
