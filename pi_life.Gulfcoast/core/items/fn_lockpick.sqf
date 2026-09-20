#include "..\..\script_macros.hpp"
/*
    File: fn_lockpick.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Main functionality for lock-picking.
*/
private ["_curTarget","_distance","_isVehicle","_title","_progressBar","_cP","_titleText","_dice","_badDistance"];
_curTarget = cursorObject;
life_interrupted = false;
if (life_action_inUse) exitWith {};
if (isNull _curTarget) exitWith {}; //Bad type
_distance = ((boundingBox _curTarget select 1) select 0) + 2;
if (player distance _curTarget > _distance) exitWith {}; //Too far
_isVehicle = if ((_curTarget isKindOf "LandVehicle") || (_curTarget isKindOf "Ship") || (_curTarget isKindOf "Air")) then {true} else {false};
if (_isVehicle && _curTarget in life_vehicles) exitWith {[ localize "STR_ISTR_Lock_AlreadyHave",true,"fast"] call life_fnc_notification_system};
//More error checks
if (!_isVehicle && !isPlayer _curTarget) exitWith {};
if (!_isVehicle && !(_curTarget getVariable ["restrained",false])) exitWith {};
if (_curTarget getVariable "NPC") exitWith {[ localize "STR_NPC_Protected",true,"fast"] call life_fnc_notification_system};
_title = format [localize "STR_ISTR_Lock_Process",if (!_isVehicle) then {"Handcuffs"} else {getText(configFile >> "CfgVehicles" >> (typeOf _curTarget) >> "displayName")}];
life_action_inUse = true; //Lock out other actions
private _skillFactor = 1 - ((["lockpick"] call life_fnc_skillBonus) / 100); //Skill Dietrich
//Setup the progress bar
disableSerialization;
"progressBar" cutRsc ["life_progress","PLAIN"];
_ui = uiNamespace getVariable "life_progress";
_progressBar = _ui displayCtrl 38201;
_titleText = _ui displayCtrl 38202;
_titleText ctrlSetText format ["%2 (1%1)...","%",_title];
_progressBar progressSetPosition 0.01;
_cP = 0.01;
private _anim = if (_isVehicle) then {"Acts_carFixingWheel"} else {"Acts_TreatingWounded_loop"};
["start",_anim] call life_fnc_actionAnim;
for "_i" from 0 to 1 step 0 do {
    ["keep",_anim] call life_fnc_actionAnim;
    uiSleep (0.26 * _skillFactor);
    if (isNull _ui) then {
        "progressBar" cutRsc ["life_progress","PLAIN"];
        _ui = uiNamespace getVariable "life_progress";
        _progressBar = _ui displayCtrl 38201;
        _titleText = _ui displayCtrl 38202;
    };
    _cP = _cP + 0.01;
    _progressBar progressSetPosition _cP;
    _titleText ctrlSetText format ["%3 (%1%2)...",round(_cP * 100),"%",_title];
    if (_cP >= 1 || !alive player) exitWith {};
    if (life_istazed) exitWith {}; //Tazed
    if (life_isknocked) exitWith {}; //Knocked
    if (life_interrupted) exitWith {};
    if (player getVariable ["restrained",false]) exitWith {};
    if (player distance _curTarget > _distance) exitWith {_badDistance = true;};
};
//Kill the UI display and check for various states
"progressBar" cutText ["","PLAIN"];
["stop"] call life_fnc_actionAnim;
if (!alive player || life_istazed || life_isknocked) exitWith {life_action_inUse = false;};
if (player getVariable ["restrained",false]) exitWith {life_action_inUse = false;};
if (!isNil "_badDistance") exitWith {titleText[localize "STR_ISTR_Lock_TooFar","PLAIN"]; life_action_inUse = false;};
if (life_interrupted) exitWith {life_interrupted = false; titleText[localize "STR_NOTF_ActionCancel","PLAIN"]; life_action_inUse = false;};
if (!([false,"lockpick",1] call life_fnc_handleInv)) exitWith {life_action_inUse = false;};
life_action_inUse = false;
if (!_isVehicle) then {
    //Sicherheitsprüfung #7: den Zustand setzt der Server (TON_fnc_custody), nicht der Client
    [_curTarget,"pick"] remoteExecCall ["TON_fnc_custody",RSERV];
} else {
    _dice = random(100);
    if (_dice < (30 + (["lockpick","bonus2PerLevel"] call life_fnc_skillBonus))) then { //Skill Dietrich: Erfolgschance
        titleText[localize "STR_ISTR_Lock_Success","PLAIN"];
        ["lockpick"] call life_fnc_skillAddXP;
        life_vehicles pushBack _curTarget;
        if (LIFE_HC_ACTIVE) then {
            [getPlayerUID player,profileName,"487"] remoteExecCall ["HC_fnc_wantedAdd",HC_Life];
        } else {
            [getPlayerUID player,profileName,"487"] remoteExecCall ["life_fnc_wantedAdd",RSERV];
        };
    } else {
        if (LIFE_HC_ACTIVE) then {
            [getPlayerUID player,profileName,"215"] remoteExecCall ["HC_fnc_wantedAdd",HC_Life];
        } else {
            [getPlayerUID player,profileName,"215"] remoteExecCall ["life_fnc_wantedAdd",RSERV];
        };
        ["life_fnc_broadcast",[0,"STR_ISTR_Lock_FailedNOTF",true,[profileName]],west] call life_fnc_relaySend;
        titleText[localize "STR_ISTR_Lock_Failed","PLAIN"];
        ["lockpick",1] call life_fnc_skillAddXP;
    };
};
