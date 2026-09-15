#include "..\..\script_macros.hpp"
/*
    File: fn_bankWithdraw.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Withdraws money from the players account
*/
private ["_value"];
_value = parseNumber(ctrlText 2702);
private _limit = LIFE_SETTINGS(getNumber,"bank_transactionLimit");
if (_value > _limit) exitWith {[ format [localize "STR_ATM_WithdrawMax",[_limit] call life_fnc_numberText],true,"fast"] call life_fnc_notification_system;};
if (_value < 0) exitWith {};
if (!([str(_value)] call TON_fnc_isnumber)) exitWith {[ localize "STR_ATM_notnumeric",true,"fast"] call life_fnc_notification_system};
if (_value > BANK) exitWith {[ localize "STR_ATM_NotEnoughFunds",true,"fast"] call life_fnc_notification_system};
if (_value < 100 && BANK > 20000000) exitWith {[ localize "STR_ATM_WithdrawMin",true,"fast"] call life_fnc_notification_system}; //Temp fix for something.
CASH = CASH + _value;
BANK = BANK - _value;
[ format [localize "STR_ATM_WithdrawSuccess",[_value] call life_fnc_numberText],false,"fast"] call life_fnc_notification_system;
[] call life_fnc_atmMenu;
[6] call SOCK_fnc_updatePartial;
if (LIFE_SETTINGS(getNumber,"player_moneyLog") isEqualTo 1) then {
    if (LIFE_SETTINGS(getNumber,"battlEye_friendlyLogging") isEqualTo 1) then {
        money_log = format [localize "STR_DL_ML_withdrewBank_BEF",_value,[BANK] call life_fnc_numberText,[CASH] call life_fnc_numberText];
    } else {
        money_log = format [localize "STR_DL_ML_withdrewBank",profileName,(getPlayerUID player),_value,[BANK] call life_fnc_numberText,[CASH] call life_fnc_numberText];
    };
    publicVariableServer "money_log";
};
