#include "..\..\script_macros.hpp"
/*
    File: fn_adminMarkers.sqf
    Author: Jason_000
    Description: Display markers for all players.
    Markers are created once per player and only moved afterwards
    (instead of being deleted and re-created twice a second).
*/
params [
    ["_reOpen", false, [false]]
];
if (FETCH_CONST(life_adminlevel) < 4) exitWith {closeDialog 0; [ localize "STR_ANOTF_ErrorLevel",true,"fast"] call life_fnc_notification_system;};
life_markers_active = true;
if !(_reOpen) then {
    life_markers = !life_markers;
    [ localize (["STR_ANOTF_MDisabled", "STR_ANOTF_MEnabled"] select life_markers),false,"fast"] call life_fnc_notification_system;
};
private _markers = []; //[markerName, unit]
while {life_markers && {life_markers_active}} do {
    private _players = allPlayers - entities "HeadlessClient_F";
    //Remove markers of players that left
    for "_i" from (count _markers) - 1 to 0 step -1 do {
        private _entry = _markers select _i;
        if !((_entry select 1) in _players) then {
            deleteMarkerLocal (_entry select 0);
            _markers deleteAt _i;
        };
    };
    //Create / move markers
    {
        private _unit = _x;
        private _index = _markers findIf {(_x select 1) isEqualTo _unit};
        if (_index isEqualTo -1) then {
            private _colour = switch (SIDE_OF(_unit)) do {
                case west: {"colorBLUFOR"};
                case independent: {"colorIndependent"};
                case east: {"colorOPFOR"};
                default {"colorCivilian"};
            };
            private _name = format ["life_adminMarker_%1",getPlayerUID _unit];
            createMarkerLocal [_name, visiblePosition _unit];
            _name setMarkerTypeLocal "mil_dot";
            _name setMarkerColorLocal _colour;
            _name setMarkerTextLocal (_unit getVariable ["realname",name _unit]);
            _markers pushBack [_name,_unit];
        } else {
            ((_markers select _index) select 0) setMarkerPosLocal (visiblePosition _unit);
        };
    } forEach _players;
    sleep 0.5;
};
{deleteMarkerLocal (_x select 0)} forEach _markers;
