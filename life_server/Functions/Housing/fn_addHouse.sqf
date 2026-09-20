#include "\life_server\script_macros.hpp"
/*
    File: fn_addHouse.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Inserts the players newly bought house in the database.
*/
private ["_housePos","_query"];
params [
    ["_uid","",[""]],
    ["_house",objNull,[objNull]]
];
if (isNull _house || _uid isEqualTo "") exitWith {};
private _caller = CALLER_OWNER; //Sicherheitsphase 0.1: Absender pruefen
if !([_caller, objNull, _uid, sideUnknown, "TON_fnc_addHouse"] call TON_fnc_checkCaller) exitWith {};
if (!(_caller isEqualTo 2) && {((([_caller] call TON_fnc_callerInfo) param [1, objNull]) distance _house) > 100} && {[_caller, "TON_fnc_addHouse", "house too far from the buyer"] call TON_fnc_denyCaller}) exitWith {};
if (!(_caller isEqualTo 2) && {!(([_house, "house_owner", []] call TON_fnc_serverGet) isEqualTo [])} && {[_caller, "TON_fnc_addHouse", "house is already owned"] call TON_fnc_denyCaller}) exitWith {};
//Geld-Umbau Schritt 2: Preis (Config_Housing/Config_Garages), Hauslimit und Abbuchung prueft der Server
private _econDeny = "";
if (ECONOMY_MODE >= 1 && {!(_caller isEqualTo 2)}) then {
    private _price = ([typeOf _house] call life_fnc_houseConfig) param [0, -1];
    private _owned = ([format ["SELECT COUNT(*) FROM houses WHERE pid='%1' AND owned='1'", _uid], 2] call DB_fnc_asyncCall) param [0, 0];
    if (_price <= 0) exitWith {_econDeny = "STR_House_alreadyOwned"};
    if (_owned >= LIFE_SETTINGS(getNumber,"house_limit")) exitWith {_econDeny = "STR_House_Max_House"};
    if !([_uid, "bank", -_price, "house_buy", "", typeOf _house] call TON_fnc_moneyChange) then {_econDeny = "STR_House_NotEnough"};
};
if !(_econDeny isEqualTo "") exitWith {
    [_econDeny, [LIFE_SETTINGS(getNumber,"house_limit")], true] remoteExecCall ["life_fnc_econResult", _caller];
};
_housePos = getPosATL _house;
_query = format ["INSERT INTO houses (pid, pos, owned) VALUES('%1', '%2', '1')",_uid,_housePos];
if (EXTDB_SETTING(getNumber,"DebugMode") isEqualTo 1) then {
    diag_log format ["Query: %1",_query];
};
[_query,1] call DB_fnc_asyncCall;
uiSleep 0.3;
_query = format ["SELECT id FROM houses WHERE pos='%1' AND pid='%2' AND owned='1'",_housePos,_uid];
_queryResult = [_query,2] call DB_fnc_asyncCall;
//systemChat format ["House ID assigned: %1",_queryResult select 0];
_house setVariable ["house_id",(_queryResult select 0),true];
[_house, "house_id", _queryResult param [0, nil]] call TON_fnc_serverSet; //Sicherheitsphase 0.2
[_house, "house_owner", [_uid, ([_caller] call TON_fnc_callerInfo) param [3, ""]]] call TON_fnc_serverSet;
//Phase 0.3: Besitz zusaetzlich in asset_owners - die pid-Spalte bleibt vorerst die Quelle
["house", _queryResult param [0, 0], "player", _uid] call TON_fnc_assetOwn;
if (ECONOMY_MODE >= 1 && {!(_caller isEqualTo 2)}) then {
    [_house] remoteExecCall ["life_fnc_houseBought", _caller]; //Client richtet das Haus erst nach der Buchung ein
};
