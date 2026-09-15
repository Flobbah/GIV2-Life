#include "..\..\script_macros.hpp"
/*
    File: fn_gangWithdraw.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Withdraws money from the gang bank.
*/
params [
    ["_deposit",false,[false]]
];
private _value = parseNumber(ctrlText 2702);
private _gFund = GANG_FUNDS;
if ((time - life_action_delay) < 0.5) exitWith {[ localize "STR_NOTF_ActionDelay",true,"fast"] call life_fnc_notification_system};
//Series of stupid checks
if (isNil {(group player) getVariable "gang_name"}) exitWith {[ localize "STR_ATM_NotInGang",true,"fast"] call life_fnc_notification_system}; // Checks if player isn't in a gang
private _limit = LIFE_SETTINGS(getNumber,"bank_transactionLimit");
if (_value > _limit) exitWith {[ format [localize "STR_ATM_WithdrawMax",[_limit] call life_fnc_numberText],true,"fast"] call life_fnc_notification_system;};
if (_value < 1) exitWith {};
if (!([str(_value)] call TON_fnc_isnumber)) exitWith {[ localize "STR_ATM_notnumeric",true,"fast"] call life_fnc_notification_system};
if (_deposit && _value > CASH) exitWith {[ localize "STR_ATM_NotEnoughCash",true,"fast"] call life_fnc_notification_system};
if (!_deposit && _value > _gFund) exitWith {[ localize "STR_ATM_NotEnoughFundsG",true,"fast"] call life_fnc_notification_system};
if (_deposit) then {
    CASH = CASH - _value;
    [] call life_fnc_atmMenu;
};
if (life_HC_isActive) then {
    [1,group player,_deposit,_value,player,CASH] remoteExecCall ["HC_fnc_updateGang",HC_Life]; //Update the database.
} else {
    [1,group player,_deposit,_value,player,CASH] remoteExecCall ["TON_fnc_updateGang",RSERV]; //Update the database.
};
life_action_delay = time;