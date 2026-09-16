#include "..\..\script_macros.hpp"
/*
    File: fn_moneyUpdate.sqf
    Description:
    The server changed this player's money (TON_fnc_moneyChange, docs/ECONOMY_AUTHORITY.md).
    Shadow mode (EconomyMode 1): other flows still change CASH/BANK on the client, so only the
    change is applied and unsaved local changes are kept. Enforce mode (2): the server's balance
    replaces the local value.
    Parameters:
        0: NUMBER - cash on the server
        1: NUMBER - bank on the server
        2: NUMBER - cash change
        3: NUMBER - bank change
*/
SERVER_ONLY_REMOTE;
params [["_cash", 0, [0]], ["_bank", 0, [0]], ["_deltaCash", 0, [0]], ["_deltaBank", 0, [0]]];
if ((getNumber (missionConfigFile >> "CfgServer" >> "EconomyMode")) >= 2) then {
    CASH = _cash;
    BANK = _bank;
} else {
    CASH = CASH + _deltaCash;
    BANK = BANK + _deltaBank;
};
[] call life_fnc_hudUpdate;
if (!isNull (findDisplay 2700)) then {[] call life_fnc_atmMenu};
if (!isNull (findDisplay 2001)) then {[] call life_fnc_p_updateMenu};
