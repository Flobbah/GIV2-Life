/*
    File: fn_navMiniMapFrame.sqf
    Description:
    Jedes Bild bei eingeblendeter Minikarte: zoomt abhaengig von der Geschwindigkeit weich zwischen
    spanSlow und spanFast und haelt das (nicht gedrehte) Kartensteuerelement auf der Zeichenflaeche.
    Der Spieler sitzt dort auf life_nav_miniCanvas, die Kartenmitte liegt um lookAhead darueber.
*/
disableSerialization;
private _display = uiNamespace getVariable ["life_nav_minimap", displayNull];
if (isNull _display || {!(missionNamespace getVariable ["life_nav_active", false])}) exitWith {};
private _map = _display displayCtrl 3201;
if (isNull _map) exitWith {};
private _canvas = missionNamespace getVariable ["life_nav_miniCanvas", []];
if (_canvas isEqualTo []) exitWith {};
private _cfg = missionConfigFile >> "CfgNavigation" >> "MiniMap";
private _veh = vehicle player;

//gewuenschte sichtbare Breite in Metern, weich angenaehert
private _slow = getNumber (_cfg >> "spanSlow");
private _fast = getNumber (_cfg >> "spanFast");
private _t = ((abs (speed _veh)) / ((getNumber (_cfg >> "speedFast")) max 1)) min 1;
private _target = _slow + ((_fast - _slow) * _t);
private _span = missionNamespace getVariable ["life_nav_miniSpan", _target];
_span = _span + ((_target - _span) * ((diag_deltaTime * 1.5) min 1));
life_nav_miniSpan = _span;

//aktuelle sichtbare Breite messen und den Massstab linear anpassen
(ctrlPosition _map) params ["_mx", "_my", "_mw", "_mh"];
private _scale = ctrlMapScale _map;
private _cur = (_map ctrlMapScreenToWorld [_mx, _my + (_mh / 2)]) distance2D (_map ctrlMapScreenToWorld [_mx + _mw, _my + (_mh / 2)]);
private _newScale = if (_cur > 1 && {_scale > 0}) then {((_scale * (_span / _cur)) max 0.002) min 0.2} else {0.05};
_map ctrlMapAnimAdd [0, _newScale, [_canvas select 0, (_canvas select 1) + (_span * (getNumber (_cfg >> "lookAhead")))]];
ctrlMapAnimCommit _map;
