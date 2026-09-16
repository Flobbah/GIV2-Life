#include "\life_server\script_macros.hpp"
/*
    File: fn_relay.sqf
    Description:
    Server relay for player-to-player actions (security phase 0.1b).
    Clients send these actions through life_fnc_relaySend instead of calling each other directly.
    The server knows the real sender, applies the rule from CfgRelay >> Functions
    (mission config\Config_Relay.hpp, field reference there) and forwards the call. While the relay
    is enabled, receivers only accept remote calls from the server or their own client
    (RELAY_ONLY_REMOTE in the mission script_macros.hpp).
    Functions without a rule and senders over the rate limit are always blocked; every other
    rejection is logged and blocked according to CfgServer >> CallerCheckMode (TON_fnc_denyCaller).
    Parameters:
        0: STRING - function name
        1: ARRAY  - arguments
        2: ANY    - remoteExec target (object, side, group, number or array)
*/
private _owner = CALLER_OWNER;
params [
    ["_fn", "", [""]],
    ["_args", [], [[]]],
    ["_target", objNull, [objNull, sideUnknown, grpNull, 0, []]]
];
private _cfg = missionConfigFile >> "CfgRelay" >> "Functions" >> _fn;
private _scheduled = (getNumber (_cfg >> "scheduled")) isEqualTo 1;

if (_owner isEqualTo 2) exitWith {
    if (_scheduled) then {_args remoteExec [_fn, _target]} else {_args remoteExecCall [_fn, _target]};
};

private _info = [_owner] call TON_fnc_callerInfo;
if (_info isEqualTo []) exitWith {
    diag_log format ["[SECURITY] TON_fnc_relay rejected - owner %1: unknown sender for %2", _owner, _fn];
};
_info params ["_uid", "_unit", "_side", "_name"];
if (_fn isEqualTo "" || {!isClass _cfg}) exitWith {
    diag_log format ["[SECURITY] TON_fnc_relay rejected - owner %1, uid %2, name %3: %4 has no rule in CfgRelay", _owner, _uid, _name, _fn];
};

//Rate limit per sender
(getArray (missionConfigFile >> "CfgRelay" >> "rateLimit")) params [["_maxCalls", 60, [0]], ["_window", 10, [0]]];
private _rates = localNamespace getVariable "life_relay_rates";
if (isNil "_rates") then {
    _rates = createHashMap;
    localNamespace setVariable ["life_relay_rates", _rates];
};
private _rate = _rates getOrDefault [_owner, []];
if (_rate isEqualTo [] || {(diag_tickTime - (_rate select 0)) > _window}) then {
    _rate = [diag_tickTime, 0];
    _rates set [_owner, _rate];
};
_rate set [1, (_rate select 1) + 1];
if ((_rate select 1) > _maxCalls) exitWith {
    if ((_rate select 1) isEqualTo (_maxCalls + 1)) then {
        diag_log format ["[SECURITY] TON_fnc_relay rejected - owner %1, uid %2, name %3: more than %4 actions within %5 s, dropping the rest of this window (last: %6)", _owner, _uid, _name, _maxCalls, _window, _fn];
    };
};

//Last death of the sender (recorded by the EntityKilled handler in life_server\init.sqf).
//Range checks also accept the body, the player may already have respawned elsewhere (dropped items, revive).
private _death = (localNamespace getVariable ["life_relay_deaths", createHashMap]) getOrDefault [_owner, []];
private _corpse = _death param [1, objNull, [objNull]];

private _index = {
    private _entry = _cfg >> _this;
    if (isNumber _entry) then {getNumber _entry} else {-1}
};
private _sender = getText (_cfg >> "sender");
private _adminLevel = getNumber (_cfg >> "adminLevel");
private _targetType = getText (_cfg >> "target");
private _distance = getNumber (_cfg >> "distance");
private _objectArg = "objectArg" call _index;
private _reason = "";

switch (_sender) do {
    case "cop": {if !(_side isEqualTo west) then {_reason = format ["sender side %1 is not allowed (police only)", _side]};};
    case "medic": {if !(_side isEqualTo independent) then {_reason = format ["sender side %1 is not allowed (EMS only)", _side]};};
    case "civ": {if !(_side isEqualTo civilian) then {_reason = format ["sender side %1 is not allowed (civilians only)", _side]};};
    case "killed": {
        if (_death isEqualTo [] || {(diag_tickTime - (_death select 0)) > 60}) exitWith {_reason = "sender has not been killed recently"};
        _death params ["", "", "_killer", "_instigator"];
        private _related = [_killer, _instigator, vehicle _killer, vehicle _instigator, effectiveCommander _killer] select {!isNull _x};
        if (!(_target isEqualType objNull) || {!(_target in _related) && {!((vehicle _target) in _related)}}) then {
            _reason = format ["target %1 did not kill the sender", _target];
        };
    };
};

