#include "\life_server\script_macros.hpp"
/*
    File: fn_econRobbery.sqf
    Description:
    Gas station and bank robberies (docs/ECONOMY_AUTHORITY.md, step 2 package 4b). The server decides
    whether a robbery may start (faction, place, police online, cooldowns, one bank robbery at a time),
    remembers when it started and only pays out if the robber finishes in time and on the spot.
    Cooldown globals (life_nextrob, life_firstrob, DevB_BankRobbing) are published by the server and
    protected (TON_fnc_publishProtected). Called through life_fnc_econRequest / life_fnc_econAwait.
    Parameters:
        0: NUMBER - request id
        1: STRING - "gasStart", "gasFinish", "bankStart", "bankAbort" or "bankFinish"
        2: OBJECT - gas station shop object or bank building
    Answers (data):
        failure: [reason] with reason "side", "distance", "firstrob", ["cooldown", seconds], "police",
                 "weapon", "busy", "chance", "norob", "tooearly", "expired", "dead", "denied"
        gasFinish success: [amount]
*/
private _owner = CALLER_OWNER;
params [["_id", -1, [0]], ["_action", "", [""]], ["_target", objNull, [objNull]]];
if (ECONOMY_MODE isEqualTo 0) exitWith {};
private _info = [_owner] call TON_fnc_callerInfo;
if (_info isEqualTo []) exitWith {};
_info params ["_uid", "_unit", "_side", "_name"];
private _answer = {
    params ["_ok", ["_data", []]];
    [_id, _ok, _data] remoteExecCall ["life_fnc_econReply", _owner];
};
private _cfg = missionConfigFile >> "CfgEconomy";
private _gas = missionConfigFile >> "TankeRob_Master";
private _cops = {(AUTH_SIDE(getPlayerUID _x)) isEqualTo west} count allPlayers;
private _bankRob = ["server", "bankRob", []] call TON_fnc_serverGet;
private _bankRobActive = !(_bankRob isEqualTo []) && {(diag_tickTime - (_bankRob select 2)) < ((getNumber (_cfg >> "bankRobDuration")) + 300)};

