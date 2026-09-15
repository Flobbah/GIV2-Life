/*
    File: fn_navMiniMapGeo.sqf
    Description:
    Hintergrund-Schleife der Minikarte (einmal pro Sekunde, gespawnt): baut die Dreiecke fuer
    Strassen und Route in Weltkoordinaten als Zeilen [x, y, 1], damit fn_navMiniMapDraw sie mit einer
    einzigen Matrixmultiplikation drehen und verschieben kann.
    Strassen: nearRoads um den Spieler, getRoadInfo je Strassenstueck nur einmal (Cache
    life_nav_roadInfo), zusammenhaengende Stuecke gleicher Art zu Linien verkettet und per
    Douglas-Peucker vereinfacht. Neu gebaut, wenn sich der Spieler 120 m bewegt hat oder der Zoom
    sich deutlich aendert. Route: jede Sekunde aus life_nav_path.
    Parameter:
        0: NUMBER - Schleifen-ID; eine neuere ID beendet diese Schleife
*/
params [["_id", 0, [0]]];
private _cfg = missionConfigFile >> "CfgNavigation" >> "MiniMap";
private _rowColor = {(getArray (_cfg >> _this))};
private _minPx = [getNumber (_cfg >> "minPixelsTrack"), getNumber (_cfg >> "minPixelsRoad"), getNumber (_cfg >> "minPixelsMainRoad")];
private _roadColors = ["colorTrack", "colorRoad", "colorMainRoad"] apply {_x call _rowColor};

//Linienzug als Rechtecke (je zwei Dreiecke, an den Enden um die halbe Breite verlaengert)
private _fnc_quads = {
    params ["_pts", "_hw", "_out"];
    for "_i" from 0 to ((count _pts) - 2) do {
        private _a = _pts select _i;
        private _b = _pts select (_i + 1);
        private _dx = (_b select 0) - (_a select 0);
        private _dy = (_b select 1) - (_a select 1);
        private _len = sqrt ((_dx * _dx) + (_dy * _dy));
        if (_len > 0.01) then {
            private _ux = _dx / _len;
            private _uy = _dy / _len;
            private _nx = -_uy * _hw;
            private _ny = _ux * _hw;
            private _ax = (_a select 0) - (_ux * _hw);
            private _ay = (_a select 1) - (_uy * _hw);
            private _bx = (_b select 0) + (_ux * _hw);
            private _by = (_b select 1) + (_uy * _hw);
            _out append [
                [_ax + _nx, _ay + _ny, 1], [_ax - _nx, _ay - _ny, 1], [_bx - _nx, _by - _ny, 1],
                [_ax + _nx, _ay + _ny, 1], [_bx - _nx, _by - _ny, 1], [_bx + _nx, _by + _ny, 1]
            ];
        };
    };
};
private _fnc_key = {format ["%1:%2", round ((_this select 0) * 2), round ((_this select 1) * 2)]};

