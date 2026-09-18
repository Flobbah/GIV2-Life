#include "\life_server\script_macros.hpp"
/*
    File: fn_invGather.sqf
    Description:
    Gathering and mining (docs/INVENTORY_AUTHORITY.md, package 3). The client only asks; the server
    finds the zone from the player's position in CfgGather, checks the required tool in its own copy,
    rolls the amount from the config, caps it by the free weight the client reports and books the
    items itself (TON_fnc_invChange pushes the new count). Answers through life_fnc_econReply.
    The skill bonus comes from the client but is capped at what the highest level gives, so claiming
    more than level 5 is pointless.
    Parameters:
        0: NUMBER - request id
        1: STRING - "gather" or "mine"
        2: NUMBER - free carry weight of the sender
        3: NUMBER - gather skill bonus in percent
    Answer data: [resource, amount], failure ["tool", item], ["full"] or ["denied"]
*/
private _owner = CALLER_OWNER;
params [["_id", -1, [0]], ["_kind", "", [""]], ["_free", 0, [0]], ["_bonus", 0, [0]]];
if (INVENTORY_MODE isEqualTo 0) exitWith {};
private _info = [_owner] call TON_fnc_callerInfo;
if (_info isEqualTo []) exitWith {};
_info params ["_uid", "_unit", "_side", "_name"];
private _answer = {
    params ["_ok", ["_data", []]];
    [_id, _ok, _data] remoteExecCall ["life_fnc_econReply", _owner];
};
private _deny = {
    [_owner, "TON_fnc_invGather " + _kind, _this] call TON_fnc_denyCaller;
    [false, ["denied"]] call _answer;
};
if (!(_kind in ["gather", "mine"])) exitWith {"unknown kind" call _deny};
if (!isNull objectParent _unit) exitWith {"sender is in a vehicle" call _deny};
//Zone, Rohstoff und Menge kommen aus der gemeinsamen Suche (auch vom Bergbaugeraet genutzt)
([_unit, [_kind]] call TON_fnc_invZone) params [["_resource", ""], ["_max", 0], ["_required", ""]];
if (_resource isEqualTo "") exitWith {"no gathering zone at the sender's position" call _deny};
if (!(_required isEqualTo "") && {([_uid, _required] call TON_fnc_invGet) < 1}) exitWith {[false, ["tool", _required]] call _answer};
private _amount = (round (random _max)) + 1;
private _cap = (getNumber (missionConfigFile >> "CfgSkills" >> "gather" >> "bonusPerLevel")) * (count (getArray (missionConfigFile >> "CfgSkills" >> "xpLevels")));
_amount = round (_amount * (1 + ((0 max (_bonus min _cap)) / 100)));
private _weight = getNumber (missionConfigFile >> "VirtualItems" >> _resource >> "weight");
if (_weight > 0) then {_amount = _amount min (floor ((0 max _free) / _weight))};
if (_amount < 1) exitWith {[false, ["full"]] call _answer};
if !([_uid, _resource, _amount, _kind] call TON_fnc_invChange) exitWith {[false, ["denied"]] call _answer};
[true, [_resource, _amount]] call _answer;
