#include "\life_server\script_macros.hpp"
/*
    File: fn_econCash.sqf
    Description:
    Cash that leaves a player without going to another player (docs/ECONOMY_AUTHORITY.md, step 2
    package 4). A client may only lower its own balance here.
    - drop:    all cash of the player becomes a money bundle at the given position (death). The
               server creates the bundle and keeps its value; TON_fnc_pickupAction pays exactly that.
    - forfeit: all cash of the player is gone (bank robber killed by or searched by the police).
    Parameters:
        0: STRING - "drop" or "forfeit"
        1: ARRAY  - drop: position (ATL)
*/
private _owner = CALLER_OWNER;
params [["_action", "", [""]], ["_pos", [], [[]]]];
if (ECONOMY_MODE isEqualTo 0) exitWith {};
private _info = [_owner] call TON_fnc_callerInfo;
if (_info isEqualTo []) exitWith {};
_info params ["_uid", "_unit"];
private _cash = ((localNamespace getVariable ["life_econ_wallets", createHashMap]) getOrDefault [_uid, [0, 0]]) select 0;
if (_cash <= 0) exitWith {};

switch (_action) do {
    case "drop": {
        if !((_pos isEqualTypeArray [0, 0, 0]) || {_pos isEqualTypeArray [0, 0]}) exitWith {};
        //Near the player or the body the player left behind (death record from life_server\init.sqf)
        private _corpse = ((localNamespace getVariable ["life_relay_deaths", createHashMap]) getOrDefault [_owner, []]) param [1, objNull, [objNull]];
        if (([_unit, _corpse] findIf {!isNull _x && {(_x distance2D _pos) < 15}}) isEqualTo -1) exitWith {
            [_owner, "TON_fnc_econCash drop", "drop position too far from the player"] call TON_fnc_denyCaller;
        };
        if !([_uid, "cash", -_cash, "cash_drop"] call TON_fnc_moneyChange) exitWith {};
        private _obj = createVehicle ["Land_Money_F", [_pos select 0, _pos select 1, 0], [], 0, "CAN_COLLIDE"];
        _obj setVariable ["item", ["money", _cash], true];
        [_obj, "money", _cash] call TON_fnc_serverSet;
        _obj enableSimulationGlobal false;
    };
    case "forfeit": {
        [_uid, "cash", -_cash, "cash_forfeit"] call TON_fnc_moneyChange;
    };
};
