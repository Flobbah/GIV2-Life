#include "\life_server\script_macros.hpp"
/*
    File: fn_sellHouse.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Used in selling the house, sets the owned to 0 and will cleanup with a
    stored procedure on restart.
*/
private ["_house","_houseID","_ownerID","_housePos","_query","_radius","_containers"];
_house = [_this,0,objNull,[objNull]] call BIS_fnc_param;
if (isNull _house) exitWith {systemChat ":SERVER:sellHouse: House is null";};
private _caller = CALLER_OWNER; //Sicherheitsphase 0.1: Absender pruefen
if (!(_caller isEqualTo 2) && {!((([_caller] call TON_fnc_callerInfo) param [0, ""]) isEqualTo (([_house, "house_owner", []] call TON_fnc_serverGet) param [0, "-"]))} && {[_caller, "TON_fnc_sellHouse", "sender does not own the house"] call TON_fnc_denyCaller}) exitWith {};
_houseID = [_house, "house_id", -1] call TON_fnc_serverGet; //Sicherheitsphase 0.2: ID und Besitzer aus dem Server-Speicher (vorher SQL-Injection ueber house_id)
private _shadowOwner = ([_house, "house_owner", []] call TON_fnc_serverGet) param [0, ""];
if (_shadowOwner isEqualTo "") exitWith {};
if (_houseID isEqualTo -1) then {
    _housePos = getPosATL _house;
    _ownerID = _shadowOwner;
    _query = format ["UPDATE houses SET owned='0', pos='[]' WHERE pid='%1' AND pos='%2' AND owned='1'",_ownerID,_housePos];
    //systemChat format [":SERVER:sellHouse: house_id does not exist, query: %1",_query];
} else {
    //systemChat format [":SERVER:sellHouse: house_id is %1",_houseID];
    _query = format ["UPDATE houses SET owned='0', pos='[]' WHERE id='%1'",_houseID];
};
_house setVariable ["house_id",nil,true];
_house setVariable ["house_owner",nil,true];
[_house, "house_id"] call TON_fnc_serverSet;
[_house, "house_owner"] call TON_fnc_serverSet;
_house setVariable ["garageBought",false,true];
[_query,1] call DB_fnc_asyncCall;
_house setVariable ["house_sold",nil,true];
//Geld-Umbau Schritt 2: den halben Kaufpreis zahlt der Server dem Besitzer, erst nach der Besitzpruefung oben
if (ECONOMY_MODE >= 1 && {!(_caller isEqualTo 2)}) then {
    private _price = round ((([typeOf _house] call life_fnc_houseConfig) param [0, 0]) / 2);
    if (_price > 0) then {[_shadowOwner, "bank", _price, "house_sell", "", typeOf _house] call TON_fnc_moneyChange};
};
["CALL deleteOldHouses",1] call DB_fnc_asyncCall;
