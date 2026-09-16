#include "\life_server\script_macros.hpp"
/*
    File: fn_econPlayer.sqf
    Description:
    Money between players (docs/ECONOMY_AUTHORITY.md, step 2). The server checks range and the
    sender's balance and books the transfer; the amount the receiver gets is the amount the sender
    really paid.
    Parameters:
        0: STRING - "giveCash" or "rob" (civilian robs an incapacitated player, CfgEconomy >> robCooldown per victim)
        1: OBJECT - receiving player (giveCash) or victim (rob)
        2: NUMBER - amount (giveCash)
*/
private _owner = CALLER_OWNER;
params [["_action", "", [""]], ["_target", objNull, [objNull]], ["_amount", 0, [0]]];
if (ECONOMY_MODE isEqualTo 0) exitWith {};
private _info = [_owner] call TON_fnc_callerInfo;
if (_info isEqualTo []) exitWith {};
_info params ["_uid", "_unit", "", "_name"];
_amount = round _amount;
if (_amount <= 0) exitWith {};
private _reply = {
    params ["_key", ["_args", []], ["_error", false]];
    [_key, _args, _error] remoteExecCall ["life_fnc_econResult", _owner];
};
private _text = {[_this] call life_fnc_numberText};

switch (_action) do {
    case "giveCash": {
        if (isNull _target || {!isPlayer _target} || {_target isEqualTo _unit} || {!alive _target}) exitWith {};
        if ((_unit distance _target) > 25) exitWith {["STR_NOTF_notWithinRange", [], true] call _reply};
        if !([_uid, "cash", getPlayerUID _target, "cash", _amount, "give_cash"] call TON_fnc_moneyTransfer) exitWith {
            ["STR_NOTF_notEnoughtToGive", [], true] call _reply;
        };
        ["STR_NOTF_youGaveMoney", [_amount call _text, name _target]] call _reply;
        ["STR_NOTF_GivenMoney", [_name, _amount call _text]] remoteExecCall ["life_fnc_econResult", owner _target];
    };
    case "rob": {
        //Civilian robs an incapacitated player nearby; takes the victim's cash as the server knows it
        if (isNull _target || {!isPlayer _target} || {_target isEqualTo _unit}) exitWith {};
        private _deny = switch (true) do {
            case !((AUTH_SIDE(_uid)) isEqualTo civilian): {"robber is not a civilian"};
            case ((_unit distance _target) > 15): {"victim too far from the robber"};
            case !((toLower (animationState _target)) isEqualTo "incapacitated"): {"victim is not incapacitated"};
            default {""};
        };
        if !(_deny isEqualTo "") exitWith {[_owner, "TON_fnc_econPlayer rob", _deny] call TON_fnc_denyCaller};
        private _victimUid = getPlayerUID _target;
        private _last = [_victimUid, "robbedAt", -1e9] call TON_fnc_serverGet;
        if ((diag_tickTime - _last) < getNumber (missionConfigFile >> "CfgEconomy" >> "robCooldown")) exitWith {
            [2, "STR_NOTF_RobFail", true, [name _target]] remoteExecCall ["life_fnc_broadcast", _owner];
        };
        [_victimUid, "robbedAt", diag_tickTime] call TON_fnc_serverSet;
        private _cash = ((localNamespace getVariable ["life_econ_wallets", createHashMap]) getOrDefault [_victimUid, [0, 0]]) select 0;
        if (_cash <= 0 || {!([_victimUid, "cash", _uid, "cash", _cash, "robbery"] call TON_fnc_moneyTransfer)}) exitWith {
            [2, "STR_NOTF_RobFail", true, [name _target]] remoteExecCall ["life_fnc_broadcast", _owner];
        };
        [_uid, _name, "211"] spawn life_fnc_wantedAdd;
        ["STR_Civ_Robbed", [_cash call _text]] call _reply;
        [1, "STR_NOTF_Robbed", true, [_name, name _target, _cash call _text]] remoteExecCall ["life_fnc_broadcast", -2];
    };
};
