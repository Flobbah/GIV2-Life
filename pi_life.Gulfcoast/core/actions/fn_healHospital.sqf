#include "..\..\script_macros.hpp"
/*
    File: fn_healHospital.sqf
    Author: Bryan "Tonic" Boardwine
    Reworked: Jesse "TKCJesse" Schultz
    Description:
    Prompts user with a confirmation dialog to heal themselves.
    Used at the hospitals to restore health to full.
    Note: Dialog helps stop a few issues regarding money loss.
*/
private ["_healCost","_action"];
if (life_action_inUse) exitWith {};
if ((damage player) < 0.01) exitWith {[ localize "STR_NOTF_HS_FullHealth",true,"fast"] call life_fnc_notification_system;};
_healCost = LIFE_SETTINGS(getNumber,"hospital_heal_fee");
if (CASH < _healCost) exitWith {[ format [localize "STR_NOTF_HS_NoCash",[_healCost] call life_fnc_numberText],true,"fast"] call life_fnc_notification_system;};
life_action_inUse = true;
_action = [
    format [localize "STR_NOTF_HS_PopUp",[_healCost] call life_fnc_numberText],
    localize "STR_NOTF_HS_TITLE",
    localize "STR_Global_Yes",
    localize "STR_Global_No"
] call BIS_fnc_guiMessage;
if (_action) then {
    titleText[localize "STR_NOTF_HS_Healing","PLAIN"];
    closeDialog 0;
    uiSleep 8;
    if (player distance (_this select 0) > 5) exitWith {life_action_inUse = false; titleText[localize "STR_NOTF_HS_ToFar","PLAIN"]};
    if (ECONOMY_MODE >= 1) exitWith {
        //Geld-Umbau Schritt 2: die Gebuehr bucht der Server, geheilt wird nach seiner Zusage (vorher nie gespeichert)
        life_action_inUse = false;
        ["TON_fnc_econFee", ["hospital"], {
            titleText[localize "STR_NOTF_HS_Healed","PLAIN"];
            player setDamage 0;
        }, {
            [ format [localize "STR_NOTF_HS_NoCash",[(_this select 1) select 0] call life_fnc_numberText],true,"fast"] call life_fnc_notification_system;
        }, [_healCost]] call life_fnc_econRequest;
    };
    titleText[localize "STR_NOTF_HS_Healed","PLAIN"];
    player setDamage 0;
    CASH = CASH - _healCost;
    life_action_inUse = false;
} else {
    [ localize "STR_NOTF_ActionCancel",true,"fast"] call life_fnc_notification_system;
    closeDialog 0;
    life_action_inUse = false;
};
