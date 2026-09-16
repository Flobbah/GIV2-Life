#include "..\..\script_macros.hpp"
/*
    File: fn_tazed.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Starts the tazed animation and broadcasts out what it needs to.
*/
private ["_curWep","_curMags","_attach"];
params [
    ["_unit",objNull,[objNull]],
    ["_shooter",objNull,[objNull]]
];
if (isNull _unit || isNull _shooter) exitWith {player allowDamage true; life_istazed = false;};
if (_shooter isKindOf "CAManBase" && alive player) then {
    if (!life_istazed) then {
        life_istazed = true;
        player allowDamage false;
        _curWep = currentWeapon player;
        _curMags = magazines player;
        _attach = if (!(primaryWeapon player isEqualTo "")) then {primaryWeaponItems player} else {[]};
        {player removeMagazine _x} forEach _curMags;
        player removeWeapon _curWep;
        player addWeapon _curWep;
        if (!(count _attach isEqualTo 0) && !(primaryWeapon player isEqualTo "")) then {
            {
                _unit addPrimaryWeaponItem _x;
            } forEach _attach;
        };
        if (!(count _curMags isEqualTo 0)) then {
            {player addMagazine _x;} forEach _curMags;
        };
        ["life_fnc_say3D",[_unit,"tazerSound",100,1],RCLIENT] call life_fnc_relaySend;
        _obj = "Land_ClutterCutter_small_F" createVehicle ASLTOATL(visiblePositionASL player);
        _obj setPosATL ASLTOATL(visiblePositionASL player);
        ["life_fnc_animSync",[player,"AinjPfalMstpSnonWnonDf_carried_fallwc"],RCLIENT] call life_fnc_relaySend;
        ["life_fnc_broadcast",[0,"STR_NOTF_Tazed",true,[profileName, _shooter getVariable ["realname",name _shooter]]],RCLIENT] call life_fnc_relaySend;
        _unit attachTo [_obj,[0,0,0]];
        disableUserInput true;
        ["life_fnc_animSync",[player,"AmovPpneMstpSrasWrflDnon"],RCLIENT] call life_fnc_relaySend;
        if (!(player getVariable ["Escorting",false])) then {
            detach player;
        };
        sleep 15;
        life_istazed = false;
        player allowDamage true;
        disableUserInput false;
    };
} else {
    _unit allowDamage true;
    life_istazed = false;
};
