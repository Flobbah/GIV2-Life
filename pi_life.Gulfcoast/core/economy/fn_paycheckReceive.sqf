#include "..\..\script_macros.hpp"
/*
    File: fn_paycheckReceive.sqf
    Description:
    Paycheck notification. The server books the paycheck (TON_fnc_econPaycheck) and the new bank
    balance arrives through life_fnc_moneyUpdate; this only shows the message.
    Parameters:
        0: NUMBER - paycheck amount
*/
SERVER_ONLY_REMOTE;
params [["_amount", 0, [0]]];
if (_amount <= 0) exitWith {};
["<img size='1.1' image='\pi_data\icons\ico_bank.paa'/> " + format [localize "STR_FSM_ReceivedPay", [_amount] call life_fnc_numberText], false, "fast"] call life_fnc_notification_system;
