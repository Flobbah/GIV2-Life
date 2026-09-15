/*
    File: fn_navMiniMapCanvas.sqf
    Description:
    Sucht eine Stelle der Welt, an der im Umkreis kein Kartenmarker liegt, bevorzugt auf dem Wasser.
    Dort zeigt das (nicht gedrehte) Kartensteuerelement der Minikarte hin, und fn_navMiniMapDraw
    zeichnet die gedrehte Navi-Ansicht darauf. Engine-Marker, Aufgaben und Einheitensymbole liegen
    an ihren echten Positionen und bleiben so ausserhalb des Bildes.
    Ergebnis: life_nav_miniCanvas = [x, y]. Muss gespawnt werden.
*/
private _minFree = 1400;   //Sichtradius bei voll herausgezoomter Karte plus Reserve
private _markers = allMapMarkers apply {getMarkerPos _x};
private _best = [];
private _bestScore = -1;
private _step = 1000;
private _edge = 1200;
for "_gx" from _edge to (worldSize - _edge) step _step do {
    for "_gy" from _edge to (worldSize - _edge) step _step do {
        private _p = [_gx, _gy];
        private _free = 1e6;
        {
            private _d = _p distance2D _x;
            if (_d < _free) then {_free = _d;};
            if (_free < _minFree) exitWith {};
        } forEach _markers;
        private _score = _free min 5000;
        if (surfaceIsWater _p) then {_score = _score + 2000;};
        if (_score > _bestScore) then {_bestScore = _score; _best = _p;};
    };
    sleep 0.01;
};
if (_best isEqualTo []) then {_best = [worldSize / 2, _edge];};
life_nav_miniCanvas = _best;