switch (_action) do {
    case "gasStart": {
        private _nextRob = localNamespace getVariable ["life_protected_life_nextrob", 0];
        switch (true) do {
            case !(_side isEqualTo civilian): {[false, ["side"]] call _answer};
            case (isNull _target || {(_unit distance _target) > ((getNumber (_gas >> "Max_Distance")) + 3)}): {[false, ["distance"]] call _answer};
            case (localNamespace getVariable ["life_protected_life_firstrob", false]): {[false, ["firstrob"]] call _answer};
            case (serverTime < _nextRob): {[false, ["cooldown", _nextRob - serverTime]] call _answer};
            case (_cops < getNumber (_gas >> "Max_Police")): {[false, ["police"]] call _answer};
            case ((currentWeapon _unit) isEqualTo ""): {[false, ["weapon"]] call _answer};
            default {
                [_uid, "gasRob", [netId _target, diag_tickTime]] call TON_fnc_serverSet;
                ["life_nextrob", serverTime + getNumber (_gas >> "RoberDelay")] call TON_fnc_publishProtected;
                [true] call _answer;
            };
        };
    };
    case "gasFinish": {
        private _rob = [_uid, "gasRob", []] call TON_fnc_serverGet;
        _rob params [["_shopId", ""], ["_start", -1e9]];
        [_uid, "gasRob"] call TON_fnc_serverSet;
        private _duration = getNumber (_cfg >> "gasRobDuration");
        switch (true) do {
            case (isNull _target || {!((netId _target) isEqualTo _shopId)}): {[false, ["norob"]] call _answer};
            case ((diag_tickTime - _start) < (_duration - 10)): {
                [_owner, "TON_fnc_econRobbery gasFinish", format ["finished after %1 s, needs %2 s", round (diag_tickTime - _start), _duration]] call TON_fnc_denyCaller;
                [false, ["tooearly"]] call _answer;
            };
            case ((diag_tickTime - _start) > (_duration + 300)): {[false, ["expired"]] call _answer};
            case ((_unit distance _target) > ((getNumber (_gas >> "Max_Distance_Shop")) + 5)): {[false, ["distance"]] call _answer};
            case (!alive _unit): {[false, ["dead"]] call _answer};
            default {
                private _amount = (getNumber (_gas >> "Max_Money_Rob")) + round (random (getNumber (_gas >> "Max_Money_Rob_Random")));
                if ([_uid, "cash", _amount, "robbery_gas", "", _shopId] call TON_fnc_moneyChange) then {
                    if ((random 100) < 36) then {[_uid, _name, "23"] spawn life_fnc_wantedAdd};
                    [true, [_amount]] call _answer;
                } else {
                    [false, ["denied"]] call _answer;
                };
            };
        };
    };
    case "bankStart": {
        switch (true) do {
            case !(_side isEqualTo civilian): {[false, ["side"]] call _answer};
            case (isNull _target || {!((typeOf _target) isEqualTo "Land_CommonwealthBank")} || {(_unit distance _target) > 12}): {[false, ["distance"]] call _answer};
            case (_cops < getNumber (_cfg >> "bankRobMinCops")): {[false, ["police"]] call _answer};
            case ((diag_tickTime - ([_target, "robAt", -1e9] call TON_fnc_serverGet)) < getNumber (_cfg >> "bankRobCooldown")): {[false, ["cooldown"]] call _answer};
            case (_bankRobActive): {[false, ["busy"]] call _answer};
            case ((random 100) < getNumber (_cfg >> "bankRobFailChance")): {[false, ["chance"]] call _answer};
            default {
                ["server", "bankRob", [_uid, netId _target, diag_tickTime]] call TON_fnc_serverSet;
                [_target, "robAt", diag_tickTime] call TON_fnc_serverSet;
                ["DevB_BankRobbing", true] call TON_fnc_publishProtected;
                [true] call _answer;
            };
        };
    };
    case "bankAbort": {
        if (_bankRobActive && {(_bankRob select 0) isEqualTo _uid}) then {
            ["server", "bankRob"] call TON_fnc_serverSet;
            ["DevB_BankRobbing", false] call TON_fnc_publishProtected;
        };
        [true] call _answer;
    };
    case "bankFinish": {
        private _duration = getNumber (_cfg >> "bankRobDuration");
        switch (true) do {
            case (!_bankRobActive || {!((_bankRob select 0) isEqualTo _uid)} || {isNull _target} || {!((netId _target) isEqualTo (_bankRob select 1))}): {[false, ["norob"]] call _answer};
            case ((diag_tickTime - (_bankRob select 2)) < (_duration - 30)): {
                [_owner, "TON_fnc_econRobbery bankFinish", format ["finished after %1 s, needs %2 s", round (diag_tickTime - (_bankRob select 2)), _duration]] call TON_fnc_denyCaller;
                [false, ["tooearly"]] call _answer;
            };
            case ((_unit distance _target) > 15 || {!alive _unit}): {[false, ["distance"]] call _answer};
            default {
                ["server", "bankRob"] call TON_fnc_serverSet;
                ["DevB_BankRobbing", false] call TON_fnc_publishProtected;
                private _amount = (getNumber (_cfg >> "bankLootMin")) + round (random (getNumber (_cfg >> "bankLootRandom")));
                private _pos = _target modelToWorld [1, -3, 3];
                private _obj = createVehicle ["Land_Money_F", [_pos select 0, _pos select 1, 0], [], 0, "CAN_COLLIDE"];
                _obj setPos [_pos select 0, _pos select 1, 4];
                _obj setVariable ["item", ["money", _amount], true];
                [_obj, "money", _amount] call TON_fnc_serverSet;
                diag_log format ["[ECONOMY] bank robbery by %1 (%2) finished, loot bundle $%3", _name, _uid, [_amount] call DB_fnc_numberSafe];
                [true, [_amount]] call _answer;
            };
        };
    };
};
