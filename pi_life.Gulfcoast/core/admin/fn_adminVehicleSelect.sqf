#include "..\..\script_macros.hpp"
/*
    File: fn_adminVehicleSelect.sqf
    Description:
    Called when a vehicle is selected in the admin spawn list (onLBSelChanged):
    shows vehicle information and fills the colour combo from LifeCfgVehicles.
*/
disableSerialization;
params ["_control",["_index",-1,[0]]];
if (_index isEqualTo -1) exitWith {};
private _display = findDisplay 2950;
if (isNull _display) exitWith {};
private _class = _control lbData _index;
private _info = [_class] call life_fnc_fetchVehInfo;
if (_info isEqualTo []) exitWith {};
private _cfgClass = if (isClass (missionConfigFile >> "LifeCfgVehicles" >> _class)) then {_class} else {"Default"};
private _price = M_CONFIG(getNumber,"LifeCfgVehicles",_cfgClass,"price");
private _trunk = [_class] call life_fnc_vehicleWeightCfg;
(_display displayCtrl 2955) ctrlSetStructuredText parseText format [
    "<t size='1.1'>%1</t><br/><t size='0.8' color='#bbbbbb'>%2</t><br/><br/>" +
    (localize "STR_Shop_Veh_UI_Ownership") + " <t color='#8cff9b'>$%3</t><br/>" +
    (localize "STR_Shop_Veh_UI_MaxSpeed") + " %4 km/h<br/>" +
    (localize "STR_Shop_Veh_UI_PSeats") + " %5<br/>" +
    (localize "STR_Shop_Veh_UI_Trunk") + " %6<br/>" +
    (localize "STR_Shop_Veh_UI_Fuel") + " %7",
    _info select 3,
    _class,
    [_price] call life_fnc_numberText,
    _info select 8,
    _info select 10,
    if (_trunk isEqualTo -1) then {"None"} else {_trunk},
    _info select 12
];
//Colours
private _combo = _display displayCtrl 2952;
lbClear _combo;
{
    _x params ["_textureName"];
    private _comboIndex = _combo lbAdd _textureName;
    _combo lbSetValue [_comboIndex,_forEachIndex];
} forEach (M_CONFIG(getArray,"LifeCfgVehicles",_cfgClass,"textures"));
if (lbSize _combo > 0) then {_combo lbSetCurSel 0;};
