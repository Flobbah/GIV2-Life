#include "\life_server\script_macros.hpp"
/*
    File: fn_trunkSpace.sqf
    Description:
    How much a trunk can hold: for vehicles and containers LifeCfgVehicles >> vItemSpace, for houses
    the sum over the containers placed in them. Server-only.
    Parameters:
        0: OBJECT - vehicle, container or house
    Returns:
        NUMBER - capacity, 0 when the object cannot store anything
*/
params [["_obj", objNull, [objNull]]];
if (isNull _obj) exitWith {0};
private _space = {
    private _class = _this;
    if (!isClass (missionConfigFile >> "LifeCfgVehicles" >> _class)) then {_class = "Default"};
    getNumber (missionConfigFile >> "LifeCfgVehicles" >> _class >> "vItemSpace")
};
if !(_obj isKindOf "House_F") exitWith {0 max ((typeOf _obj) call _space)};
private _total = 0;
{
    if (!isNull _x) then {_total = _total + ((typeOf _x) call _space)};
} forEach (_obj getVariable ["containers", []]);
0 max _total
