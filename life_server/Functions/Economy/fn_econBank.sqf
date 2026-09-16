#include "\life_server\script_macros.hpp"
/*
    File: fn_econBank.sqf
    Description:
    Bank requests from clients (docs/ECONOMY_AUTHORITY.md, step 2): ATM deposit and withdraw, wire
    transfer and admin compensation. The server checks limits, balances and the admin level and books
    the money itself; the client only sends what it wants and shows the answer (life_fnc_econResult).
    Parameters:
        0: STRING - "deposit", "withdraw", "transfer" or "compensate"
        1: NUMBER - amount
        2: OBJECT - transfer: receiving player; compensate: player to compensate (objNull = the admin)
        3: BOOL   - compensate: true = bank account, false = cash
*/
private _owner = CALLER_OWNER;
params [["_action", "", [""]], ["_amount", 0, [0]], ["_target", objNull, [objNull]], ["_toBank", true, [true]]];
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
private _limit = LIFE_SETTINGS(getNumber,"bank_transactionLimit");

switch (_action) do {
    case "deposit": {
        if (_amount > _limit) exitWith {["STR_ATM_GreaterThan", [_limit call _text], true] call _reply};
        if ([_uid, "cash", _uid, "bank", _amount, "atm_deposit"] call TON_fnc_moneyTransfer) then {
            ["STR_ATM_DepositSuccess", [_amount call _text]] call _reply;
        } else {
            ["STR_ATM_NotEnoughCash", [], true] call _reply;
        };
    };
    case "withdraw": {
        if (_amount > _limit) exitWith {["STR_ATM_WithdrawMax", [_limit call _text], true] call _reply};
        if ([_uid, "bank", _uid, "cash", _amount, "atm_withdraw"] call TON_fnc_moneyTransfer) then {
            ["STR_ATM_WithdrawSuccess", [_amount call _text]] call _reply;
        } else {
            ["STR_ATM_NotEnoughFunds", [], true] call _reply;
        };
    };
    case "transfer": {
        if (_amount > _limit) exitWith {["STR_ATM_TransferMax", [_limit call _text], true] call _reply};
        if (isNull _target || {!isPlayer _target} || {_target isEqualTo _unit}) exitWith {["STR_ATM_DoesntExist", [], true] call _reply};
        private _targetUid = getPlayerUID _target;
        private _tax = round (_amount * LIFE_SETTINGS(getNumber,"bank_transferTax"));
        private _bank = ((localNamespace getVariable ["life_econ_wallets", createHashMap]) getOrDefault [_uid, [0, 0]]) select 1;
        if (_bank < (_amount + _tax)) exitWith {["STR_ATM_SentMoneyFail", [_amount call _text, _tax call _text], true] call _reply};
        if !([_uid, "bank", _targetUid, "bank", _amount, "wire_transfer"] call TON_fnc_moneyTransfer) exitWith {["STR_ATM_DoesntExist", [], true] call _reply};
        if (_tax > 0) then {[_uid, "bank", -_tax, "wire_tax", _targetUid] call TON_fnc_moneyChange};
        ["STR_ATM_SentMoneySuccess", [_amount call _text, name _target, _tax call _text]] call _reply;
        ["STR_ATM_WireTransfer", [_name, _amount call _text]] remoteExecCall ["life_fnc_econResult", owner _target];
    };
    case "gangDeposit": {
        if (_amount > _limit) exitWith {["STR_ATM_GreaterThan", [_limit call _text], true] call _reply};
        private _gangId = [_uid, _unit] call TON_fnc_gangMemberId;
        if (_gangId < 0) exitWith {["STR_ATM_NotInGang", [], true] call _reply};
        if !([_uid, "cash", -_amount, "gang_deposit", str _gangId] call TON_fnc_moneyChange) exitWith {["STR_ATM_NotEnoughCash", [], true] call _reply};
        if !([_gangId, _amount, "gang_deposit", _uid] call TON_fnc_gangMoney) exitWith {
            [_uid, "cash", _amount, "gang_deposit_refund", str _gangId] call TON_fnc_moneyChange;
            ["STR_ATM_NotInGang", [], true] call _reply;
        };
        ["STR_ATM_DepositSuccessG", [_amount call _text]] call _reply;
    };
    case "gangWithdraw": {
        if (_amount > _limit) exitWith {["STR_ATM_WithdrawMax", [_limit call _text], true] call _reply};
        private _gangId = [_uid, _unit] call TON_fnc_gangMemberId;
        if (_gangId < 0) exitWith {["STR_ATM_NotInGang", [], true] call _reply};
        if !([_gangId, -_amount, "gang_withdraw", _uid] call TON_fnc_gangMoney) exitWith {["STR_ATM_NotEnoughFundsG", [], true] call _reply};
        [_uid, "cash", _amount, "gang_withdraw", str _gangId] call TON_fnc_moneyChange;
        ["STR_ATM_WithdrawSuccessG", [_amount call _text]] call _reply;
    };
    case "compensate": {
        private _res = [format ["SELECT adminlevel FROM players WHERE pid='%1'", _uid], 2] call DB_fnc_asyncCall;
        private _level = if (_res isEqualType [] && {count _res > 0}) then {_res select 0} else {0};
        if (_level isEqualType "") then {_level = parseNumber _level};
        if (!(_level isEqualType 0) || {_level < 2}) exitWith {
            [_owner, "TON_fnc_econBank compensate", format ["admin level %1 below 2", _level]] call TON_fnc_denyCaller;
            ["STR_ANOTF_ErrorLevel", [], true] call _reply;
        };
        private _max = LIFE_SETTINGS(getNumber,"admin_compensateLimit");
        if (_amount > _max) exitWith {["STR_ANOTF_Fail", [_max call _text], true] call _reply};
        if (isNull _target) then {_target = _unit};
        if (!isPlayer _target) exitWith {["STR_ANOTF_NoTarget", [], true] call _reply};
        private _targetUid = getPlayerUID _target;
        private _account = ["cash", "bank"] select _toBank;
        if !([_targetUid, _account, _amount, "admin_compensation", _uid, _name] call TON_fnc_moneyChange) exitWith {["STR_ANOTF_NoTarget", [], true] call _reply};
        diag_log format ["[ADMIN COMPENSATE] %1 (%2) -> %3 (%4): $%5 %6", _name, _uid, name _target, _targetUid, [_amount] call DB_fnc_numberSafe, _account];
        private _accountKey = ["STR_Admin_CompAccountCash", "STR_Admin_CompAccountBank"] select _toBank;
        if (_target isEqualTo _unit) then {
            ["STR_ANOTF_CompSelf", [_amount call _text, _accountKey]] call _reply;
        } else {
            ["STR_ANOTF_CompSent", [name _target, _amount call _text, _accountKey]] call _reply;
            ["STR_ANOTF_CompReceived", [_name, _amount call _text, _accountKey]] remoteExecCall ["life_fnc_econResult", owner _target];
        };
    };
};
