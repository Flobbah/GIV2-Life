#include "..\..\script_macros.hpp"
/*
    File: fn_onFired.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Handles various different ammo types being fired.
*/
private ["_ammoType","_projectile"];
_ammoType = _this select 4;
_projectile = _this select 6;
if (_ammoType isEqualTo "GrenadeHand_stone") then {
    _projectile spawn {
        private "_position";
        while {!isNull _this} do {
            _position = ASLtoATL (visiblePositionASL _this);
            sleep 0.1;
        };
        ["life_fnc_flashbang",[_position],RCLIENT] call life_fnc_relaySend;
    };
};
