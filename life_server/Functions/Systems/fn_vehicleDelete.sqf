#include "\life_server\script_macros.hpp"
/*
    File: fn_vehicleDelete.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Doesn't actually delete since we don't give our DB user that type of
    access so instead we set it to alive=0 so it never shows again.
*/
private ["_vid","_sp","_pid","_query","_type","_thread"];
_vid = [_this,0,-1,[0]] call BIS_fnc_param;
_pid = [_this,1,"",[""]] call BIS_fnc_param;
_sp = [_this,2,2500,[0]] call BIS_fnc_param;
_unit = [_this,3,objNull,[objNull]] call BIS_fnc_param;
_type = [_this,4,"",[""]] call BIS_fnc_param;
if (_vid isEqualTo -1 || _pid isEqualTo "" || _sp isEqualTo 0 || isNull _unit || _type isEqualTo "") exitWith {};
if !([CALLER_OWNER, _unit, _pid, sideUnknown, "TON_fnc_vehicleDelete"] call TON_fnc_checkCaller) exitWith {};
_unit = owner _unit;
if (ECONOMY_MODE >= 1) exitWith {
    //Geld-Umbau Schritt 2: nur ein lebendes, eingeparktes Fahrzeug des Absenders; den Preis zahlt der Server
    private _row = [format ["SELECT classname, alive, active FROM vehicles WHERE pid='%1' AND id='%2'", _pid, _vid], 2] call DB_fnc_asyncCall;
    if (!(_row isEqualType []) || {count _row < 3} || {!((_row select 1) isEqualTo 1)} || {!((_row select 2) isEqualTo 0)}) exitWith {};
    [format ["UPDATE vehicles SET alive='0' WHERE pid='%1' AND id='%2' AND alive='1' AND active='0'", _pid, _vid], 1] call DB_fnc_asyncCall;
    private _price = [_row select 0, AUTH_SIDE(_pid), "sell"] call TON_fnc_econVehiclePrice;
    if ([_pid, "bank", _price, "vehicle_sell", "", _row select 0] call TON_fnc_moneyChange) then {
        ["STR_Garage_SoldCar", [[_price] call life_fnc_numberText]] remoteExecCall ["life_fnc_econResult", _unit];
    };
};
_query = format ["UPDATE vehicles SET alive='0' WHERE pid='%1' AND id='%2'",_pid,_vid];
_thread = [_query,1] call DB_fnc_asyncCall;