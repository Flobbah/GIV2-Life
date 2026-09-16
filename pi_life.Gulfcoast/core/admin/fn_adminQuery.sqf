#include "..\..\script_macros.hpp"
/*
    File: fn_adminQuery.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Starts the query on a player.
*/
disableSerialization;
if (!isNil "admin_query_ip") exitWith {[ localize "STR_ANOTF_Query_2",true,"fast"] call life_fnc_notification_system;};
private _text = CONTROL(2900,2903);
private _info = [] call life_fnc_adminTarget;
if (isNull _info) exitWith {_text ctrlSetText localize "STR_ANOTF_QueryFail";};
["life_fnc_adminQueryReply",[player],_info] call life_fnc_relaySend;
_text ctrlSetText localize "STR_ANOTF_Query";
