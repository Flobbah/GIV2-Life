#include "\life_server\script_macros.hpp"
/*
    File: fn_invZone.sqf
    Description:
    Which resource can be gathered where the unit stands (docs/INVENTORY_AUTHORITY.md). Looks through
    CfgGather; for minerals the find is drawn from the probability table of the zone. Used by
    TON_fnc_invGather (a player digging) and TON_fnc_trunkMine (the mining device). Server-only.
    Parameters:
        0: OBJECT - the unit whose position decides
        1: ARRAY  - (optional) which config classes to look at: "gather" = Resources, "mine" = Minerals
    Returns:
        ARRAY - [resource, amount per go, required item] or ["", 0, ""] when there is no zone
*/
params [["_unit", objNull, [objNull]], ["_kinds", ["gather", "mine"], [[]]]];
private _result = ["", 0, ""];
if (isNull _unit) exitWith {_result};
{
    private _kind = _x;
    private _cfg = missionConfigFile >> "CfgGather" >> (["Resources", "Minerals"] select (_kind isEqualTo "mine"));
    private _entry = configNull;
    {
        private _class = _x;
        private _size = getNumber (_class >> "zoneSize");
        if (((getArray (_class >> "zones")) findIf {(_unit distance2D (getMarkerPos _x)) < _size}) > -1) exitWith {_entry = _class};
    } forEach ("true" configClasses _cfg);
    if !(isNull _entry) exitWith {
        private _resource = "";
        if (_kind isEqualTo "mine") then {
            private _mined = getArray (_entry >> "mined");
            private _percent = (floor random 100) + 1;
            {
                if (_x isEqualType "") exitWith {_resource = _x};
                if (_percent >= (_x param [1, 0]) && {_percent <= (_x param [2, 0])}) exitWith {_resource = _x param [0, ""]};
            } forEach _mined;
            if (_resource isEqualTo "" && {!(_mined isEqualTo [])}) then {
                private _first = _mined select 0;
                _resource = if (_first isEqualType "") then {_first} else {_first param [0, ""]};
            };
        } else {
            _resource = configName _entry;
        };
        if (isClass (missionConfigFile >> "VirtualItems" >> _resource)) then {
            _result = [_resource, getNumber (_entry >> "amount"), getText (_entry >> "item")];
        };
    };
} forEach _kinds;
_result
