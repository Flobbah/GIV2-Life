/*
    File: fn_navMiniMap.sqf
    Description:
    Blendet die Navi-Minikarte ein oder aus (unabhaengig vom GPS-Gegenstand). Beim Einblenden:
    Layout aus CfgNavigation >> MiniMap (quadratisch in Pixeln, rechts ueber dem HUD), Draw-Handler
    fuer die gedrehte Navi-Ansicht, EachFrame-Handler fuer den Zoom, Suche einer leeren Zeichenflaeche
    (fn_navMiniMapCanvas) und die Geometrie-Schleife fuer Strassen und Route (fn_navMiniMapGeo).
    Die Engine dreht hier nichts (kein mapOrientation).
    Aufrufe: fn_navStart (ein), fn_navStop (aus), fn_navLoop (wieder ein, falls verschwunden).
    Parameter:
        0: BOOL - true = einblenden, false = ausblenden
*/
params [["_show", true, [true]]];
if (!hasInterface) exitWith {};
disableSerialization;
private _cfg = missionConfigFile >> "CfgNavigation" >> "MiniMap";
private _layer = "life_nav_minimap" call BIS_fnc_rscLayer;

if (!_show) exitWith {
    if (!isNil "life_nav_miniEH") then {
        removeMissionEventHandler ["EachFrame", life_nav_miniEH];
        life_nav_miniEH = nil;
    };
    life_nav_miniGeoId = (missionNamespace getVariable ["life_nav_miniGeoId", 0]) + 1; //Geometrie-Schleife beenden
    life_nav_miniRoadState = nil;
    _layer cutText ["", "PLAIN"];
    uiNamespace setVariable ["life_nav_minimap", displayNull];
};
if ((getNumber (_cfg >> "enabled")) isEqualTo 0) exitWith {};

private _display = uiNamespace getVariable ["life_nav_minimap", displayNull];
if (isNull _display) then {
    _layer cutRsc ["Life_NavMiniMap", "PLAIN", 0.25, false];
    _display = uiNamespace getVariable ["life_nav_minimap", displayNull];
};
if (isNull _display) exitWith {diag_log "[NAV] Minikarte konnte nicht eingeblendet werden";};

if !(_display getVariable ["life_nav_ready", false]) then {
    //Layout: Breite als Anteil des Bildschirms, Hoehe so, dass die Karte in Pixeln quadratisch ist
    private _aspect = (getResolution select 4) max 0.5;
    private _w = (getNumber (_cfg >> "size")) * safezoneW;
    private _h = (getNumber (_cfg >> "size")) * safezoneH * _aspect;
    private _infoH = 0.032 * safezoneH;
    private _accentH = 3 * pixelH;
    private _padX = 4 * pixelW;
    private _padY = 4 * pixelH;
    private _left = safezoneX + ((getNumber (_cfg >> "right")) * safezoneW) - _w;
    private _top = safezoneY + ((getNumber (_cfg >> "bottom")) * safezoneH) - (_h + _infoH);
    {
        _x params ["_idc", "_pos"];
        private _ctrl = _display displayCtrl _idc;
        if (_idc isEqualTo 3201) then {
            //Karten brauchen ctrlMapSetPosition: mit ctrlSetPosition rechnet die Karte ihre Mitte weiter
            //aus der Config-Groesse (0.1 x 0.1), der Spieler saesse dann nicht in der Mitte
            _ctrl ctrlMapSetPosition _pos;
        } else {
            _ctrl ctrlSetPosition _pos;
            _ctrl ctrlCommit 0;
        };
    } forEach [
        [3200, [_left, _top, _w, _h + _infoH]],
        [3202, [_left, _top, _w, _accentH]],
        [3201, [_left + _padX, _top + _accentH + _padY, _w - (2 * _padX), _h - _accentH - (2 * _padY)]],
        [3203, [_left + _padX, _top + _h - (1 * pixelH), _w - (2 * _padX), _infoH]]
    ];
    (_display displayCtrl 3201) ctrlAddEventHandler ["Draw", {_this call life_fnc_navMiniMapDraw;}];
    _display setVariable ["life_nav_ready", true];
    //einmalige Kontrolle im Client-RPT: Steuerelement- und Kartenposition muessen gleich sein
    [] spawn {
        sleep 3;
        disableSerialization;
        private _d = uiNamespace getVariable ["life_nav_minimap", displayNull];
        if (isNull _d) exitWith {};
        private _m = _d displayCtrl 3201;
        (ctrlPosition _m) params ["_mx", "_my", "_mw", "_mh"];
        private _k = missionNamespace getVariable ["life_nav_miniCanvas", [0, 0]];
        diag_log format ["[NAV] Minikarte Lage: ctrlPosition=%1 ctrlMapPosition=%2 Pfeil=%3 Mitte=%4", ctrlPosition _m, ctrlMapPosition _m, _m ctrlMapWorldToScreen _k, [_mx + (_mw / 2), _my + (_mh / 2)]];
    };
};

//Leere Zeichenflaeche suchen (einmal je Einblenden, im Hintergrund)
[] spawn life_fnc_navMiniMapCanvas;

if (isNil "life_nav_miniEH") then {
    life_nav_miniEH = addMissionEventHandler ["EachFrame", {[] call life_fnc_navMiniMapFrame;}];
};
life_nav_miniGeoId = (missionNamespace getVariable ["life_nav_miniGeoId", 0]) + 1;
life_nav_miniRoadState = nil;
[life_nav_miniGeoId] spawn life_fnc_navMiniMapGeo;
