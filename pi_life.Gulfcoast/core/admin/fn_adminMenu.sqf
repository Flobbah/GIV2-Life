#include "..\..\script_macros.hpp"
/*
    File: fn_adminMenu.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Opens the admin menu and hides buttons based on life_adminlevel.
    The player list stores an index into life_admin_playerList (see fn_adminTarget).
*/
private _level = FETCH_CONST(life_adminlevel);
if (_level < 1) exitWith {closeDialog 0;};
disableSerialization;
waitUntil {!isNull (findDisplay 2900)};
private _display = findDisplay 2900;
private _list = _display displayCtrl 2902;
//Button idc -> minimum admin level (buttons are defined in dialog\admin_menu.hpp)
{
    _x params ["_idc","_minLevel"];
    (_display displayCtrl _idc) ctrlShow (_level >= _minLevel);
} forEach [
    [2904,2], //Compensate
    [2915,2], //Heal self
    [2916,2], //Heal player
    [2917,2], //Repair vehicle
    [2905,3], //Spectate
    [2906,3], //Teleport (map click)
    [2912,3], //Teleport to player
    [2913,3], //Arsenal
    [2914,3], //Spawn vehicle
    [2907,4], //Teleport here
    [2908,4], //God mode
    [2909,4], //Freeze
    [2910,4], //Player markers
    [2918,4], //Delete vehicle
    [2920,3], //Spieler verwalten (Lizenzen ab 3, Raenge ab 4)
    [2911,5]  //Debug console
];
//Player list
lbClear _list;
life_admin_playerList = [];
{
    private _side = switch (SIDE_OF(_x)) do {case west: {"Cop"}; case civilian: {"Civ"}; case independent: {"Medic"}; default {"Unknown"};};
    life_admin_playerList pushBack _x;
    private _index = _list lbAdd format ["%1 - %2", _x getVariable ["realname",name _x],_side];
    _list lbSetValue [_index,(count life_admin_playerList) - 1];
} forEach playableUnits;
if (life_god) then {
    (_display displayCtrl 2908) ctrlSetTextColor [0, 1, 0, 1]; //green
};
if (life_markers) then {
    (_display displayCtrl 2910) ctrlSetTextColor [0, 1, 0, 1]; //green
};
