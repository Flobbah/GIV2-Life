#include "..\..\script_macros.hpp"
/*
	File: fn_bandage.sqf
	Author: ToxicRageTv
	Edit: Flobbah
	Credits: Original creator of the progress bar
	This script was created for the Altis Life RPG community.
*/
if (!alive player) exitWith {[localize "STR_Bandage_Error_Dead",true,"fast"] call life_fnc_notification_system};
if (life_inv_bandage < 1) exitWith {[localize "STR_Bandage_Error_NoBandages",true,"fast"] call life_fnc_notification_system};
if (life_action_inUse) exitWith {[localize "STR_Bandage_Error_InAction",true,"fast"] call life_fnc_notification_system};
if !(isNull objectParent player) exitWith {[localize "STR_Bandage_Error_InVehicle",true,"fast"] call life_fnc_notification_system};
life_interrupted = false;
_configSide = switch (life_side) do {
	case civilian: {"Civilian"};
	case west: {"Cop"};
	case independent: {"Medic"};
	default {"Civilian"};
};
_bandageMode = getNumber(missionConfigFile >> "Config_Bandage" >> _configSide >> "bandageSetHealth");
_maxHealth = getNumber(missionConfigFile >> "Config_Bandage" >> _configSide >> "bandageMaxHealth");
if (damage player <= _maxHealth) exitWith {[localize "STR_Bandage_Error_MaxHealing",true,"fast"] call life_fnc_notification_system};
_bandageTime = getNumber(missionConfigFile >> "Config_Bandage" >> _configSide >> "bandageTime");
_sleepTime = _bandageTime / 100;
life_action_inUse = true;
//Setup our progress bar.
disableSerialization;
"progressBar" cutRsc ["life_progress","PLAIN"];
_ui = uiNamespace getVariable "life_progress";
_progress = _ui displayCtrl 38201;
_pgText = _ui displayCtrl 38202;
_pgText ctrlSetText format [localize "STR_Bandage_ProgressBar","%"];
_progress progressSetPosition 0.01;
_cP = 0.01;
private _anim = "Acts_TreatingWounded_loop";
["start",_anim] call life_fnc_actionAnim;
for "_i" from 0 to 1 step 0 do {
	["keep",_anim] call life_fnc_actionAnim;
	uiSleep _sleepTime;
	_cP = _cP + 0.01;
	_progress progressSetPosition _cP;
	_pgText ctrlSetText format [localize "STR_Bandage_ProgressBar2",round(_cP * 100),"%"];
	if (_cP >= 1) exitWith {};
	if (!alive player) exitWith {};
	if !(isNull objectParent player) exitWith {};
	if (life_interrupted) exitWith {};
};
life_action_inUse = false;
"progressBar" cutText ["","PLAIN"];
["stop"] call life_fnc_actionAnim;
if (life_interrupted) exitWith {life_interrupted = false; [localize "STR_Bandage_Error_CancelBandage",true,"fast"] call life_fnc_notification_system; life_action_inUse = false;};
if !(isNull objectParent player) exitWith {[localize "STR_Bandage_Error_CancelBandage_Vehicle",true,"fast"] call life_fnc_notification_system;};
if (_bandageMode == 1) then {
	//Set health
	player setDamage _maxHealth;
} else {
	//Add to health
	_curHealth = damage player;
	_newHealth = _curHealth - getNumber(missionConfigFile >> "Config_Bandage" >> _configSide >> "bandageHealing");
	if (_newHealth < _maxHealth) then {
		player setDamage _maxHealth;
	} else {
		player setDamage _newHealth;
	};
};
[false,"bandage",1] call life_fnc_handleInv;
[localize "STR_Bandage_Success",false,"fast"] call life_fnc_notification_system;