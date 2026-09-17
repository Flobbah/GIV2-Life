#include "..\..\script_macros.hpp"
/*
    File: fn_dpFinish.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Finishes the DP Mission and calculates the money earned based
    on distance between A->B
*/
private ["_dp","_dis","_price"];
_dp = [_this,0,objNull,[objNull]] call BIS_fnc_param;
life_delivery_in_progress = false;
life_dp_point = nil;
if (ECONOMY_MODE >= 1) exitWith {
    //Geld-Umbau Schritt 3: Lohn nach Strecke, Fahrzeit und Stundengrenze prueft der Server
    life_cur_task setTaskState "Succeeded";
    player removeSimpleTask life_cur_task;
    [true] call life_fnc_navStop;
    ["TON_fnc_econIncome", ["deliveryFinish", _dp], {
        ["DeliverySucceeded",[format [(localize "STR_NOTF_Earned_1"),[(_this select 0) param [0, 0]] call life_fnc_numberText]]] call bis_fnc_showNotification;
    }, {
        ["DeliveryFailed",[localize "STR_NOTF_DPFailed"]] call BIS_fnc_showNotification;
    }] call life_fnc_econRequest;
};
_dis = round((getPos life_dp_start) distance (getPos _dp));
_price = round(0.5 * _dis);
["DeliverySucceeded",[format [(localize "STR_NOTF_Earned_1"),[_price] call life_fnc_numberText]]] call bis_fnc_showNotification;
life_cur_task setTaskState "Succeeded";
player removeSimpleTask life_cur_task;
[true] call life_fnc_navStop;
CASH = CASH + _price;
[0] call SOCK_fnc_updatePartial;