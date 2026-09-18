#include "\life_server\script_macros.hpp"
/*
    File: fn_invProcess.sqf
    Description:
    Processing (docs/INVENTORY_AUTHORITY.md, package 3). The client asks for a number of conversions,
    the server checks in its own copy how many the materials actually cover, removes the input and
    books the output. The fee without a licence stays with TON_fnc_econFee, this is only about the
    goods. The place is not checked: without the raw materials nothing is gained by processing
    somewhere else, and the materials are exactly what this function verifies.
    Parameters:
        0: NUMBER - request id
        1: STRING - class in ProcessAction
        2: NUMBER - conversions the client asks for (already capped by its carry weight)
    Answer data: [conversions done, true when it was all of them], failure ["items"] or ["denied"]
*/
private _owner = CALLER_OWNER;
params [["_id", -1, [0]], ["_type", "", [""]], ["_want", 0, [0]]];
if (INVENTORY_MODE isEqualTo 0) exitWith {};
private _info = [_owner] call TON_fnc_callerInfo;
if (_info isEqualTo []) exitWith {};
_info params ["_uid", "_unit", "_side", "_name"];
private _answer = {
    params ["_ok", ["_data", []]];
    [_id, _ok, _data] remoteExecCall ["life_fnc_econReply", _owner];
};
private _cfg = missionConfigFile >> "ProcessAction" >> _type;
if (!isClass _cfg) exitWith {
    [_owner, "TON_fnc_invProcess", format ["unknown processing %1", _type]] call TON_fnc_denyCaller;
    [false, ["denied"]] call _answer;
};
private _req = getArray (_cfg >> "MaterialsReq");
private _give = getArray (_cfg >> "MaterialsGive");
_want = round _want;
if (_req isEqualTo [] || {_give isEqualTo []} || {_want < 1} || {_want > 10000}) exitWith {[false, ["denied"]] call _answer};
//So viele Umwandlungen deckt der Bestand laut Serverkopie
private _possible = _want;
{
    _x params [["_item", "", [""]], ["_num", 0, [0]]];
    if (_num <= 0) exitWith {_possible = 0};
    _possible = _possible min (floor (([_uid, _item] call TON_fnc_invGet) / _num));
} forEach _req;
if (_possible < 1) exitWith {[false, ["items"]] call _answer};
{
    _x params [["_item", "", [""]], ["_num", 0, [0]]];
    [_uid, _item, -(_num * _possible), "process"] call TON_fnc_invChange;
} forEach _req;
{
    _x params [["_item", "", [""]], ["_num", 0, [0]]];
    [_uid, _item, (_num * _possible), "process"] call TON_fnc_invChange;
} forEach _give;
[true, [_possible, _possible isEqualTo _want]] call _answer;
