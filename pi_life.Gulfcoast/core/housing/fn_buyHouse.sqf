#include "..\..\script_macros.hpp"
/*
    File: fn_buyHouse.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Buys the house?
*/
private ["_house","_uid","_action","_houseCfg"];
_house = param [0,objNull,[objNull]];
_uid = getPlayerUID player;
if (isNull _house) exitWith {};
if (!(_house isKindOf "House_F")) exitWith {};
if (_house getVariable ["house_owned",false]) exitWith {[ localize "STR_House_alreadyOwned",true,"fast"] call life_fnc_notification_system;};
if (!isNil {(_house getVariable "house_sold")}) exitWith {[ localize "STR_House_Sell_Process",true,"fast"] call life_fnc_notification_system};
if (!license_civ_home) exitWith {[ localize "STR_House_License",true,"fast"] call life_fnc_notification_system};
if (count life_houses >= (LIFE_SETTINGS(getNumber,"house_limit"))) exitWith {[ format [localize "STR_House_Max_House",LIFE_SETTINGS(getNumber,"house_limit")],true,"fast"] call life_fnc_notification_system};
closeDialog 0;
_houseCfg = [(typeOf _house)] call life_fnc_houseConfig;
if (count _houseCfg isEqualTo 0) exitWith {};
_action = [
    format [localize "STR_House_BuyMSG",
    [(_houseCfg select 0)] call life_fnc_numberText,
    (_houseCfg select 1)],localize "STR_House_Purchase",localize "STR_Global_Buy",localize "STR_Global_Cancel"
] call BIS_fnc_guiMessage;
if (_action) then {
    if (BANK < (_houseCfg select 0)) exitWith {[ format [localize "STR_House_NotEnough"],true,"fast"] call life_fnc_notification_system};
    if (ECONOMY_MODE >= 1) exitWith {
        //Geld-Umbau Schritt 2: der Server bucht und ruft danach life_fnc_houseBought auf
        [_uid,_house] remoteExec ["TON_fnc_addHouse",RSERV];
    };
    BANK = BANK - (_houseCfg select 0);
    [1] call SOCK_fnc_updatePartial;
    if (LIFE_HC_ACTIVE) then {
        [_uid,_house] remoteExec ["HC_fnc_addHouse",HC_Life];
    } else {
        [_uid,_house] remoteExec ["TON_fnc_addHouse",RSERV];
    };
    if (LIFE_SETTINGS(getNumber,"player_advancedLog") isEqualTo 1) then {
        if (LIFE_SETTINGS(getNumber,"battlEye_friendlyLogging") isEqualTo 1) then {
            advanced_log = format [localize "STR_DL_AL_boughtHouse_BEF",[(_houseCfg select 0)] call life_fnc_numberText,[BANK] call life_fnc_numberText,[CASH] call life_fnc_numberText];
        } else {
            advanced_log = format [localize "STR_DL_AL_boughtHouse",profileName,(getPlayerUID player),[(_houseCfg select 0)] call life_fnc_numberText,[BANK] call life_fnc_numberText,[CASH] call life_fnc_numberText];
        };
        [advanced_log] remoteExecCall ["TON_fnc_clientLog",RSERV];
    };
    [_house] call life_fnc_houseBought;
};
