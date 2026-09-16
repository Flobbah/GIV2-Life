#include "..\..\script_macros.hpp"
/*
    File: fn_gankBankResponse.sqf
    Author: DomT602
    Description:
    Receives response from the server.
*/
params [
    ["_value",-1,[0]]
];
if (remoteExecutedOwner != ([2,HC_Life] select LIFE_HC_ACTIVE)) exitWith {};
if (_value isEqualTo -1) exitWith {};
[ format [localize "STR_ATM_WithdrawSuccessG",[_value] call life_fnc_numberText],false,"fast"] call life_fnc_notification_system;
CASH = CASH + _value;
[] call life_fnc_atmMenu;