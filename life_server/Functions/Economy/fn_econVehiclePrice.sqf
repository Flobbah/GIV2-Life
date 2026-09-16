#include "\life_server\script_macros.hpp"
/*
    File: fn_econVehiclePrice.sqf
    Description:
    Vehicle prices as the server computes them (docs/ECONOMY_AUTHORITY.md, step 2 package 3c),
    with the same formulas the client used: LifeCfgVehicles >> price (or "Default") times the
    Life_Settings multiplier of the player's faction.
    Parameters:
        0: STRING - vehicle class
        1: SIDE   - faction (AUTH_SIDE)
        2: STRING - "buy", "rent", "sell" (garage sale) or "storage" (garage/impound fee)
    Returns:
        NUMBER - price, -1 if the faction may not buy/rent it (negative multiplier)
*/
params [["_class", "", [""]], ["_side", civilian, [civilian]], ["_kind", "buy", [""]]];
private _cfgClass = if (isClass (missionConfigFile >> "LifeCfgVehicles" >> _class)) then {_class} else {"Default"};
private _base = M_CONFIG(getNumber,"LifeCfgVehicles",_cfgClass,"price");
private _suffix = switch (_side) do {case west: {"COP"}; case independent: {"MEDIC"}; case east: {"OPFOR"}; default {"CIVILIAN"}};
private _setting = {getNumber (missionConfigFile >> "Life_Settings" >> format ["vehicle_%1_multiplier_%2", _this, _suffix])};
switch (_kind) do {
    case "buy": {
        private _m = "purchase" call _setting;
        if (_m < 0) then {-1} else {round (_base * _m)}
    };
    case "rent": {
        private _m = "rental" call _setting;
        if (_m < 0) then {-1} else {round (_base * _m)}
    };
    case "sell": {
        private _price = round (_base * ("purchase" call _setting) * ("sell" call _setting));
        if (_price < 1) then {500} else {_price}
    };
    case "storage": {
        private _price = round (_base * ("purchase" call _setting) * LIFE_SETTINGS(getNumber,"vehicle_storage_fee_multiplier"));
        if (_price < 1) then {500} else {_price}
    };
    default {-1};
}
