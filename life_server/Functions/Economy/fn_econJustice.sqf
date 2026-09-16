#include "\life_server\script_macros.hpp"
/*
    File: fn_econJustice.sqf
    Description:
    Justice money requests (docs/ECONOMY_AUTHORITY.md, step 2 package 2).
    - ticketIssue: a police officer writes a ticket. The server stores it for the target (issuer,
      amount, time) and opens the payment dialog there. Amount 1..CfgEconomy >> ticketMax.
    - ticketPay: the ticketed player pays the stored ticket (cash first, then bank) to the issuing
      officer. Only the stored amount can be paid, and only within CfgEconomy >> ticketValidSeconds.
    - bail: pays the bail stored by life_fnc_jailSys once the waiting time is over.
    Parameters:
        0: STRING - "ticketIssue", "ticketPay" or "bail"
        1: OBJECT - ticketIssue: ticketed player
        2: NUMBER - ticketIssue: amount
*/
private _owner = CALLER_OWNER;
params [["_action", "", [""]], ["_target", objNull, [objNull]], ["_amount", 0, [0]]];
if (ECONOMY_MODE isEqualTo 0) exitWith {};
private _info = [_owner] call TON_fnc_callerInfo;
if (_info isEqualTo []) exitWith {};
_info params ["_uid", "_unit", "_side", "_name"];
private _reply = {
    params ["_key", ["_args", []], ["_error", false]];
    [_key, _args, _error] remoteExecCall ["life_fnc_econResult", _owner];
};
private _text = {[_this] call life_fnc_numberText};
private _wallet = (localNamespace getVariable ["life_econ_wallets", createHashMap]) getOrDefault [_uid, [0, 0]];

switch (_action) do {
    case "ticketIssue": {
        _amount = round _amount;
        private _max = getNumber (missionConfigFile >> "CfgEconomy" >> "ticketMax");
        if !(_side isEqualTo west) exitWith {[_owner, "TON_fnc_econJustice ticketIssue", "sender is not a police officer"] call TON_fnc_denyCaller};
        if (isNull _target || {!isPlayer _target} || {_target isEqualTo _unit}) exitWith {["STR_Cop_TicketExist", [], true] call _reply};
        if (_amount < 1 || {_amount > _max}) exitWith {["STR_Cop_TicketOver100", [], true] call _reply};
        if ((_unit distance _target) > 20) exitWith {["STR_NOTF_notWithinRange", [], true] call _reply};
        [getPlayerUID _target, "ticket", [_uid, _amount, diag_tickTime]] call TON_fnc_serverSet;
        [0, "STR_Cop_TicketGive", true, [_name, _amount call _text, name _target]] remoteExecCall ["life_fnc_broadcast", -2];
        [_unit, _amount] remoteExec ["life_fnc_ticketPrompt", owner _target];
    };
    case "ticketPay": {
        private _ticket = [_uid, "ticket", []] call TON_fnc_serverGet;
        _ticket params [["_copUid", ""], ["_value", 0], ["_issued", -1e9]];
        if (_copUid isEqualTo "" || {(diag_tickTime - _issued) > getNumber (missionConfigFile >> "CfgEconomy" >> "ticketValidSeconds")}) exitWith {
            [_uid, "ticket"] call TON_fnc_serverSet;
        };
        private _cop = objNull;
        {if ((getPlayerUID _x) isEqualTo _copUid) exitWith {_cop = _x}} forEach allPlayers;
        private _account = switch (true) do {
            case ((_wallet select 0) >= _value): {"cash"};
            case ((_wallet select 1) >= _value): {"bank"};
            default {""};
        };
        if (_account isEqualTo "" || {!([_uid, _account, _copUid, "bank", _value, "ticket"] call TON_fnc_moneyTransfer)}) exitWith {
            ["STR_Cop_Ticket_NotEnough", [], true] call _reply;
            if (!isNull _cop) then {[1, "STR_Cop_Ticket_NotEnoughNOTF", true, [_name]] remoteExecCall ["life_fnc_broadcast", owner _cop]};
        };
        [_uid, "ticket"] call TON_fnc_serverSet;
        [_uid] spawn life_fnc_wantedRemove;
        ["STR_Cop_Ticket_Paid", [_value call _text]] call _reply;
        [0, "STR_Cop_Ticket_PaidNOTF", true, [_name, _value call _text]] remoteExecCall ["life_fnc_broadcast", west];
        if (!isNull _cop) then {[1, "STR_Cop_Ticket_PaidNOTF_2", true, [_name]] remoteExecCall ["life_fnc_broadcast", owner _cop]};
    };
    case "bail": {
        private _bail = [_uid, "bail", []] call TON_fnc_serverGet;
        _bail params [["_value", 0], ["_payableAt", 1e9], ["_validUntil", -1]];
        if (_value <= 0 || {diag_tickTime > _validUntil}) exitWith {};
        if (diag_tickTime < _payableAt) exitWith {["STR_NOTF_Bail_Post", [], true] call _reply};
        if !([_uid, "bank", -_value, "bail"] call TON_fnc_moneyChange) exitWith {["STR_NOTF_Bail_NotEnough", [_value], true] call _reply};
        [_uid, "bail"] call TON_fnc_serverSet;
        [] remoteExecCall ["life_fnc_bailPaid", _owner];
        [0, "STR_NOTF_Bail_Bailed", true, [_name]] remoteExecCall ["life_fnc_broadcast", -2];
    };
};
