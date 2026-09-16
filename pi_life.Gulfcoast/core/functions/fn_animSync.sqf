#include "..\..\script_macros.hpp"
/*
    File: fn_animSync.sqf
    Author:
    Description:
*/
RELAY_ONLY_REMOTE; //Sicherheitsphase 0.1b: Aufrufe anderer Spieler nur ueber den Server (CfgRelay)
private ["_unit","_anim"];
_unit = [_this,0,objNull,[objNull]] call BIS_fnc_param;
_anim = [_this,1,"",[""]] call BIS_fnc_param;
_cancelOwner = [_this,2,false,[true]] call BIS_fnc_param;
if (isNull _unit || {(local _unit && _cancelOwner)}) exitWith {};
_unit switchMove _anim;