/*
        File : fn_getPlayTime.sqf
        Author : NiiRoZz
        Description :
        Gets playtime for player with UID
        GATHERED - Loaded from DB and NOT changed
        JOIN - Time, the player joined - the newly gathered playtime will be calculated using difference
*/
private ["_uid", "_time_gathered", "_time_join","_time"];
_uid = _this select 0;
private _values = localNamespace getVariable ["TON_fnc_playtime_values", []]; //Sicherheitsphase 0.2 Welle 2
_time_gathered = nil;
_time_join = nil;
{
    if ((_x select 0) isEqualTo _uid) exitWith {
        _time_gathered = _x select 1;
        _time_join = _x select 2;
    };
} forEach _values;
if (isNil "_time_gathered" || isNil "_time_join") then {
    _time_gathered = 0;
    _time_join = time;
    _values pushBack [_uid, _time_gathered, _time_join];
};
_time = (time - _time_join); //return time
_time = _time + _time_gathered;
_time = round (_time/60);
_time;