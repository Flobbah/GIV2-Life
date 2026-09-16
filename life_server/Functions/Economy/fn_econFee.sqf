#include "\life_server\script_macros.hpp"
/*
    File: fn_econFee.sqf
    Description:
    Fixed fees paid in cash (docs/ECONOMY_AUTHORITY.md, step 2 package 3a). The server takes the
    price from the mission config, checks what it can (faction, place, cooldown) and charges the
    player's cash. The client continues the action only after a positive answer
    (life_fnc_econRequest / life_fnc_econReply).
    Parameters:
        0: NUMBER - request id from life_fnc_econRequest
        1: STRING - "license", "hospital", "chopperService", "jerryCan", "news" or "process"
        2: STRING - license: Licenses class; process: ProcessAction class
    Kinds:
        license        Licenses >> class >> price, license side must match the player's faction
        hospital       Life_Settings >> hospital_heal_fee
        chopperService Life_Settings >> service_chopper, near the chopper service pad (air_sp)
        jerryCan       Life_Settings >> fuelCan_refuel, near a fuel pump
        news           Life_Settings >> news_broadcast_cost, server-side cooldown news_broadcast_cooldown
        process        ProcessAction >> class >> NoLicenseCost x number of input materials
*/
private _owner = CALLER_OWNER;
params [["_id", -1, [0]], ["_kind", "", [""]], ["_class", "", [""]]];
if (ECONOMY_MODE isEqualTo 0) exitWith {};
private _info = [_owner] call TON_fnc_callerInfo;
if (_info isEqualTo []) exitWith {};
_info params ["_uid", "_unit", "_side"];
private _answer = {
    params ["_ok", ["_data", []]];
    [_id, _ok, _data] remoteExecCall ["life_fnc_econReply", _owner];
};
private _price = -1;
private _deny = "";
switch (_kind) do {
    case "license": {
        private _cfg = missionConfigFile >> "Licenses" >> _class;
        if (!isClass _cfg) exitWith {_deny = "unknown license"};
        private _sideFlag = switch (_side) do {case west: {"cop"}; case independent: {"med"}; default {"civ"}};
        if !((getText (_cfg >> "side")) isEqualTo _sideFlag) exitWith {_deny = format ["license %1 is not for side %2", _class, _side]};
        _price = getNumber (_cfg >> "price");
    };
    case "hospital": {_price = LIFE_SETTINGS(getNumber,"hospital_heal_fee")};
    case "chopperService": {
        if (isNil "air_sp" || {(_unit distance air_sp) > 50}) exitWith {_deny = "not at the chopper service"};
        _price = LIFE_SETTINGS(getNumber,"service_chopper");
    };
    case "jerryCan": {
        if ((nearestObjects [_unit, ["Land_FuelStation_Feed_F", "Land_fs_feed_F"], 10]) isEqualTo []) exitWith {_deny = "no fuel pump nearby"};
        _price = LIFE_SETTINGS(getNumber,"fuelCan_refuel");
    };
    case "news": {
        private _last = ["server", "newsAt", -1e9] call TON_fnc_serverGet;
        if ((diag_tickTime - _last) < (LIFE_SETTINGS(getNumber,"news_broadcast_cooldown") * 60)) exitWith {_deny = "news cooldown"};
        _price = LIFE_SETTINGS(getNumber,"news_broadcast_cost");
    };
    case "process": {
        private _cfg = missionConfigFile >> "ProcessAction" >> _class;
        if (!isClass _cfg) exitWith {_deny = "unknown processing"};
        _price = (getNumber (_cfg >> "NoLicenseCost")) * (count getArray (_cfg >> "MaterialsReq"));
    };
    default {_deny = format ["unknown fee %1", _kind]};
};
if !(_deny isEqualTo "") exitWith {
    if (_deny in ["news cooldown"]) then {[false, ["cooldown"]] call _answer} else {
        [_owner, "TON_fnc_econFee " + _kind, _deny] call TON_fnc_denyCaller;
        [false, ["denied"]] call _answer;
    };
};
if (_price < 0) exitWith {[false, ["denied"]] call _answer};
if (_price > 0 && {!([_uid, "cash", -_price, "fee_" + _kind, "", _class] call TON_fnc_moneyChange)}) exitWith {
    [false, ["money", _price]] call _answer;
};
if (_kind isEqualTo "news") then {["server", "newsAt", diag_tickTime] call TON_fnc_serverSet};
[true, [_price]] call _answer;
