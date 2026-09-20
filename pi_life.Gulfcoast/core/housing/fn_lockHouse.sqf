#include "..\..\script_macros.hpp"
/*
    File: fn_lockHouse.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Unlocks / locks the house.
*/
private ["_house"];
_house = param [0,objNull,[objNull]];
if (isNull _house || !(_house isKindOf "House_F")) exitWith {};
//Sicherheitsprüfung #7: das Lagerschloss schaltet der Server, er kennt den Besitzer
_state = _house getVariable ["locked",true];
[_house, 0, [1, 0] select _state, "storage"] remoteExecCall ["TON_fnc_houseDoor",RSERV];
titleText[localize (["STR_House_StorageLock", "STR_House_StorageUnlock"] select _state),"PLAIN"];