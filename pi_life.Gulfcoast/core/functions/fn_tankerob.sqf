/*
	Author: moeck edit by Deathman
	File: fn_tankerob.sqf
*/
#include "..\..\script_macros.hpp"
private["_robber","_shop","_kassa","_ui","_progress","_pgText","_cP","_rip","_pos", "_robdelay", "_delay","_onWanted","_Max_Distance_ShopText","_Max_Distance_Shop","_RoberDelay","_ATMuse","_Rob_Finish","_MarkerType","_MarkerText","_MarkerColor","_CreatMarkerName","_Stay_DistanceText","_ProgressBarText","_PoliceText_Fail","_Message_To_Police","_Max_Police","_Max_Distance_Text","_Max_Distance","_max_money_rob","_max_money_rob_random","_FailText_1","_FailText_2","_FailText_3","_FailText_4","_FailText_5","_FailText_6","_FailText_7","_FailText_8","_FailText_9"];
_max_money_rob = getnumber(missionConfigFile >> "TankeRob_Master" >> "Max_Money_Rob");
_max_money_rob_random = getnumber(missionConfigFile >> "TankeRob_Master" >> "Max_Money_Rob_Random");
_FailText_1 = localize "STR_FailText_1";
_FailText_2 = localize "STR_FailText_2";
_FailText_3 = localize "STR_FailText_3";
_FailText_4 = localize "STR_FailText_4";
_FailText_5 = localize "STR_FailText_5";
_FailText_6 = localize "STR_FailText_6";
_FailText_7 = localize "STR_FailText_7";
_FailText_8 = localize "STR_FailText_8";
_FailText_9 = localize "STR_FailText_9";
_Max_Distance = getnumber(missionConfigFile >> "TankeRob_Master" >> "Max_Distance");
_Max_Distance_Text = localize "STR_Max_Distance_Text";
_Max_Distance_Shop = getnumber(missionConfigFile >> "TankeRob_Master" >> "Max_Distance_Shop");
_Max_Distance_ShopText = localize "STR_Max_Distance_Shop_Text";
_Max_Police = getnumber(missionConfigFile >> "TankeRob_Master" >> "Max_Police");
_Message_To_Police = localize "STR_Message_To_Police";
_PoliceText_Fail = localize "STR_PoliceText_Fail";
_ProgressBarText = localize "STR_ProgressBarText";
_Stay_DistanceText = localize "STR_Stay_DistanceText";
_CreatMarkerName= getText(missionConfigFile >> "TankeRob_Master" >> "CreatMarkerName");
_MarkerColor = getText(missionConfigFile >> "TankeRob_Master" >> "MarkerColor");
_MarkerText = localize "STR_MarkerText";
_MarkerType = getText(missionConfigFile >> "TankeRob_Master" >> "MarkerType");
_Rob_Finish = localize "STR_Rob_Finish";
_ATMuse = getnumber(missionConfigFile >> "TankeRob_Master" >> "ATMuse");
_RoberDelay = getnumber(missionConfigFile >> "TankeRob_Master" >> "RoberDelay");
_shop = [_this,0,ObjNull,[ObjNull]] call BIS_fnc_param; //The object that has the action attached to it is _this. ,0, is the index of object, ObjNull is the default should there be nothing in the parameter or it's broken
_robber = [_this,1,ObjNull,[ObjNull]] call BIS_fnc_param; //Can you guess? Alright, it's the player, or the "caller". The object is 0, the person activating the object is 1
_kassa = 1000; //The amount the shop has to rob, you could make this a parameter of the call (https://community.bistudio.com/wiki/addAction). Give it a try and post below ;)
_action = [_this,2] call BIS_fnc_param;//Action name
if (SIDE_OF(_robber) in [west, independent]) exitwith {
	if(getNumber(missionConfigFile >> "TankeRob_Master" >> "DE100_Notifiactionssytsem") isEqualTo 1) then {
		[_FailText_1,"RED",10] spawn life_fnc_notification_system;
	} else {
		[ _FailText_1,true,"fast"] call life_fnc_notification_system;
	};
 };
