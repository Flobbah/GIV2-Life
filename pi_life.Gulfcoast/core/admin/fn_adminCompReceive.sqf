#include "..\..\script_macros.hpp"
/*
    File: fn_adminCompReceive.sqf
    Description:
    Executed on the compensated player (remoteExec from fn_adminCompensate).
    Parameters:
        0: NUMBER - amount
        1: BOOL   - true = bank account, false = cash
        2: STRING - name of the admin
*/
params [["_value",0,[0]],["_toBank",true,[true]],["_from","",[""]]];
if (_value <= 0 || {_from isEqualTo ""}) exitWith {};
if (_value > LIFE_SETTINGS(getNumber,"admin_compensateLimit")) exitWith {};
_value = round _value;
if (_toBank) then {
    BANK = BANK + _value;
    [1] call SOCK_fnc_updatePartial;
} else {
    CASH = CASH + _value;
    [0] call SOCK_fnc_updatePartial;
};
[] call life_fnc_hudUpdate;
private _accountName = localize (["STR_Admin_CompAccountCash","STR_Admin_CompAccountBank"] select _toBank);
[ format [localize "STR_ANOTF_CompReceived",_from,[_value] call life_fnc_numberText,_accountName],true,"fast"] call life_fnc_notification_system;
