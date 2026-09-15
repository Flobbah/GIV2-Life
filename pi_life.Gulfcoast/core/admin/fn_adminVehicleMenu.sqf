#include "..\..\script_macros.hpp"
/*
    File: fn_adminVehicleMenu.sqf
    Description:
    Fills the admin vehicle spawn list (dialog 2950) from LifeCfgVehicles,
    filtered by the search box (idc 2953, matches display name or classname).
    The base list is built once per session and cached in life_admin_vehList.
*/
disableSerialization;
private _display = findDisplay 2950;
if (isNull _display) exitWith {};
if (isNil "life_admin_vehList") then {
    life_admin_vehList = [];
    {
        private _class = configName _x;
        if !(_class isEqualTo "Default") then {
            private _cfg = configFile >> "CfgVehicles" >> _class;
            if (isClass _cfg) then {
                life_admin_vehList pushBack [getText (_cfg >> "displayName"),_class,[_class] call life_fnc_vehiclePicture];
            };
        };
    } forEach ("true" configClasses (missionConfigFile >> "LifeCfgVehicles"));
    life_admin_vehList sort true; //by display name
};
private _filter = toLower (ctrlText 2953);
private _list = _display displayCtrl 2951;
lbClear _list;
{
    _x params ["_name","_class","_pic"];
    if (_filter isEqualTo "" || {((toLower _name) find _filter) > -1} || {((toLower _class) find _filter) > -1}) then {
        private _index = _list lbAdd format ["%1 (%2)",_name,_class];
        _list lbSetData [_index,_class];
        if !(_pic isEqualTo "") then {
            _list lbSetPicture [_index,_pic];
        };
    };
} forEach life_admin_vehList;
(_display displayCtrl 2956) ctrlSetText format [localize "STR_AdminVeh_Count",lbSize _list];
if (lbSize _list > 0) then {
    _list lbSetCurSel 0;
} else {
    (_display displayCtrl 2955) ctrlSetStructuredText parseText "";
    lbClear (_display displayCtrl 2952);
};
(_display displayCtrl 2954) ctrlEnable (LIFE_SETTINGS(getNumber,"admin_vehicleSpawn_persistent") isEqualTo 1);
