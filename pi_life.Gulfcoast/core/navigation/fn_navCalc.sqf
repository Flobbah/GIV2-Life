#include "..\..\script_macros.hpp"
/*
    File: fn_navCalc.sqf
    Description:
    Berechnet die Route von der aktuellen Spielerposition zum Navigationsziel ueber das
    Strassennetz (Arma-Pfadsuche fuer Fahrzeuge). Das Ergebnis kommt asynchron ueber das
    Ereignis "PathCalculated" und landet in life_nav_path. Findet die Pfadsuche nichts, bleibt
    die Luftlinie stehen.
    Parameter:
        0: BOOL - true = nach der Berechnung eine Meldung mit der Routenlaenge anzeigen
*/
params [["_notify",false,[false]]];
if !(missionNamespace getVariable ["life_nav_active",false]) exitWith {};
life_nav_calcId = life_nav_calcId + 1;
private _id = life_nav_calcId;
private _from = getPosATL player;
private _to = life_nav_target;
//Unscheduled ausfuehren, damit der Handler sicher vor dem Ergebnis haengt
isNil {
    private _agent = calculatePath ["car", "safe", _from, _to];
    _agent setVariable ["life_nav_id", _id];
    _agent setVariable ["life_nav_notify", _notify];
    _agent addEventHandler ["PathCalculated", {
        params ["_agent", "_path"];
        //Das Ereignis kann fuer denselben Agenten mehrfach kommen (zuletzt mit leerem Pfad):
        //nur das erste brauchbare Ergebnis verwenden
        if (_agent getVariable ["life_nav_done", false]) exitWith {};
        private _id = _agent getVariable ["life_nav_id", -1];
        private _notify = _agent getVariable ["life_nav_notify", false];
        if !(missionNamespace getVariable ["life_nav_active", false]) exitWith {};
        if !(_id isEqualTo life_nav_calcId) exitWith {}; //veraltete Berechnung
        private _pts = _path apply {[_x select 0, _x select 1]};
        //Ende exakt auf das Ziel legen
        _pts pushBack [life_nav_target select 0, life_nav_target select 1];
        private _len = 0;
        for "_i" from 0 to (count _pts) - 2 do {
            _len = _len + ((_pts select _i) distance2D (_pts select (_i + 1)));
        };
        //Leeres oder unbrauchbares Ergebnis (weniger als zwei Punkte oder kuerzer als 1 m): ignorieren
        if (count _path < 2 || {_len < 1}) exitWith {
            if (_notify && {(player distance2D life_nav_target) > 50}) then {
                _agent setVariable ["life_nav_done", true];
                [ localize "STR_NAV_NoRouteFound",true,"fast"] call life_fnc_notification_system;
                [_agent] spawn {sleep 0.5; deleteVehicle (_this select 0);};
            };
        };
        _agent setVariable ["life_nav_done", true];
        [_agent] spawn {sleep 0.5; deleteVehicle (_this select 0);};
        //Punkte reduzieren (im Hintergrund, damit kein Frame haengt), dann uebernehmen
        [_pts, _len, _notify, _id] spawn {
            params ["_pts", "_len", "_notify", "_id"];
            private _simple = [_pts, 4] call life_fnc_navSimplify;
            if !(missionNamespace getVariable ["life_nav_active", false]) exitWith {};
            if !(_id isEqualTo life_nav_calcId) exitWith {};
            life_nav_path = _simple;
            life_nav_routeLen = _len;
            if (_notify) then {
                [ format [localize "STR_NAV_Calculated",[_len] call life_fnc_navDistText],false,"fast"] call life_fnc_notification_system;
            };
        };
    }];
};