if (_reason isEqualTo "") then {
    switch (_targetType) do {
        case "player": {if (!(_target isEqualType objNull) || {!isPlayer _target}) then {_reason = format ["target %1 is not a player", _target]};};
        case "cop": {
            if (!(_target isEqualType objNull) || {!isPlayer _target} || {!((AUTH_SIDE(getPlayerUID _target)) isEqualTo west)}) then {
                _reason = format ["target %1 is not a police officer", _target];
            };
        };
        case "unit": {if (!(_target isEqualType objNull) || {!(_target isKindOf "CAManBase")}) then {_reason = format ["target %1 is not a unit", _target]};};
        case "object": {
            _target = _args param [_objectArg, objNull, [objNull]];
            if (isNull _target) then {_reason = "target object is missing"};
        };
        default {if (_target isEqualTo 2 || {_target isEqualType [] && {2 in _target}}) then {_reason = "the server is not a valid target"};};
    };
};

if (_reason isEqualTo "" && {_distance > 0}) then {
    private _refs = [_unit, _corpse] select {!isNull _x};
    private _near = {
        params ["_pos"];
        (_refs findIf {(_x distance2D _pos) <= _distance}) > -1
    };
    if (_target isEqualType objNull && {!isNull _target} && {!([_target] call _near)}) exitWith {
        _reason = format ["target %1 is more than %2 m away", _target, _distance];
    };
    if (_objectArg >= 0) then {
        private _ref = _args param [_objectArg, objNull];
        private _valid = if (_ref isEqualType objNull) then {!isNull _ref} else {(_ref isEqualTypeArray [0,0,0]) || {_ref isEqualTypeArray [0,0]}};
        if (!_valid || {!([_ref] call _near)}) then {
            _reason = format ["argument %1 (%2) is missing or more than %3 m away", _objectArg, _ref, _distance];
        };
    };
};

if (_reason isEqualTo "") then {
    if (("nameArg" call _index) >= 0) then {
        //Profile name from the user info, name of a dead unit is not reliable
        {
            private _user = getUserInfo _x;
            if ((_user param [1, -1]) isEqualTo _owner) exitWith {_name = _user param [3, _name]};
        } forEach allUsers;
    };
    {
        _x params ["_key", "_value"];
        private _i = _key call _index;
        if (_i >= 0 && {_i < count _args}) then {_args set [_i, _value]};
    } forEach [["senderArg", _unit], ["nameArg", _name], ["uidArg", _uid], ["sideArg", _side]];

    private _condition = getText (_cfg >> "condition");
    if !(_condition isEqualTo "") then {
        private _codes = localNamespace getVariable "life_relay_conditions";
        if (isNil "_codes") then {
            _codes = createHashMap;
            localNamespace setVariable ["life_relay_conditions", _codes];
        };
        private _code = _codes get _fn;
        if (isNil "_code") then {
            _code = compile _condition;
            _codes set [_fn, _code];
        };
        private _ok = call _code;
        if (isNil "_ok" || {!(_ok isEqualType true)} || {!_ok}) then {
            _reason = format ["condition failed: %1", _condition];
        };
    };
};

if (_reason isEqualTo "" && {_adminLevel > 0}) then {
    private _res = [format ["SELECT adminlevel FROM players WHERE pid='%1'", _uid], 2] call DB_fnc_asyncCall;
    private _level = 0;
    if (_res isEqualType [] && {count _res > 0}) then {
        _level = _res select 0;
        if (_level isEqualType "") then {_level = parseNumber _level};
        if !(_level isEqualType 0) then {_level = 0};
    };
    if (_level < _adminLevel) then {
        _reason = format ["admin level %1 is below %2", _level, _adminLevel];
    };
};

if (!(_reason isEqualTo "") && {[_owner, format ["TON_fnc_relay %1", _fn], _reason] call TON_fnc_denyCaller}) exitWith {};

if (_scheduled) then {_args remoteExec [_fn, _target]} else {_args remoteExecCall [_fn, _target]};
