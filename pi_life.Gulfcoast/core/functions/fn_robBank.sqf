#include "..\..\script_macros.hpp"
/*
File: fn_robBank.sqf
Author: cmdFlow
Edit: DevB | Flobbah
Description:
Script to call on a laptop when nearby bank, to rob it
*/
private["_robber","_bank","_cops","_canRob","_minCops","_startRob","_chance","_ui","_progress","_pgText","_cP","_Pos","_marker","_laptop"];
_robber = player;
_bank = nearestObject [player, "Land_CommonwealthBank"];
_canRob = _bank getVariable ["canRob",true];
_cops = (({SIDE_OF(_x) isEqualTo west} count playableUnits));
_chance = random(100);
_startRob = false;
_minCops = 4;
if(_cops < _minCops) exitWith { [ localize "STR_Bank_MinCops",true,"fast"] call life_fnc_notification_system};
if (!_canRob) exitWith { [ localize "STR_Bank_BankTimer",true,"fast"] call life_fnc_notification_system};
if (life_side != civilian) exitWith { [ localize "STR_Bank_CopRobBank",true,"fast"] call life_fnc_notification_system};
if (player distance _bank > 8) exitWith { [ localize "STR_Bank_TooFar",true,"fast"] call life_fnc_notification_system};
if (vehicle player != player) exitWith { [ localize "STR_Bank_InVeh",true,"fast"] call life_fnc_notification_system};
if (ECONOMY_MODE isEqualTo 0 && {_chance < 50}) exitWith { [ localize "STR_Bank_Fail",true,"fast"] call life_fnc_notification_system};
if (ECONOMY_MODE isEqualTo 0 && {DevB_BankRobbing}) exitWith { [ localize "STR_Bank_RobAlready",true,"fast"] call life_fnc_notification_system};
if !(alive player) exitWith {};
if (_startRob) exitWith {};
if (ECONOMY_MODE >= 1) then {
	//Geld-Umbau Schritt 2: Start (Polizei, Pause, nur ein Bankraub gleichzeitig, Zufall) entscheidet der Server
	private _start = ["TON_fnc_econRobbery", ["bankStart", _bank]] call life_fnc_econAwait;
	if !(_start select 0) then {
		private _key = switch ((_start select 1) param [0, ""]) do {
			case "chance": {"STR_Bank_Fail"};
			case "busy": {"STR_Bank_RobAlready"};
			case "cooldown": {"STR_Bank_BankTimer"};
			case "police": {"STR_Bank_MinCops"};
			case "side": {"STR_Bank_CopRobBank"};
			default {"STR_Bank_TooFar"};
		};
		[localize _key,true,"fast"] call life_fnc_notification_system;
		_serverDenied = true;
	};
};
if (!isNil "_serverDenied") exitWith {};
_startRob = true;
_bank setVariable ["canRob",false,false];
if (ECONOMY_MODE isEqualTo 0) then {
	DevB_BankRobbing = true;
	publicVariable "DevB_BankRobbing";
};
["life_fnc_broadcast",[2,format[localize "STR_Bank_CopNotification", _bank]],west] call life_fnc_relaySend;
["life_fnc_broadcast",[1,format[localize "STR_Bank_CopNotification", _bank]],west] call life_fnc_relaySend;
disableSerialization;
5 cutRsc ["life_progress","PLAIN"];
_ui = uiNameSpace getVariable "life_progress";
_progress = _ui displayCtrl 38201;
_pgText = _ui displayCtrl 38202;
_pgText ctrlSetText format[localize "STR_Bank_Hacking","%"];
_progress progressSetPosition 0.01;
_cP = 0.0001;
if(_startRob) then {
	for "_i" from 0 to 1 step 0 do {
		//Bankraubzeit von 20min
		uiSleep 12;
		_cP = _cP + 0.01;
		_progress progressSetPosition _cP;
		_pgText ctrlSetText format[localize "STR_Bank_Hacking2",round(_cP * 100),"%"];
		_Pos = position player;
		_marker = createMarker ["Marker200", _Pos];
		"Marker200" setMarkerColor "ColorRed";
		"Marker200" setMarkerText localize "STR_Bank_MarkerName";
		"Marker200" setMarkerType "mil_warning";
		if(_cP >= 1) exitWith {};
		if(player distance _bank > 11) exitWith { };
		if!(alive player) exitWith {};
	};
	if!(alive player) exitWith { _startRob = false; if (ECONOMY_MODE >= 1) then {["TON_fnc_econRobbery", ["bankAbort", _bank]] call life_fnc_econRequest;}; };
	if(_robber distance _bank > 11) exitWith {
		5 cutText ["","PLAIN"];
		deleteMarker "Marker200";
		[localize "STR_Bank_Distance",true,"fast"] call life_fnc_notification_system;
		_startRob = false;
		if (ECONOMY_MODE >= 1) then {["TON_fnc_econRobbery", ["bankAbort", _bank]] call life_fnc_econRequest;} else {
			DevB_BankRobbing = false;
			publicVariable "DevB_BankRobbing";
		};
	};
	_bank animate ["Vault_Combination",1];
	_bank animate ["Vault_RotateUp",1];
	_bank animate ["Vault_RotateDown",1];
	_bank animate ["Vault_RotateDown",1];
	_bank animate ["Vault_TransitionUp",-0.1];
	_bank animate ["Vault_TransitionDown",0.1];
	_bank animate ["Vault_TransitionLeft",-0.1];
	_bank animate ["Vault_TransitionRight",0.1];
	_bank animate ["Vault_Door",1];
	_pos = _bank modelToWorld[1,-3,3];
	_pos = [(_pos select 0),(_pos select 1),4];
	if (ECONOMY_MODE >= 1) then {
		//Geld-Umbau Schritt 2: das Beute-Buendel erzeugt der Server mit gespeichertem Wert (nur nach voller Dauer)
		private _finish = ["TON_fnc_econRobbery", ["bankFinish", _bank]] call life_fnc_econAwait;
		if !(_finish select 0) then {[localize "STR_Bank_Distance",true,"fast"] call life_fnc_notification_system;};
	} else {
		_moneyAmount = 60000 + round(random 60000);
		_pos = _bank modelToWorld[1,-3,3];
		_pos = [(_pos select 0),(_pos select 1),4];
		_obj = "Land_Money_F" createVehicle _pos;
		_obj setVariable ["item",["money",_moneyAmount],true];
		_obj setPos _pos;
	};
	_smoke = "SmokeShellYellow" createVehicle [0,0,9999];
	_smoke setPos _pos;
	_smoke setVelocity [100,0,0];
	_startRob = false;
	life_use_atm = false;
	sleep (30 + random(180));
	deleteMarker "Marker200";
	life_use_atm = true;
	5 cutText ["","PLAIN"];
	if (ECONOMY_MODE isEqualTo 0) then {
		DevB_BankRobbing = false;
		publicVariable "DevB_BankRobbing";
	};
};
_bank spawn {
	sleep 1800;
	_this setVariable ["canRob", true, true];
};