#include "\life_server\script_macros.hpp"
/*
    File: fn_manageSC.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    User management of whether or not they want to be on a sidechat for their side.
*/
private ["_unit","_bool","_side"];
_unit = [_this,0,objNull,[objNull]] call BIS_fnc_param;
_bool = [_this,1,false,[false]] call BIS_fnc_param;
_side = [_this,2,civilian,[west]] call BIS_fnc_param;
if (isNull _unit) exitWith {};
//Sicherheitsphase 0.1: nur eigene Einheit; beitreten nur dem Kanal der eigenen Fraktion
if !([CALLER_OWNER, _unit, "", ([sideUnknown, _side] select _bool), "TON_fnc_manageSC"] call TON_fnc_checkCaller) exitWith {};
//Sicherheitsphase 0.2 Welle 2: Kanal-Nummer aus dem Serverspeicher
private _channelVar = switch (_side) do {case west: {"life_radio_west"}; case independent: {"life_radio_indep"}; default {"life_radio_civ"}};
private _channel = localNamespace getVariable [_channelVar, -1];
if (_channel < 0) exitWith {};
if (_bool) then {
    _channel radioChannelAdd [_unit];
} else {
    _channel radioChannelRemove [_unit];
};