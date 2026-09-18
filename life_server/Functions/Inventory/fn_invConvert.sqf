#include "\life_server\script_macros.hpp"
/*
    File: fn_invConvert.sqf
    Description:
    Turns one item into another one, for the pairs listed in CfgInventory >> convert (the jerry can,
    full to empty and back). The conditions - standing at a pump, having a vehicle in front of you -
    stay on the client; what matters here is that the item is really there and that nothing else can be
    conjured up (docs/INVENTORY_AUTHORITY.md).
    Parameters:
        0: NUMBER - request id
        1: STRING - item the player gives up
        2: STRING - item the player gets
    Answer data: [to], failure ["items"] or ["denied"]
*/
private _owner = CALLER_OWNER;
params [["_id", -1, [0]], ["_from", "", [""]], ["_to", "", [""]]];
if (INVENTORY_MODE isEqualTo 0) exitWith {};
private _info = [_owner] call TON_fnc_callerInfo;
if (_info isEqualTo []) exitWith {};
_info params ["_uid"];
private _answer = {
    params ["_ok", ["_data", []]];
    [_id, _ok, _data] remoteExecCall ["life_fnc_econReply", _owner];
};
private _allowed = ((getArray (missionConfigFile >> "CfgInventory" >> "convert")) findIf {
    ((_x param [0, ""]) isEqualTo _from) && {(_x param [1, ""]) isEqualTo _to}
}) > -1;
switch (true) do {
    case (!_allowed): {
        [_owner, "TON_fnc_invConvert", format ["%1 cannot be turned into %2", _from, _to]] call TON_fnc_denyCaller;
        [false, ["denied"]] call _answer;
    };
    case (([_uid, _from] call TON_fnc_invGet) < 1): {[false, ["items"]] call _answer};
    default {
        [_uid, _from, -1, "convert"] call TON_fnc_invChange;
        [_uid, _to, 1, "convert"] call TON_fnc_invChange;
        [true, [_to]] call _answer;
    };
};
