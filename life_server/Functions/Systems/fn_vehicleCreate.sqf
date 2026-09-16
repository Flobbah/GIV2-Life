#include "\life_server\script_macros.hpp"
/*
    File: fn_vehicleCreate.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Answers the query request to create the vehicle in the database.
*/
private ["_uid","_side","_type","_classname","_color","_plate"];
_uid = [_this,0,"",[""]] call BIS_fnc_param;
_side = [_this,1,sideUnknown,[west]] call BIS_fnc_param;
_vehicle = [_this,2,objNull,[objNull]] call BIS_fnc_param;
_color = [_this,3,-1,[0]] call BIS_fnc_param;
//Error checks
if (_uid isEqualTo "" || _side isEqualTo sideUnknown || isNull _vehicle) exitWith {};
//Sicherheitsphase 0.1: nur fuer den Kaeufer selbst und ein Fahrzeug in seiner Naehe
private _caller = CALLER_OWNER; //Sicherheitsphase 0.1: Absender pruefen
if !([_caller, objNull, _uid, _side, "TON_fnc_vehicleCreate"] call TON_fnc_checkCaller) exitWith {};
if (!(_caller isEqualTo 2) && {((([_caller] call TON_fnc_callerInfo) param [1, objNull]) distance _vehicle) > 80} && {[_caller, "TON_fnc_vehicleCreate", "vehicle too far from the buyer"] call TON_fnc_denyCaller}) exitWith {};
//Geld-Umbau Schritt 2: nur ein bezahltes Fahrzeug wird eingetragen (Kauf ueber TON_fnc_econShop, 10 Minuten gueltig);
//ohne Kauf nur fuer Admins ab Level 3 (Admin-Fahrzeugspawn)
private _registrationOk = true;
if (ECONOMY_MODE >= 1 && {!(_caller isEqualTo 2)}) then {
    private _paid = [_uid, "vehiclesPaid", []] call TON_fnc_serverGet;
    private _index = _paid findIf {((_x select 0) == typeOf _vehicle) && {(diag_tickTime - (_x select 1)) < 600}};
    if (_index > -1) then {
        _paid deleteAt _index;
        [_uid, "vehiclesPaid", _paid] call TON_fnc_serverSet;
    } else {
        private _res = [format ["SELECT adminlevel FROM players WHERE pid='%1'", _uid], 2] call DB_fnc_asyncCall;
        private _level = _res param [0, 0];
        if (_level isEqualType "") then {_level = parseNumber _level};
        if (!(_level isEqualType 0) || {_level < 3}) then {_registrationOk = false};
    };
};
if (!_registrationOk && {[_caller, "TON_fnc_vehicleCreate", format ["no paid purchase for %1", typeOf _vehicle]] call TON_fnc_denyCaller}) exitWith {};
if (!alive _vehicle) exitWith {};
_className = typeOf _vehicle;
_type = switch (true) do {
    case (_vehicle isKindOf "Car"): {"Car"};
    case (_vehicle isKindOf "Air"): {"Air"};
    case (_vehicle isKindOf "Ship"): {"Ship"};
};
_side = switch (_side) do {
    case west:{"cop"};
    case civilian: {"civ"};
    case independent: {"med"};
    default {"Error"};
};
_plate = round(random(1000000));
[_uid,_side,_type,_classname,_color,_plate] call DB_fnc_insertVehicle;
_vehicle setVariable ["dbInfo",[_uid,_plate],true];
[_vehicle, "dbInfo", [_uid,_plate]] call TON_fnc_serverSet; //Sicherheitsphase 0.2