while {(missionNamespace getVariable ["life_nav_active", false]) && {_id isEqualTo (missionNamespace getVariable ["life_nav_miniGeoId", -1])}} do {
    private _display = uiNamespace getVariable ["life_nav_minimap", displayNull];
    if (!isNull _display) then {
        private _map = _display displayCtrl 3201;
        private _mapPx = ((ctrlPosition _map) select 2) / pixelW;
        private _span = missionNamespace getVariable ["life_nav_miniSpan", getNumber (_cfg >> "spanSlow")];
        private _mpp = _span / (_mapPx max 50);
        private _p = getPosVisual (vehicle player);
        private _radius = (_span * 0.75) + (_span * (getNumber (_cfg >> "lookAhead"))) + 150;

        //--- Strassen (nur bei Bedarf neu)
        (missionNamespace getVariable ["life_nav_miniRoadState", [[-1e6, -1e6], 1, 0]]) params ["_lastC", "_lastMpp", "_lastR"];
        if (((_p distance2D _lastC) > 120) || {(abs (_mpp - _lastMpp)) > (_lastMpp * 0.2)} || {_radius > (_lastR + 60)}) then {
            life_nav_miniRoadState = [[_p select 0, _p select 1], _mpp, _radius];
            private _pieces = [];
            {
                private _key = str _x;
                private _info = life_nav_roadInfo getOrDefault [_key, []];
                if (_info isEqualTo []) then {
                    private _ri = getRoadInfo _x;
                    private _cls = switch (_ri select 0) do {
                        case "MAIN ROAD": {2};
                        case "ROAD": {1};
                        case "HIDE": {-1};
                        default {0};
                    };
                    if (_ri select 2) then {_cls = -1;}; //Fusswege weglassen
                    private _b = _ri select 6;
                    private _e = _ri select 7;
                    _info = [_cls, (_ri select 1) / 2, [_b select 0, _b select 1], [_e select 0, _e select 1]];
                    life_nav_roadInfo set [_key, _info];
                };
                if ((_info select 0) >= 0) then {_pieces pushBack _info;};
            } forEach (_p nearRoads _radius);

            //Knoten: Endpunkt -> Stuecke
            private _nodes = createHashMap;
            {
                private _i = _forEachIndex;
                {
                    private _k = _x call _fnc_key;
                    private _list = _nodes getOrDefault [_k, []];
                    _list pushBack _i;
                    _nodes set [_k, _list];
                } forEach [_x select 2, _x select 3];
            } forEach _pieces;

            //Ketten: an Knoten mit genau zwei Stuecken gleicher Art weiterlaufen (Kreuzungen beenden die Kette)
            private _used = _pieces apply {false};
            private _layers = [[], [], []];
            {
                if !(_used select _forEachIndex) then {
                    private _start = _forEachIndex;
                    _used set [_start, true];
                    _x params ["_cls", "_hw", "_b", "_e"];
                    private _pts = [_b, _e];
                    private _maxHw = _hw;
                    {
                        private _forward = _x;
                        private _cur = _start;
                        private _tip = [_b, _e] select _forward;
                        private _go = true;
                        while {_go} do {
                            _go = false;
                            private _cand = _nodes getOrDefault [_tip call _fnc_key, []];
                            if ((count _cand) isEqualTo 2) then {
                                private _j = [_cand select 0, _cand select 1] select ((_cand select 0) isEqualTo _cur);
                                if (!(_used select _j) && {((_pieces select _j) select 0) isEqualTo _cls}) then {
                                    (_pieces select _j) params ["", "_hw2", "_b2", "_e2"];
                                    private _far = [_b2, _e2] select ((_b2 call _fnc_key) isEqualTo (_tip call _fnc_key));
                                    _used set [_j, true];
                                    if (_forward) then {_pts pushBack _far;} else {_pts = [_far] + _pts;};
                                    _maxHw = _maxHw max _hw2;
                                    _tip = _far;
                                    _cur = _j;
                                    _go = true;
                                };
                            };
                        };
                    } forEach [true, false];
                    _pts = [_pts, _mpp * 0.6] call life_fnc_navSimplify;
                    private _w = (_maxHw * 0.8) max (((_minPx select _cls) * _mpp) / 2);
                    [_pts, _w, _layers select _cls] call _fnc_quads;
                };
            } forEach _pieces;
            //Obergrenze fuer die Punkte pro Bild: zuerst Feldwege, dann normale Strassen weglassen
            private _maxVerts = 30000;
            if (((count (_layers select 0)) + (count (_layers select 1)) + (count (_layers select 2))) > _maxVerts) then {_layers set [0, []];};
            if (((count (_layers select 1)) + (count (_layers select 2))) > _maxVerts) then {_layers set [1, []];};
            if ((count (_layers select 2)) > _maxVerts) then {_layers set [2, (_layers select 2) select [0, _maxVerts - (_maxVerts mod 6)]];};
            life_nav_miniRoadLayers = [0, 1, 2] apply {[_layers select _x, _roadColors select _x]};
        };

        //--- Route (jede Sekunde): Abschnitte ab dem naechsten Routenpunkt, das Stueck vom Spieler
        //    dorthin zeichnet fn_navMiniMapDraw jedes Bild selbst
        private _path = +(missionNamespace getVariable ["life_nav_path", []]);
        private _fromPlayer = (count _path) >= 2 && {(_p distance2D (_path select 0)) < 250};
        private _static = if (_fromPlayer) then {_path select [1, (count _path) - 1]} else {_path};
        private _hwOut = ((getNumber (_cfg >> "pixelsRouteOutline")) * _mpp) / 2;
        private _hwRoute = ((getNumber (_cfg >> "pixelsRoute")) * _mpp) / 2;
        private _outline = [];
        private _route = [];
        if ((count _static) >= 2) then {
            [_static, _hwOut, _outline] call _fnc_quads;
            [_static, _hwRoute, _route] call _fnc_quads;
        };
        life_nav_miniRoute = [_outline, _route, _fromPlayer, [_hwOut, _hwRoute], "colorRouteOutline" call _rowColor, "colorRoute" call _rowColor];
    };
    sleep 1;
};
