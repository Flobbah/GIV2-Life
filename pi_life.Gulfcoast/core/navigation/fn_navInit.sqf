/*
    File: fn_navInit.sqf
    Description:
    Initialisiert das Navigationssystem beim Client-Start: Standardwerte, den gemeinsamen
    Zeichen-Code (Route als dicke Linie, Ziel als Fahne) und dessen Anbindung an die Hauptkarte
    (Display 12, Steuerelement 51). Die GPS-Kaertchen (RscMiniMap zu Fuss, RscCustomInfoMiniMap
    im Fahrzeug) werden laufend aus fn_navLoop angebunden, weil Arma sie neu erzeugt.
    Wird einmal aus core\init.sqf aufgerufen.
*/
if (!hasInterface) exitWith {};
life_nav_active = false;
life_nav_path = [];
life_nav_target = [0,0,0];
life_nav_label = "";
life_nav_isDelivery = false;
life_nav_calcId = 0;
life_nav_loopId = 0;
life_nav_routeLen = 0;
life_nav_task = taskNull;
life_nav_roadInfo = createHashMap; //Cache getRoadInfo je Strassenstueck fuer die Minikarte
life_nav_miniGeoId = 0;
life_nav_drawCode = {
    if !(missionNamespace getVariable ["life_nav_active",false]) exitWith {};
    params ["_map"];
    private _path = life_nav_path;
    if (count _path < 1) exitWith {};
    //Linie beginnt an der aktuellen Position, sobald der Spieler nah an der Route ist
    private _me = visiblePosition player;
    if ((_me distance2D (_path select 0)) < 250) then {
        _path = [[_me select 0, _me select 1]] + (_path select [1, (count _path) - 1]);
        if (count _path < 2) then {_path = [[_me select 0, _me select 1], [life_nav_target select 0, life_nav_target select 1]];};
    };
    if (count _path < 2) exitWith {};
    //Breite der Linie in Bildschirmpixeln, unabhaengig vom Zoom: Meter pro Pixel bestimmen
    private _mpp = (_map ctrlMapScreenToWorld [0.5, 0.5]) distance2D (_map ctrlMapScreenToWorld [0.5 + pixelW, 0.5]);
    private _offsets = [-2, -1, 0, 1, 2] apply {_x * _mpp};
    private _outline = [0.02, 0.10, 0.30, 0.9];
    private _color = [0.20, 0.62, 1, 1];
    //Nur Abschnitte zeichnen, die den sichtbaren Kartenausschnitt beruehren
    (ctrlPosition _map) params ["_cx", "_cy", "_cw", "_ch"];
    private _x0 = _cx - 0.1 * _cw; private _x1 = _cx + 1.1 * _cw;
    private _y0 = _cy - 0.1 * _ch; private _y1 = _cy + 1.1 * _ch;
    private _inside = _path apply {
        private _s = _map ctrlMapWorldToScreen _x;
        (_s select 0) >= _x0 && {(_s select 0) <= _x1} && {(_s select 1) >= _y0} && {(_s select 1) <= _y1}
    };
    for "_i" from 0 to (count _path) - 2 do {
        if (!(_inside select _i) && {!(_inside select (_i + 1))}) then {continue};
        private _a = _path select _i;
        private _b = _path select (_i + 1);
        private _dx = (_b select 0) - (_a select 0);
        private _dy = (_b select 1) - (_a select 1);
        private _len = sqrt (_dx * _dx + _dy * _dy);
        if (_len < 0.01) then {continue};
        private _nx = -_dy / _len;
        private _ny = _dx / _len;
        {
            private _c = if (abs _x > 1.5 * _mpp) then {_outline} else {_color};
            _map drawLine [[(_a select 0) + _nx * _x, (_a select 1) + _ny * _x], [(_b select 0) + _nx * _x, (_b select 1) + _ny * _x], _c];
        } forEach _offsets;
    };
    _map drawIcon ["\a3\ui_f\data\map\markers\military\flag_CA.paa", [0.20, 0.62, 1, 1], life_nav_target, 26, 26, 0, life_nav_label, 1, 0.045, "RobotoCondensed", "right"];
};
[] spawn {
    disableSerialization;
    waitUntil {!isNull (findDisplay 12)};
    private _map = (findDisplay 12) displayCtrl 51;
    if (isNull _map) exitWith {diag_log "[NAV] Kartensteuerelement 51 nicht gefunden";};
    _map ctrlAddEventHandler ["Draw", life_nav_drawCode];
};
