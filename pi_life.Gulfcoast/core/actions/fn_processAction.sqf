#include "..\..\script_macros.hpp"
/*
    File: fn_processAction.sqf
    Author: Bryan "Tonic" Boardwine
    Modified : NiiRoZz
    Description:
    Master handling for processing an item.
    NiiRoZz : Added multiprocess
*/
private ["_vendor","_type","_itemInfo","_oldItem","_newItemWeight","_newItem","_oldItemWeight","_cost","_upp","_hasLicense","_itemName","_oldVal","_ui","_progress","_pgText","_cP","_materialsRequired","_materialsGiven","_noLicenseCost","_text","_filter","_totalConversions","_minimumConversions"];
_vendor = [_this,0,objNull,[objNull]] call BIS_fnc_param;
_type = [_this,3,"",[""]] call BIS_fnc_param;
//Error check
if (isNull _vendor || _type isEqualTo "" || (player distance _vendor > 10)) exitWith {};
life_action_inUse = true;//Lock out other actions during processing.
if (isClass (missionConfigFile >> "ProcessAction" >> _type)) then {
    _filter = false;
    _materialsRequired = M_CONFIG(getArray,"ProcessAction",_type,"MaterialsReq");
    _materialsGiven = M_CONFIG(getArray,"ProcessAction",_type,"MaterialsGive");
    _noLicenseCost = M_CONFIG(getNumber,"ProcessAction",_type,"NoLicenseCost");
    _text = M_CONFIG(getText,"ProcessAction",_type,"Text");
} else {_filter = true;};
if (_filter) exitWith {life_action_inUse = false;};
_itemInfo = [_materialsRequired,_materialsGiven,_noLicenseCost,(localize format ["%1",_text])];
if (count _itemInfo isEqualTo 0) exitWith {life_action_inUse = false;};
//Setup vars.
_oldItem = _itemInfo select 0;
_newItem = _itemInfo select 1;
_cost = _itemInfo select 2;
_upp = _itemInfo select 3;
_exit = false;
if (count _oldItem isEqualTo 0) exitWith {life_action_inUse = false;};
_totalConversions = [];
{
    _var = ITEM_VALUE(_x select 0);
    if (_var isEqualTo 0) exitWith {_exit = true;};
    if (_var < (_x select 1)) exitWith {_exit = true;};
    _totalConversions pushBack (floor (_var/(_x select 1)));
} forEach _oldItem;
if (_exit) exitWith {life_is_processing = false; [ localize "STR_NOTF_NotEnoughItemProcess",true,"fast"] call life_fnc_notification_system; life_action_inUse = false;};
if (_vendor in [mari_processor,coke_processor,heroin_processor]) then {
    _hasLicense = true;
} else {
    _hasLicense = LICENSE_VALUE(_type,"civ");
};
_cost = _cost * (count _oldItem);
_minimumConversions = _totalConversions call BIS_fnc_lowestNum;
_oldItemWeight = 0;
{
    _weight = ([_x select 0] call life_fnc_itemWeight) * (_x select 1);
    _oldItemWeight = _oldItemWeight + _weight;
} count _oldItem;
_newItemWeight = 0;
{
    _weight = ([_x select 0] call life_fnc_itemWeight) * (_x select 1);
    _newItemWeight = _newItemWeight + _weight;
} count _newItem;
_exit = false;
if (_newItemWeight > _oldItemWeight) then {
    _netChange = _newItemWeight - _oldItemWeight;
    _freeSpace = life_maxWeight - life_carryWeight;
    if (_freeSpace < _netChange) exitWith {_exit = true;};
    private _estConversions = floor(_freeSpace / _netChange);
    if (_estConversions < _minimumConversions) then {
        _minimumConversions = _estConversions;
    };
};
if (_exit) exitWith {[ localize "STR_Process_Weight",true,"fast"] call life_fnc_notification_system; life_is_processing = false; life_action_inUse = false;};
private _skillFactor = 1 - ((["process"] call life_fnc_skillBonus) / 100); //Skill Verarbeitung
//Setup our progress bar.
disableSerialization;
"progressBar" cutRsc ["life_progress","PLAIN"];
_ui = uiNamespace getVariable "life_progress";
_progress = _ui displayCtrl 38201;
_pgText = _ui displayCtrl 38202;
_pgText ctrlSetText format ["%2 (1%1)...","%",_upp];
_progress progressSetPosition 0.01;
_cP = 0.01;
life_is_processing = true;
if (_hasLicense) then {
    for "_i" from 0 to 1 step 0 do {
        uiSleep (0.28 * _skillFactor);
        _cP = _cP + 0.01;
        _progress progressSetPosition _cP;
        _pgText ctrlSetText format ["%3 (%1%2)...",round(_cP * 100),"%",_upp];
        if (_cP >= 1) exitWith {};
        if (player distance _vendor > 10) exitWith {};
    };
    if (player distance _vendor > 10) exitWith {[ localize "STR_Process_Stay",true,"fast"] call life_fnc_notification_system; "progressBar" cutText ["","PLAIN"]; life_is_processing = false; life_action_inUse = false;};
    "progressBar" cutText ["","PLAIN"];
    //Inventar-Umbau Paket 3: der Server prueft die Materialien und bucht beide Seiten
    if (INVENTORY_MODE >= 1) then {
        ["TON_fnc_invProcess", [_type, _minimumConversions], {
            (_this select 0) params [["_conv",0],["_complete",true]];
            ["process", _conv * (getNumber (missionConfigFile >> "CfgSkills" >> "process" >> "xpPerItem"))] call life_fnc_skillAddXP;
            if (_complete) then {[ localize "STR_NOTF_ItemProcess",false,"fast"] call life_fnc_notification_system} else {[ localize "STR_Process_Partial",true,"fast"] call life_fnc_notification_system};
        }, {
            [ localize "STR_NOTF_NotEnoughItemProcess",true,"fast"] call life_fnc_notification_system;
        }] call life_fnc_econRequest;
    } else {
        {
            [false,(_x select 0),((_x select 1)*(_minimumConversions))] call life_fnc_handleInv;
        } count _oldItem;
        {
            [true,(_x select 0),((_x select 1)*(_minimumConversions))] call life_fnc_handleInv;
        } count _newItem;
        ["process", _minimumConversions * (getNumber (missionConfigFile >> "CfgSkills" >> "process" >> "xpPerItem"))] call life_fnc_skillAddXP; //XP je Stueck
        if (_minimumConversions isEqualTo (_totalConversions call BIS_fnc_lowestNum)) then {[ localize "STR_NOTF_ItemProcess",false,"fast"] call life_fnc_notification_system;} else {[ localize "STR_Process_Partial",true,"fast"] call life_fnc_notification_system;};
    };
    life_is_processing = false; life_action_inUse = false;
} else {
    if (CASH < _cost) exitWith {[ format [localize "STR_Process_License",[_cost] call life_fnc_numberText],true,"fast"] call life_fnc_notification_system; "progressBar" cutText ["","PLAIN"]; life_is_processing = false; life_action_inUse = false;};
    for "_i" from 0 to 1 step 0 do {
        uiSleep (0.9 * _skillFactor);
        _cP = _cP + 0.01;
        _progress progressSetPosition _cP;
        _pgText ctrlSetText format ["%3 (%1%2)...",round(_cP * 100),"%",_upp];
        if (_cP >= 1) exitWith {};
        if (player distance _vendor > 10) exitWith {};
    };
    if (player distance _vendor > 10) exitWith {[ localize "STR_Process_Stay",true,"fast"] call life_fnc_notification_system; "progressBar" cutText ["","PLAIN"]; life_is_processing = false; life_action_inUse = false;};
    if (CASH < _cost) exitWith {[ format [localize "STR_Process_License",[_cost] call life_fnc_numberText],true,"fast"] call life_fnc_notification_system; "progressBar" cutText ["","PLAIN"]; life_is_processing = false; life_action_inUse = false;};
    if (ECONOMY_MODE >= 1) exitWith {
        //Geld-Umbau Schritt 2: die Gebuehr ohne Lizenz bucht der Server, verarbeitet wird erst nach seiner Zusage
        "progressBar" cutText ["","PLAIN"];
        life_is_processing = false;
        life_action_inUse = false;
        ["TON_fnc_econFee", ["process", _type], {
            (_this select 1) params ["_oldItem", "_newItem", "_conversions", "_complete", "_type"];
            //Inventar-Umbau Paket 3: ab Modus 1 bucht der Server die Materialien
            if (INVENTORY_MODE >= 1) exitWith {
                ["TON_fnc_invProcess", [_type, _conversions], {
                    (_this select 0) params [["_conv",0],["_complete",true]];
                    ["process", _conv * (getNumber (missionConfigFile >> "CfgSkills" >> "process" >> "xpPerItem"))] call life_fnc_skillAddXP;
                    if (_complete) then {[ localize "STR_NOTF_ItemProcess",false,"fast"] call life_fnc_notification_system} else {[ localize "STR_Process_Partial",true,"fast"] call life_fnc_notification_system};
                }, {
                    [ localize "STR_NOTF_NotEnoughItemProcess",true,"fast"] call life_fnc_notification_system;
                }] call life_fnc_econRequest;
            };
            private _removed = true;
            {
                if !([false,(_x select 0),((_x select 1)*_conversions)] call life_fnc_handleInv) exitWith {_removed = false;};
            } forEach _oldItem;
            if (!_removed) exitWith {[ localize "STR_NOTF_NotEnoughItemProcess",true,"fast"] call life_fnc_notification_system;};
            {
                [true,(_x select 0),((_x select 1)*_conversions)] call life_fnc_handleInv;
            } forEach _newItem;
            ["process", _conversions * (getNumber (missionConfigFile >> "CfgSkills" >> "process" >> "xpPerItem"))] call life_fnc_skillAddXP;
            if (_complete) then {[ localize "STR_NOTF_ItemProcess",false,"fast"] call life_fnc_notification_system;} else {[ localize "STR_Process_Partial",true,"fast"] call life_fnc_notification_system;};
        }, {
            [ format [localize "STR_Process_License",[(_this select 0) param [1, 0]] call life_fnc_numberText],true,"fast"] call life_fnc_notification_system;
        }, [_oldItem, _newItem, _minimumConversions, _minimumConversions isEqualTo (_totalConversions call BIS_fnc_lowestNum), _type]] call life_fnc_econRequest;
    };
    "progressBar" cutText ["","PLAIN"];
    if (INVENTORY_MODE >= 1) then {
        ["TON_fnc_invProcess", [_type, _minimumConversions], {
            (_this select 0) params [["_conv",0],["_complete",true]];
            ["process", _conv * (getNumber (missionConfigFile >> "CfgSkills" >> "process" >> "xpPerItem"))] call life_fnc_skillAddXP;
            if (_complete) then {[ localize "STR_NOTF_ItemProcess",false,"fast"] call life_fnc_notification_system} else {[ localize "STR_Process_Partial",true,"fast"] call life_fnc_notification_system};
        }, {
            [ localize "STR_NOTF_NotEnoughItemProcess",true,"fast"] call life_fnc_notification_system;
        }] call life_fnc_econRequest;
    } else {
        {
            [false,(_x select 0),((_x select 1)*(_minimumConversions))] call life_fnc_handleInv;
        } count _oldItem;
        {
            [true,(_x select 0),((_x select 1)*(_minimumConversions))] call life_fnc_handleInv;
        } count _newItem;
        ["process", _minimumConversions * (getNumber (missionConfigFile >> "CfgSkills" >> "process" >> "xpPerItem"))] call life_fnc_skillAddXP; //XP je Stueck
        if (_minimumConversions isEqualTo (_totalConversions call BIS_fnc_lowestNum)) then {[ localize "STR_NOTF_ItemProcess",false,"fast"] call life_fnc_notification_system;} else {[ localize "STR_Process_Partial",true,"fast"] call life_fnc_notification_system;};
    };
    CASH = CASH - _cost;
    [0] call SOCK_fnc_updatePartial;
    life_is_processing = false;
    life_action_inUse = false;
};
