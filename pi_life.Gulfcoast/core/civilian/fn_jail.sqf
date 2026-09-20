#include "..\..\script_macros.hpp"
/*
    File: fn_jail.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Starts the initial process of jailing.
*/
RELAY_ONLY_REMOTE; //Sicherheitsphase 0.1b: Aufrufe anderer Spieler nur ueber den Server (CfgRelay)
private ["_illegalItems"];
params [
    ["_unit",objNull,[objNull]],
    ["_bad",false,[false]]
];
if (isNull _unit) exitWith {}; //Dafuq?
if !(_unit isEqualTo player) exitWith {}; //Dafuq?
if (life_is_arrested) exitWith {}; //Dafuq i'm already arrested
_illegalItems = LIFE_SETTINGS(getArray,"jail_seize_vItems");
//Sicherheitsprüfung #7: den Gewahrsam beendet der Server, sobald der Polizist einliefert
titleText[localize "STR_Jail_Warn","PLAIN"];
[ localize "STR_Jail_LicenseNOTF",true,"fast"] call life_fnc_notification_system;
player setPos (getMarkerPos "jail_marker");
if (_bad) then {
    waitUntil {alive player};
    sleep 1;
};
//Check to make sure they goto check
if (player distance (getMarkerPos "jail_marker") > 40) then {
    player setPos (getMarkerPos "jail_marker");
};
[1] call life_fnc_removeLicenses;
{
    _amount = ITEM_VALUE(_x);
    if (_amount > 0) then {
        [false,_x,_amount] call life_fnc_handleInv;
    };
} forEach _illegalItems;
life_is_arrested = true;
if (LIFE_SETTINGS(getNumber,"jail_seize_inventory") isEqualTo 1) then {
    [] spawn life_fnc_seizeClient;
} else {
    removeAllWeapons player;
    {player removeMagazine _x} forEach (magazines player);
};
if (LIFE_HC_ACTIVE) then {
    [player,_bad] remoteExecCall ["HC_fnc_jailSys",HC_Life];
} else {
    [player,_bad] remoteExecCall ["life_fnc_jailSys",RSERV];
};
[5] call SOCK_fnc_updatePartial;
