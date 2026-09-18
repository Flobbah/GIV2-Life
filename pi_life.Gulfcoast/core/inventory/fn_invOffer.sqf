#include "..\..\script_macros.hpp"
/*
    File: fn_invOffer.sqf
    Description:
    Another player gives us items (docs/INVENTORY_AUTHORITY.md, package 3). This client only answers
    how much of it still fits; the server books both sides (TON_fnc_invAccept).
    Parameters:
        0: NUMBER - token of the offer
        1: STRING - item
        2: NUMBER - amount
        3: STRING - name of the giver
*/
SERVER_ONLY_REMOTE;
params [["_token", -1, [0]], ["_item", "", [""]], ["_amount", 0, [0]], ["_from", "", [""]]];
if (INVENTORY_MODE isEqualTo 0 || {_item isEqualTo ""}) exitWith {};
private _fits = [_item, _amount, life_carryWeight, life_maxWeight] call life_fnc_calWeightDiff;
[_token, _fits] remoteExecCall ["TON_fnc_invAccept", RSERV];
if (_fits < _amount) then {
    [ format [localize "STR_MISC_TooMuch_3", _from, _amount, _fits, (_amount - _fits)],true,"fast"] call life_fnc_notification_system;
};
