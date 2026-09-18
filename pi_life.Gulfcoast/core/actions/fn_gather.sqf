#include "..\..\script_macros.hpp"
/*
    File: fn_gather.sqf
    Author: Devilfloh
    Description:
    Main functionality for gathering.
*/
private ["_maxGather","_resource","_amount","_maxGather","_requiredItem"];
if (life_action_inUse) exitWith {};
if !(isNull objectParent player) exitWith {};
if (player getVariable "restrained") exitWith {[ localize "STR_NOTF_isrestrained",true,"fast"] call life_fnc_notification_system;};
if (player getVariable "playerSurrender") exitWith {[ localize "STR_NOTF_surrender",true,"fast"] call life_fnc_notification_system;};
life_action_inUse = true;
_zone = "";
_requiredItem = "";
_exit = false;
_resourceCfg = missionConfigFile >> "CfgGather" >> "Resources";
for "_i" from 0 to count(_resourceCfg)-1 do {
    _curConfig = _resourceCfg select _i;
    _resource = configName _curConfig;
    _maxGather = getNumber(_curConfig >> "amount");
    _zoneSize = getNumber(_curConfig >> "zoneSize");
    _resourceZones = getArray(_curConfig >> "zones");
    _requiredItem = getText(_curConfig >> "item");
    {
        if ((player distance (getMarkerPos _x)) < _zoneSize) exitWith {_zone = _x;};
    } forEach _resourceZones;
    if (_zone != "") exitWith {};
};
if (_zone isEqualTo "") exitWith {life_action_inUse = false;};
if (_requiredItem != "") then {
    _valItem = missionNamespace getVariable "life_inv_" + _requiredItem;
    if (_valItem < 1) exitWith {
        switch (_requiredItem) do {
         //Messages here
        };
        life_action_inUse = false;
        _exit = true;
    };
};
if (_exit) exitWith {life_action_inUse = false;};
_amount = round(random(_maxGather)) + 1;
_amount = round (_amount * (1 + ((["gather"] call life_fnc_skillBonus) / 100))); //Skill Abbau
_diff = [_resource,_amount,life_carryWeight,life_maxWeight] call life_fnc_calWeightDiff;
if (_diff isEqualTo 0) exitWith {
    [ localize "STR_NOTF_InvFull",true,"fast"] call life_fnc_notification_system;
    life_action_inUse = false;
};
switch (_requiredItem) do {
    case "pickaxe": {["life_fnc_say3D",[player,"mining",35,1],RCLIENT] call life_fnc_relaySend};
    default {["life_fnc_say3D",[player,"harvest",35,1],RCLIENT] call life_fnc_relaySend};
};
for "_i" from 0 to 4 do {
    player playMoveNow "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon";
    waitUntil{animationState player != "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon";};
    sleep 0.5;
};
//Inventar-Umbau Paket 3: Ort, Werkzeug und Menge entscheidet der Server
if (INVENTORY_MODE >= 1) then {
    ["TON_fnc_invGather", ["gather", life_maxWeight - life_carryWeight, ["gather"] call life_fnc_skillBonus], {
        (_this select 0) params [["_res",""],["_num",0]];
        ["gather"] call life_fnc_skillAddXP;
        titleText[format [localize "STR_NOTF_Gather_Success",(localize (M_CONFIG(getText,"VirtualItems",_res,"displayName"))),_num],"PLAIN"];
    }, {
        if ((((_this select 0) param [0,""]) isEqualTo "full")) then {
            [ localize "STR_NOTF_InvFull",true,"fast"] call life_fnc_notification_system;
        };
    }] call life_fnc_econRequest;
} else {
    if ([true,_resource,_diff] call life_fnc_handleInv) then {
        ["gather"] call life_fnc_skillAddXP;
        _itemName = M_CONFIG(getText,"VirtualItems",_resource,"displayName");
        titleText[format [localize "STR_NOTF_Gather_Success",(localize _itemName),_diff],"PLAIN"];
    };
};
sleep 1;
life_action_inUse = false;