if (life_firstrob) exitWith {
	if(getNumber(missionConfigFile >> "TankeRob_Master" >> "DE100_Notifiactionssytsem") isEqualTo 1) then {
		[_FailText_2,"RED",10] spawn life_fnc_notification_system;
	} else {
		[ _FailText_2,true,"fast"] call life_fnc_notification_system;
	};
};
if (servertime < life_nextrob) exitWith {
	if(getNumber(missionConfigFile >> "TankeRob_Master" >> "DE100_Notifiactionssytsem") isEqualTo 1) then {
		[format [_FailText_3, [(life_nextrob - servertime),"MM:SS"] call BIS_fnc_secondsToString],"RED",10] spawn life_fnc_notification_system;
	} else {
		[ format [_FailText_3, [(life_nextrob - servertime),"MM:SS"] call BIS_fnc_secondsToString],true,"fast"] call life_fnc_notification_system;
	};
};
_robdelay = _RoberDelay; // 900 Zeit die zwischen zwei Überfällen vergehen muss.
if(SIDE_OF(_robber) != civilian) exitWith {
	if(getNumber(missionConfigFile >> "TankeRob_Master" >> "DE100_Notifiactionssytsem") isEqualTo 1) then {
		[_FailText_4,"RED",10] spawn life_fnc_notification_system;
	} else {
		[ _FailText_4,true,"fast"] call life_fnc_notification_system;
	};
};
if(_robber distance _shop > _Max_Distance) exitWith {
	if(getNumber(missionConfigFile >> "TankeRob_Master" >> "DE100_Notifiactionssytsem") isEqualTo 1) then {
		[_Max_Distance_Text,"RED",10] spawn life_fnc_notification_system;
	} else {
		[ _Max_Distance_Text,true,"fast"] call life_fnc_notification_system;
	};
};
//if !(_kassa) then { _kassa = 1000; };
if (vehicle player != _robber) exitWith {
	if(getNumber(missionConfigFile >> "TankeRob_Master" >> "DE100_Notifiactionssytsem") isEqualTo 1) then {
		[_FailText_5,"RED",10] spawn life_fnc_notification_system;
	} else {
		[ _FailText_5,true,"fast"] call life_fnc_notification_system;
	};
};
if !(alive _robber) exitWith {};
if (currentWeapon _robber isEqualTo "") exitWith {
	if(getNumber(missionConfigFile >> "TankeRob_Master" >> "DE100_Notifiactionssytsem") isEqualTo 1) then {
		[_FailText_6,"RED",10] spawn life_fnc_notification_system;
	} else {
		[ _FailText_6,true,"fast"] call life_fnc_notification_system;
	};
};
_cops = (({SIDE_OF(_x) isEqualTo west} count playableUnits));
if(_cops < _Max_Police) exitWith{
	if(getNumber(missionConfigFile >> "TankeRob_Master" >> "DE100_Notifiactionssytsem") isEqualTo 1) then {
		[_PoliceText_Fail,"RED",10] spawn life_fnc_notification_system;
	} else {
		[ _PoliceText_Fail,true,"fast"] call life_fnc_notification_system;
	};
};
if (_kassa isEqualTo 0) exitWith {
	if(getNumber(missionConfigFile >> "TankeRob_Master" >> "DE100_Notifiactionssytsem") isEqualTo 1) then {
		[_FailText_7,"RED",10] spawn life_fnc_notification_system;
	} else {
		[ _FailText_7,true,"fast"] call life_fnc_notification_system;
	};
};
_rip = true;
_onWanted = false;
_kassa = _max_money_rob + round(random _max_money_rob_random);
_shop removeAction _action;
_chance = random(100);
if (_chance >= 33 && _chance < 66) then { [1,[ parseText format["<img size='10' color='#FFFFFF' image='\pi_data\textures\info.paa'/><br/><br/>" + (_Message_To_Police)]] remoteExec ["life_fnc_broadcast",west],true,"fast"] call life_fnc_notification_system; };
if(_chance >= 66) then {
	if(getNumber(missionConfigFile >> "TankeRob_Master" >> "DE100_Notifiactionssytsem") isEqualTo 1) then {
		[_FailText_8,"PINK",5] spawn life_fnc_notification_system;
	} else {
		[ _FailText_8,true,"fast"] call life_fnc_notification_system;
	};
 [1,[ parseText format["<img size='10' color='#FFFFFF' image='\pi_data\textures\info.paa'/><br/><br/>" + (_Message_To_Police)]] remoteExec ["life_fnc_broadcast",west],true,"fast"] call life_fnc_notification_system;
};
disableSerialization;
5 cutRsc ["life_progress","PLAIN"];
_ui = uiNameSpace getVariable "life_progress";
_progress = _ui displayCtrl 38201;
_pgText = _ui displayCtrl 38202;
_pgText ctrlSetText format[_ProgressBarText,"%"];
_progress progressSetPosition 0.01;
_cP = 0.01;
if(_rip) then
{
 life_nextrob = servertime + _robdelay;
 publicVariable "life_nextrob";
 while{true} do
 {
 sleep 1.5;
 _cP = _cP + 0.01;
 _progress progressSetPosition _cP;
 _pgText ctrlSetText format[_Stay_DistanceText,round(_cP * 100),"%"];
 _Pos = position player; // by ehno: get player pos
 if (_chance >= 66) then {
 _marker = createMarker [_CreatMarkerName, _Pos]; //by ehno: Place a Maker on the map
 _CreatMarkerName setMarkerColor _MarkerColor;
 _CreatMarkerName setMarkerText _MarkerText;
 _CreatMarkerName setMarkerType _MarkerType;
 };
 if(_cP >= 1) exitWith {};
 if(_robber distance _shop > _Max_Distance_Shop) exitWith {
 deleteMarker _CreatMarkerName;
	if(getNumber(missionConfigFile >> "TankeRob_Master" >> "DE100_Notifiactionssytsem") isEqualTo 1) then {
		[_Max_Distance_ShopText,"RED",10] spawn life_fnc_notification_system;
	} else {
		[ _Max_Distance_ShopText,true,"fast"] call life_fnc_notification_system;
	};
 5 cutText ["","PLAIN"]; _rip = false;
 };
 if!(alive _robber) exitWith {deleteMarker _CreatMarkerName; _rip = false; 5 cutText ["","PLAIN"];};
 if(life_istazed) exitWith {deleteMarker _CreatMarkerName; _rip = false; 5 cutText ["","PLAIN"];};
 if(player getVariable ["Re-strained",FALSE]) exitWith { deleteMarker _CreatMarkerName; _rip = false; 5 cutText ["","PLAIN"];};
 if (currentWeapon _robber isEqualTo "") exitWith {
	if(getNumber(missionConfigFile >> "TankeRob_Master" >> "DE100_Notifiactionssytsem") isEqualTo 1) then {
		[_FailText_9,"RED",10] spawn life_fnc_notification_system;
	} else {
		[ _FailText_9,true,"fast"] call life_fnc_notification_system;
	};
 deleteMarker _CreatMarkerName; _rip = false; 5 cutText ["","PLAIN"];
 };
 };
 if!(alive _robber) exitWith { _rip = false; deleteMarker _CreatMarkerName; 5 cutText ["","PLAIN"];};
 if(life_istazed) exitWith {deleteMarker _CreatMarkerName; _rip = false; 5 cutText ["","PLAIN"];};
 if(player getVariable ["Re-strained",FALSE]) exitWith { deleteMarker _CreatMarkerName; _rip = false; 5 cutText ["","PLAIN"];};
 if (currentWeapon _robber isEqualTo "") exitWith {deleteMarker _CreatMarkerName; _rip = false; 5 cutText ["","PLAIN"]; };
 if(_robber distance _shop > _Max_Distance_Shop) exitWith { deleteMarker _CreatMarkerName; 5 cutText ["","PLAIN"]; _rip = false; };
 5 cutText ["","PLAIN"];
	if(getNumber(missionConfigFile >> "TankeRob_Master" >> "DE100_Notifiactionssytsem") isEqualTo 1) then {
		[format[_Rob_Finish,[_kassa] call life_fnc_numberText],"PINK",5] spawn life_fnc_notification_system;
	} else {
		titleText[format[_Rob_Finish,[_kassa] call life_fnc_numberText],"PLAIN"];
	};
 deleteMarker _CreatMarkerName; // by ehno delete maker
life_cash = life_cash + _kassa;
_rip = false;
life_use_atm = false;
uiSleep (_ATMuse + random(180));
life_use_atm = true;
if!(alive _robber) exitWith {};
};
if !(_onWanted) then {
 if!(_chance < 10) then {
 _chance = random 100;
 if(_chance < 40) then {
 [getPlayerUID _robber,name _robber,"23"] remoteExecCall ["life_fnc_wantedAdd",2];
 };
 };
};
_action = _shop addAction[localize "STR_Rob_Action",life_fnc_tankerob];