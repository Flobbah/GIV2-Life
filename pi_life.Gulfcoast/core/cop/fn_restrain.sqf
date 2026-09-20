#include "..\..\script_macros.hpp"
/*
    File: fn_restrain.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Restrains the client.
*/
RELAY_ONLY_REMOTE; //Sicherheitsphase 0.1b: Aufrufe anderer Spieler nur ueber den Server (CfgRelay)
private ["_cop","_player","_vehicle"];
_cop = [_this,0,objNull,[objNull]] call BIS_fnc_param;
_player = player;
_vehicle = vehicle player;
if (isNull _cop) exitWith {};
//Sicherheitsprüfung #7: Die vergessene Festnahme beendet der Server (TON_fnc_custodyWatch).
//Frueher lief die Uhr hier im Client des Gefesselten - ein Cheater musste die Bedingung nur
//erfuellen, um sich selbst zu befreien. Die Schleife unten merkt es, sobald der Server loest.
titleText[format [localize "STR_Cop_Restrained",_cop getVariable ["realname",name _cop]],"PLAIN"];
life_disable_getIn = true;
life_disable_getOut = false;
while {player getVariable  "restrained"} do {
    if (isNull objectParent player) then {
        player playMove "AmovPercMstpSnonWnonDnon_Ease";
    };
    _state = vehicle player;
    waitUntil {animationState player != "AmovPercMstpSnonWnonDnon_Ease" || !(player getVariable "restrained") || vehicle player != _state};
    //Der Tod beendet den Gewahrsam - eintragen tut das der Server
    if (!alive player) exitWith {detach _player};
    //Stirbt der begleitende Polizist, loest der Server das Begleiten (TON_fnc_custodyWatch)
    if (!alive _cop) then {detach player};
    if (!(isNull objectParent player) && life_disable_getIn) then {
        player action["eject",vehicle player];
    };
    if (!(isNull objectParent player) && !(vehicle player isEqualTo _vehicle)) then {
        _vehicle = vehicle player;
    };
    if (isNull objectParent player && life_disable_getOut) then {
        player moveInCargo _vehicle;
    };
    if (!(isNull objectParent player) && life_disable_getOut && (driver (vehicle player) isEqualTo player)) then {
        player action["eject",vehicle player];
        player moveInCargo _vehicle;
    };
    if (!(isNull objectParent player) && life_disable_getOut) then {
        _turrets = [[-1]] + allTurrets _vehicle;
        {
            if (_vehicle turretUnit [_x select 0] isEqualTo player) then {
                player action["eject",vehicle player];
                sleep 1;
                player moveInCargo _vehicle;
            };
        }forEach _turrets;
    };
};
//disableUserInput false;
if (alive player) then {
    player switchMove "AmovPercMstpSlowWrflDnon_SaluteIn";
    detach player;
};
