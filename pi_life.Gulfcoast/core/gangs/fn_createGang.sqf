#include "..\..\script_macros.hpp"
/*
    File: fn_createGang.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Pulls up the menu and creates the gang with the name the user enters in.
*/
private ["_gangName","_length","_badChar","_chrByte","_allowed"];
disableSerialization;
_gangName = ctrlText (CONTROL(2520,2522));
_length = count (toArray(_gangName));
_chrByte = toArray (_gangName);
_allowed = toArray("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_ ");
if (_length > 32) exitWith {[ localize "STR_GNOTF_Over32",true,"fast"] call life_fnc_notification_system};
_badChar = false;
{if (!(_x in _allowed)) exitWith {_badChar = true;};} forEach _chrByte;
if (_badChar) exitWith {[ localize "STR_GNOTF_IncorrectChar",true,"fast"] call life_fnc_notification_system;};
if (BANK < (LIFE_SETTINGS(getNumber,"gang_price"))) exitWith {[ format [localize "STR_GNOTF_NotEnoughMoney",[((LIFE_SETTINGS(getNumber,"gang_price")) - BANK)] call life_fnc_numberText],true,"fast"] call life_fnc_notification_system;};
if (LIFE_HC_ACTIVE) then {
    [player,getPlayerUID player,_gangName] remoteExec ["HC_fnc_insertGang",HC_Life];
} else {
    [player,getPlayerUID player,_gangName] remoteExec ["TON_fnc_insertGang",RSERV];
};
if (LIFE_SETTINGS(getNumber,"player_advancedLog") isEqualTo 1) then {
    if (LIFE_SETTINGS(getNumber,"battlEye_friendlyLogging") isEqualTo 1) then {
        advanced_log = format [localize "STR_DL_AL_createdGang_BEF",_gangName,(LIFE_SETTINGS(getNumber,"gang_price"))];
    } else {
        advanced_log = format [localize "STR_DL_AL_createdGang",profileName,(getPlayerUID player),_gangName,(LIFE_SETTINGS(getNumber,"gang_price"))];
    };
    [advanced_log] remoteExecCall ["TON_fnc_clientLog",RSERV];
};
[ localize "STR_NOTF_SendingData",false,"fast"] call life_fnc_notification_system;
closeDialog 0;
life_action_gangInUse = true;
