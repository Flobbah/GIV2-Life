#include "..\..\script_macros.hpp"
/*
    File: fn_fuelRefuelCar.sqf
    Author: NiiRoZz
    Description:
    Adds fuel in car.
*/
private _index = lbCurSel 20302;
private _classname = lbData[20302,_index];
if (isNil "_classname" || _classname isEqualTo "") exitWith {
    [ localize "STR_Select_Vehicle_Pump",true,"fast"] call life_fnc_notification_system;
    closeDialog 0;
};
private _vehicleFuelList = uiNamespace getVariable ["fuel_list",[]];
(_vehicleFuelList select _index) params ["_car"];
private _vehicleInfo = [_className] call life_fnc_fetchVehInfo;
private _fuelNow = fuel _car;
private _fueltank = _vehicleInfo select 12;
if (_car isKindOf "B_Truck_01_box_F" || _car isKindOf "B_Truck_01_transport_F") then {_fueltank = 350};//hemtt
if (_car isKindOf "C_Van_01_box_F") then {_fueltank = 100};
if (_car isKindOf "I_Truck_02_covered_F" || _car isKindOf "I_Truck_02_transport_F") then {_fueltank = 175};
private _fueltoput = ((parseNumber((sliderPosition 20901) toFixed 2))-(floor(_fuelnow * _fueltank)));
private _setfuel = _fuelnow + (_fueltoput/_fueltank);
private _timer = ((_fueltoput * .25)/100);
if (_car distance player > 10 && !(isNull objectParent player)) exitWith {
    [ localize "STR_Distance_Vehicle_Pump",true,"fast"] call life_fnc_notification_system;
    closeDialog 0;
};
private _fuelCost = uiNamespace getVariable ["fuel_cost",0];
if ((BANK - (_fueltoput * _fuelCost)) > 0) then {
    life_is_processing = true;
    //Setup our progress bar.
    disableSerialization;
    "progressBar" cutRsc ["life_progress","PLAIN"];
    private _ui = uiNameSpace getVariable "life_progress";
    private _progress = _ui displayCtrl 38201;
    private _pgText = _ui displayCtrl 38202;
    _pgText ctrlSetText format ["%2 (1%1)...","%","Refuel:"];
    _progress progressSetPosition 0.01;
    private _cP = 0.01;
    for "_i" from 0 to 1 step 0 do {
        uiSleep  _timer;
        _cP = _cP + 0.01;
        _progress progressSetPosition _cP;
        _pgText ctrlSetText format ["%3 (%1%2)...",round(_cP * 100),"%","Refuel:"];
        if (_cP >= 1) exitWith {};
        if (player distance _car > 10) exitWith {};
        if !(isNull objectParent player) exitWith {};
        if (((_cP * 100) mod 10) isEqualTo 0) then {
            ["life_fnc_setFuel",[_car,_cP * _setfuel],_car] call life_fnc_relaySend;
        };
    };
    private _toPay = floor((_fueltoput * _fuelCost) * _cP);
    if (ECONOMY_MODE >= 1) then {
        ["TON_fnc_econIncome", ["fuelPump", _car, floor (_fueltoput * _cP)]] call life_fnc_econRequest; //Geld-Umbau Schritt 3: Literpreis bucht der Server
    } else {
        BANK = BANK - _toPay; //pay the received fuel
    };
    ["life_fnc_setFuel",[_car,_cP * _setfuel],_car] call life_fnc_relaySend; //update the fuel
    "progressBar" cutText ["","PLAIN"];
    if (_car distance player > 10 || !(isNull objectParent player)) then {
        [ localize "STR_Distance_Vehicle_Pump",true,"fast"] call life_fnc_notification_system;
    };
    [0] call SOCK_fnc_updatePartial;
    life_is_processing = false;
} else {
    [ localize "STR_NOTF_NotEnoughMoney",true,"fast"] call life_fnc_notification_system;
};
closeDialog 0;