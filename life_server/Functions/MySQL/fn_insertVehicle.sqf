/*
    File: fn_insertVehicle.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Inserts the vehicle into the database
*/
private ["_query","_sql"];
params [
    "_uid",
    "_side",
    "_type",
    "_className",
    ["_color",-1,[0]],
    ["_plate",-1,[0]]
];
//Stop bad data being passed.
if (_uid isEqualTo "" || _side isEqualTo "" || _type isEqualTo "" || _className isEqualTo "" || _color isEqualTo -1 || _plate isEqualTo -1) exitWith {};
_query = format ["INSERT INTO vehicles (side, classname, type, pid, alive, active, inventory, color, plate, gear, damage) VALUES ('%1', '%2', '%3', '%4', '1','1','""[[],0]""', '%5', '%6','""[]""','""[]""')",_side,_className,_type,_uid,_color,_plate];
[_query,1] call DB_fnc_asyncCall;
//Phase 0.3: Besitz zusaetzlich in asset_owners. Die id steht erst fest, wenn der INSERT oben
//durch ist - deshalb in einem eigenen Faden mit kurzer Pause, wie in TON_fnc_addContainer.
[_uid, _plate] spawn {
    params ["_uid", "_plate"];
    uiSleep 0.4;
    private _res = [format ["SELECT id FROM vehicles WHERE pid='%1' AND plate='%2' ORDER BY id DESC LIMIT 1", _uid, _plate], 2] call DB_fnc_asyncCall;
    private _id = _res param [0, 0];
    if (_id isEqualType "") then {_id = parseNumber _id};
    if (_id isEqualType 0 && {_id > 0}) then {["vehicle", _id, "player", _uid] call TON_fnc_assetOwn};
};
