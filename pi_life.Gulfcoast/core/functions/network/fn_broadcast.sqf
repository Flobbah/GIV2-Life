#include "..\..\..\script_macros.hpp"
/*
    File: fn_broadcast.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Broadcast system used in the life mission for multi-notification purposes.
*/
RELAY_ONLY_REMOTE; //Sicherheitsphase 0.1b: Aufrufe anderer Spieler nur ueber den Server (CfgRelay)
params [
    ["_type", 0, [0, []]],
    ["_message", "", [""]],
    ["_localize", false, [false]],
    ["_arr", [], [[]]]
];
if (_message isEqualTo "") exitWith {};
if (_localize) exitWith {
    private _msg = switch (count _arr) do {
        case 0: {localize _message;};
        case 1: {format [localize _message,_arr select 0];};
        case 2: {format [localize _message,_arr select 0, _arr select 1];};
        case 3: {format [localize _message,_arr select 0, _arr select 1, _arr select 2];};
        case 4: {format [localize _message,_arr select 0, _arr select 1, _arr select 2, _arr select 3];};
    };
    if (_type isEqualType []) then {
        {
            switch (_x) do {
                case 0: {[ _msg,false,"fast"] call life_fnc_notification_system;}; // frueher grauer systemChat
                case 1: {[ _msg,false,"fast"] call life_fnc_notification_system;};
                case 2: {titleText[_msg,"PLAIN"];};
            };
            true
        } count _type;
    } else {
        switch (_type) do {
            case 0: {[ _msg,false,"fast"] call life_fnc_notification_system;}; // frueher grauer systemChat
            case 1: {[ _msg,false,"fast"] call life_fnc_notification_system;};
            case 2: {titleText[_msg,"PLAIN"];};
        };
    };
};
if (_type isEqualType []) then {
    {
        switch (_x) do {
            case 0: {[ format ["%1", _message],false,"fast"] call life_fnc_notification_system}; // frueher grauer systemChat
            case 1: {[ format ["%1", _message],false,"fast"] call life_fnc_notification_system};
            case 2: {titleText[format ["%1",_message],"PLAIN"];};
            case 3: {[ parseText format ["%1", _message],false,"fast"] call life_fnc_notification_system};
        };
        true
    } count _type;
} else {
    switch (_type) do {
        case 0: {[ format ["%1", _message],false,"fast"] call life_fnc_notification_system}; // frueher grauer systemChat
        case 1: {[ format ["%1", _message],false,"fast"] call life_fnc_notification_system};
        case 2: {titleText[format ["%1",_message],"PLAIN"];};
        case 3: {[ parseText format ["%1", _message],false,"fast"] call life_fnc_notification_system};
    };
};
