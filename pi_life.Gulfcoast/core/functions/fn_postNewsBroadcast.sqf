#include "..\..\script_macros.hpp"
/*
    File: fn_postNewsBroadcast.sqf
    Author: Jesse "tkcjesse" Schultz
    Description:
    Handles actions after the broadcast button is clicked.
*/
private ["_broadcastHeader","_broadcastMessage","_length","_badCharacter","_characterByte","_allowed","_allowedLength"];
disableSerialization;
_broadcastHeader = ctrlText (CONTROL(100100,100101));
_broadcastMessage = ctrlText (CONTROL(100100,100102));
_length = count (toArray (_broadcastHeader));
_characterByte = toArray (_broadcastHeader);
_allowed = toArray("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_ ");
_allowedLength = LIFE_SETTINGS(getNumber,"news_broadcast_header_length");
_badCharacter = false;
if (_length > _allowedLength) exitWith {[ format [localize "STR_News_HeaderLength",_allowedLength],true,"fast"] call life_fnc_notification_system;};
{
    if (!(_x in _allowed)) exitWith {_badCharacter = true;};
} forEach _characterByte;
if (_badCharacter) exitWith {[ localize "STR_News_UnsupportedCharacter",true,"fast"] call life_fnc_notification_system};
if (ECONOMY_MODE >= 1) exitWith {
    //Geld-Umbau Schritt 2: Gebuehr und Wartezeit prueft der Server, gesendet wird nach seiner Zusage
    ["TON_fnc_econFee", ["news"], {
        (_this select 1) params ["_header", "_message"];
        [_header,_message,profileName] remoteExec ['life_fnc_AAN',-2];
        life_broadcastTimer = time;
        publicVariable "life_broadcastTimer";
    }, {
        if (((_this select 0) param [0, ""]) isEqualTo "money") then {
            [ format [localize "STR_News_NotEnough",[(_this select 0) param [1, 0]] call life_fnc_numberText],true,"fast"] call life_fnc_notification_system;
        } else {
            [ localize "STR_NOTF_ActionDelay",true,"fast"] call life_fnc_notification_system;
        };
    }, [_broadcastHeader, _broadcastMessage]] call life_fnc_econRequest;
};
[_broadcastHeader,_broadcastMessage,profileName] remoteExec ['life_fnc_AAN',-2];
CASH = CASH - LIFE_SETTINGS(getNumber,"news_broadcast_cost");
[0] call SOCK_fnc_updatePartial;
life_broadcastTimer = time;
publicVariable "life_broadcastTimer";