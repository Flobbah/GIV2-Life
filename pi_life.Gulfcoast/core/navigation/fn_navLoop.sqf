#include "..\..\script_macros.hpp"
/*
    File: fn_navLoop.sqf
    Description:
    Laeuft, solange eine Navigation aktiv ist: aktualisiert alle 2 Sekunden die Entfernung im HUD
    (Reststrecke entlang der Route), berechnet die Route neu, wenn der Spieler sie verlassen hat,
    und beendet die Navigation bei Ankunft (nicht beim Lieferauftrag, der endet mit der Lieferung)
    oder Tod.
*/
disableSerialization;
private _myLoop = life_nav_loopId; //jede Navigation hat eine eigene Schleife, aeltere enden von selbst
private _lastCalc = time;
while {life_nav_active && {_myLoop isEqualTo life_nav_loopId}} do {
    if (!alive player) exitWith {[] call life_fnc_navStop;};
    [] call life_fnc_navHookMinimap;
    if (isNull (uiNamespace getVariable ["life_nav_minimap", displayNull])) then {[true] call life_fnc_navMiniMap;};
    private _me = getPosATL player;
    private _mx = _me select 0;
    private _my = _me select 1;
    private _direct = _me distance2D life_nav_target;
    //Naechsten Routenabschnitt suchen (Abstand Punkt-Strecke) und passierte Abschnitte abschneiden,
    //damit die Linie wie bei einem Navi hinter dem Spieler verschwindet
    private _path = life_nav_path;
    private _nearSeg = 0;
    private _nearDist = 1e9;
    private _nearT = 0;
    for "_i" from 0 to (count _path) - 2 do {
        private _a = _path select _i;
        private _b = _path select (_i + 1);
        private _ax = _a select 0; private _ay = _a select 1;
        private _dx = (_b select 0) - _ax; private _dy = (_b select 1) - _ay;
        private _l2 = _dx * _dx + _dy * _dy;
        private _t = if (_l2 < 0.001) then {0} else {(((_mx - _ax) * _dx + (_my - _ay) * _dy) / _l2) max 0 min 1};
        private _px = _ax + _t * _dx; private _py = _ay + _t * _dy;
        private _d = sqrt ((_mx - _px) * (_mx - _px) + (_my - _py) * (_my - _py));
        if (_d < _nearDist) then {_nearDist = _d; _nearSeg = _i; _nearT = _t;};
    };
    if (count _path < 2) then {_nearDist = _direct;};
    if (_nearDist < 120 && {count _path > 2}) then {
        //Alles vor dem aktuellen Abschnitt verwerfen; ist der Abschnitt schon fast durchfahren, auch ihn
        private _cut = if (_nearT > 0.9) then {_nearSeg + 1} else {_nearSeg};
        if (_cut > 0 && {_cut < (count _path) - 1}) then {
            _path = _path select [_cut, (count _path) - _cut];
            life_nav_path = _path;
            _nearSeg = 0;
        };
    };
    //Reststrecke: vom Spieler zum naechsten Routenpunkt und von dort entlang der Route
    private _remaining = 0;
    for "_i" from (_nearSeg + 1) to (count _path) - 2 do {
        _remaining = _remaining + ((_path select _i) distance2D (_path select (_i + 1)));
    };
    if (count _path > _nearSeg + 1) then {_remaining = _remaining + (_me distance2D (_path select (_nearSeg + 1)));};
    if (_remaining < _direct) then {_remaining = _direct;};
    private _ctrl = LIFEctrl(30);
    if (!isNull _ctrl) then {
        _ctrl ctrlSetStructuredText parseText format ["<t align='center' size='0.95'><t color='#33A0FF'>%1</t>  %2  <t color='#BBBBBB'>%3</t></t>",
            localize "STR_NAV_HudPrefix", life_nav_label, [_remaining] call life_fnc_navDistText];
    };
    private _mini = uiNamespace getVariable ["life_nav_minimap", displayNull];
    if (!isNull _mini) then {
        (_mini displayCtrl 3203) ctrlSetStructuredText parseText format ["<t size='0.9'><t font='RobotoCondensedBold'>%1</t>  <t color='#b8bcc6'>%2</t></t>",
            [_remaining] call life_fnc_navDistText, (life_nav_label splitString "<>&") joinString ""];
    };
    //Ankunft
    if (_direct < 35 && {!life_nav_isDelivery}) exitWith {
        [ format [localize "STR_NAV_Arrived",life_nav_label],false,"fast"] call life_fnc_notification_system;
        [] call life_fnc_navStop;
    };
    //Route verlassen (weiter als 200 m vom naechsten Routenpunkt) -> neu berechnen, hoechstens alle 10 s
    if (_nearDist > 200 && {(time - _lastCalc) > 10} && {_direct > 60}) then {
        _lastCalc = time;
        [false] call life_fnc_navCalc;
    };
    sleep 1;
};
