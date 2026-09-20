#include "..\..\script_macros.hpp"
/*
    File: fn_houseBought.sqf
    Description:
    Sets up a house on the buyer's client after the purchase: owner, lock, containers, map marker,
    closed doors. Called locally by fn_buyHouse (EconomyMode 0) or by the server once it has booked
    the purchase (TON_fnc_addHouse, EconomyMode 1).
    Parameters:
        0: OBJECT - the house
*/
if (isRemoteExecuted && {!(remoteExecutedOwner isEqualTo 2)}) exitWith {};
params [["_house", objNull, [objNull]]];
if (isNull _house) exitWith {};
private _uid = getPlayerUID player;
_house setVariable ["house_owner",[_uid,profileName],true];
//Sicherheitsprüfung #7: "locked" setzt der Server beim Kauf (TON_fnc_addHouse)
_house setVariable ["containers",[],true];
_house setVariable ["uid",floor(random 99999),true];
life_vehicles pushBack _house;
life_houses pushBack [str(getPosATL _house),[]];
private _marker = createMarkerLocal [format ["house_%1",(_house getVariable "uid")],getPosATL _house];
private _houseName = FETCH_CONFIG2(getText,"CfgVehicles",(typeOf _house), "displayName");
_marker setMarkerTextLocal _houseName;
_marker setMarkerColorLocal "ColorBlue";
_marker setMarkerTypeLocal "loc_Lighthouse";
//Sicherheitsprüfung #7: Die Tueren hat der Server beim Kauf schon verschlossen (TON_fnc_addHouse)
