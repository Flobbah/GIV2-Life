/*
    File: fn_revealObjects.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Reveals nearest objects within 15m automatically to help with picking
    up various static objects on the ground such as money, water, etc.

    Registered as "EachFrame" handler, but the (expensive) nearestObjects
    scan is throttled to every 0.4 seconds - a player covers at most ~3m in
    that time, so everything within 15m is still revealed in time.
*/
if (!life_settings_revealObjects) exitWith {};
if (diag_tickTime < life_revealObjects_next) exitWith {};
life_revealObjects_next = diag_tickTime + 0.4;
private _objects = nearestObjects[visiblePositionASL player, ["Land_CargoBox_V1_F","Land_BottlePlastic_V1_F","Land_TacticalBacon_F","Land_Can_V3_F","Land_CanisterFuel_F","Land_Money_F","Land_Suitcase_F","CAManBase"], 15];
private _group = group player;
{
    player reveal _x;
    _group reveal _x;
} forEach _objects;
