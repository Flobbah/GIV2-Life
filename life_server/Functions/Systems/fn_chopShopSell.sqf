#include "\life_server\script_macros.hpp"
/*
    File: fn_chopShopSell.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Checks whether or not the vehicle is persistent or temp and sells it.
*/
params [
    ["_unit",objNull,[objNull]],
    ["_vehicle",objNull,[objNull]],
    ["_price",500,[0]]
];
private _caller = CALLER_OWNER; //Sicherheitsphase 0.2 (Nachtrag zu 0.1): Absender pruefen
//Error checks
if (isNull _vehicle || isNull _unit) exitWith  {
    [] remoteExecCall ["life_fnc_chopShopSold", _caller];
};
if !([_caller, _unit, "", sideUnknown, "TON_fnc_chopShopSell"] call TON_fnc_checkCaller) exitWith {
    [] remoteExecCall ["life_fnc_chopShopSold", _caller];
};
//Nur Zivilisten, nur ein leeres, intaktes Fahrzeug der erlaubten Typen in der Naehe; Preis rechnet der Server
private _deny = "";
switch (true) do {
    case (!(_caller isEqualTo 2) && {!((AUTH_SIDE(getPlayerUID _unit)) isEqualTo civilian)}): {_deny = "sender is not a civilian";};
    case (!alive _vehicle || {!((crew _vehicle) isEqualTo [])}): {_deny = "vehicle is destroyed or occupied";};
    case (((LIFE_SETTINGS(getArray,"chopShop_vehicles")) findIf {_vehicle isKindOf _x}) isEqualTo -1): {_deny = format ["vehicle type %1 cannot be chopped", typeOf _vehicle];};
    case ((_unit distance _vehicle) > 60): {_deny = "vehicle too far from the sender";};
};
if (!(_deny isEqualTo "") && {[_caller, "TON_fnc_chopShopSell", _deny] call TON_fnc_denyCaller}) exitWith {
    [] remoteExecCall ["life_fnc_chopShopSold", _caller];
};
private _priceClass = if (isClass (missionConfigFile >> "LifeCfgVehicles" >> typeOf _vehicle)) then {typeOf _vehicle} else {"Default"};
_price = (M_CONFIG(getNumber,"LifeCfgVehicles",_priceClass,"price")) * (LIFE_SETTINGS(getNumber,"vehicle_chopShop_multiplier"));
private _displayName = FETCH_CONFIG2(getText,"CfgVehicles",typeOf _vehicle, "displayName");
private _dbInfo = [_vehicle, "dbInfo", []] call TON_fnc_serverGet; //Sicherheitsphase 0.2
if (count _dbInfo > 0) then {
    _dbInfo params ["_uid","_plate"];
    private _query = format ["UPDATE vehicles SET alive='0' WHERE pid='%1' AND plate='%2'",_uid,_plate];
    [_query,1] call DB_fnc_asyncCall;
};
deleteVehicle _vehicle;
if (ECONOMY_MODE >= 1) then {[getPlayerUID _unit, "cash", round _price, "sale_chop_shop", "", _priceClass] call TON_fnc_moneyChange}; //Geld-Umbau: bucht der Server
[_price,_displayName] remoteExecCall ["life_fnc_chopShopSold", _caller];