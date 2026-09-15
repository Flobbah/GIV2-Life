#include "..\..\script_macros.hpp"
/*
    File: fn_hudUpdate.sqf
    Author: Daniel Stuart
    Description:
    Updates the HUD when it needs to.
    Money and player counts are only re-formatted when the value actually changed
    (life_hud_cache), because this runs once per second for the whole session.
*/
disableSerialization;
if (isNull LIFEdisplay) then {[] call life_fnc_hudSetup;};
private _dmg = damage player;
LIFEctrl(1) progressSetPosition (1 - _dmg);
LIFEctrl(2) progressSetPosition (life_hunger / 100);
LIFEctrl(3) progressSetPosition (life_thirst / 100);
LIFEctrl(4) ctrlSetText format ["%1%2",round((1 - _dmg) * 100),"%"];
LIFEctrl(5) ctrlSetText format ["%1%2",life_hunger,"%"];
LIFEctrl(6) ctrlSetText format ["%1%2",life_thirst,"%"];
private _cache = life_hud_cache;
if !(BANK isEqualTo (_cache select 0)) then {
    _cache set [0,BANK];
    LIFEctrl(7) ctrlSetText format ["%1$",[BANK] call life_fnc_numberText];
};
if !(CASH isEqualTo (_cache select 1)) then {
    _cache set [1,CASH];
    LIFEctrl(8) ctrlSetText format ["%1$",[CASH] call life_fnc_numberText];
};
private _units = playableUnits;
private _cops = ({SIDE_OF(_x) isEqualTo west} count _units);
private _medics = ({SIDE_OF(_x) isEqualTo independent} count _units);
private _civs = ({SIDE_OF(_x) isEqualTo civilian} count _units);
if !(_cops isEqualTo (_cache select 2)) then {_cache set [2,_cops]; LIFEctrl(9) ctrlSetText str _cops;};
if !(_medics isEqualTo (_cache select 3)) then {_cache set [3,_medics]; LIFEctrl(10) ctrlSetText str _medics;};
if !(_civs isEqualTo (_cache select 4)) then {_cache set [4,_civs]; LIFEctrl(11) ctrlSetText str _civs;};
