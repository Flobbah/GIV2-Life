#include "..\..\script_macros.hpp"
/*
    File: fn_jerryRefuel.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Refuels the vehicle if the player has a fuel can.
*/
private ["_vehicle","_displayName","_upp","_ui","_progress","_pgText","_cP","_previousState"];
_vehicle = cursorObject;
life_interrupted = false;
if (isNull _vehicle) exitWith {[ localize "STR_ISTR_Jerry_NotLooking",true,"fast"] call life_fnc_notification_system};
if (!(_vehicle isKindOF "LandVehicle") && !(_vehicle isKindOf "Air") && !(_vehicle isKindOf "Ship")) exitWith {};
if (player distance _vehicle > 7.5) exitWith {[ localize "STR_ISTR_Jerry_NotNear",true,"fast"] call life_fnc_notification_system};
if (INVENTORY_MODE isEqualTo 0 && {!([false,"fuelFull",1] call life_fnc_handleInv)}) exitWith {};
if (INVENTORY_MODE >= 1 && {life_inv_fuelFull < 1}) exitWith {};
life_action_inUse = true;
_displayName = FETCH_CONFIG2(getText,"CfgVehicles",(typeOf _vehicle),"displayName");
_upp = format [localize "STR_ISTR_Jerry_Process",_displayName];
//Setup our progress bar.
disableSerialization;
"progressBar" cutRsc ["life_progress","PLAIN"];
_ui = uiNamespace getVariable "life_progress";
_progress = _ui displayCtrl 38201;
_pgText = _ui displayCtrl 38202;
_pgText ctrlSetText format ["%2 (1%1)...","%",_upp];
_progress progressSetPosition 0.01;
_cP = 0.01;
private _anim = "Acts_carFixingWheel";
["start",_anim] call life_fnc_actionAnim;
for "_i" from 0 to 1 step 0 do {
    ["keep",_anim] call life_fnc_actionAnim;
    uiSleep 0.2;
    if (isNull _ui) then {
        "progressBar" cutRsc ["life_progress","PLAIN"];
        _ui = uiNamespace getVariable "life_progress";
        _progressBar = _ui displayCtrl 38201;
        _titleText = _ui displayCtrl 38202;
    };
    _cP = _cP + 0.01;
    _progress progressSetPosition _cP;
    _pgText ctrlSetText format ["%3 (%1%2)...",round(_cP * 100),"%",_upp];
    if (_cP >= 1) exitWith {};
    if (!alive player) exitWith {};
    if (life_interrupted) exitWith {};
};
life_action_inUse = false;
"progressBar" cutText ["","PLAIN"];
["stop"] call life_fnc_actionAnim;
if (!alive player) exitWith {};
if (life_interrupted) exitWith {life_interrupted = false; titleText[localize "STR_NOTF_ActionCancel","PLAIN"];};
switch (true) do {
    case (_vehicle isKindOF "LandVehicle"): {
        if (!local _vehicle) then {
            ["life_fnc_setFuel",[_vehicle,(Fuel _vehicle) + 0.5],_vehicle] call life_fnc_relaySend;
        } else {
            _vehicle setFuel ((Fuel _vehicle) + 0.5);
        };
    };
    case (_vehicle isKindOf "Air"): {
        if (!local _vehicle) then {
            ["life_fnc_setFuel",[_vehicle,(Fuel _vehicle) + 0.2],_vehicle] call life_fnc_relaySend;
        } else {
            _vehicle setFuel ((Fuel _vehicle) + 0.2);
        };
    };
    case (_vehicle isKindOf "Ship"): {
        if (!local _vehicle) then {
            ["life_fnc_setFuel",[_vehicle,(Fuel _vehicle) + 0.35],_vehicle] call life_fnc_relaySend;
        } else {
            _vehicle setFuel ((Fuel _vehicle) + 0.35);
        };
    };
};
titleText[format [localize "STR_ISTR_Jerry_Success",_displayName],"PLAIN"];
//Inventar-Umbau: ab Modus 1 tauscht der Server voll gegen leer
if (INVENTORY_MODE >= 1) then {
    ["TON_fnc_invConvert", ["fuelFull", "fuelEmpty"], {}, {}] call life_fnc_econRequest;
} else {
    [true,"fuelEmpty",1] call life_fnc_handleInv;
};