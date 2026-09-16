#include "..\..\script_macros.hpp"
/*
    File: fn_gangNewLeader.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Something about being a quitter.
*/
private ["_unit","_unitID","_members","_action","_index"];
disableSerialization;
if ((lbCurSel 2621) isEqualTo -1) exitWith {[ localize "STR_GNOTF_TransferSelect",false,"fast"] call life_fnc_notification_system};
_unit = call compile format ["%1",CONTROL_DATA(2621)];
if (isNull _unit) exitWith {}; //Bad unit?
if (_unit == player) exitWith {[ localize "STR_GNOTF_TransferSelf",true,"fast"] call life_fnc_notification_system};
_action = [
    format [localize "STR_GNOTF_TransferMSG",_unit getVariable ["realname",name _unit]],
    localize "STR_Gang_Transfer",
    localize "STR_Global_Yes",
    localize "STR_Global_No"
] call BIS_fnc_guiMessage;
if (_action) then {
    _unitID = getPlayerUID _unit;
    if (_unitID isEqualTo "") exitWith {[ localize "STR_GNOTF_badUID",true,"fast"] call life_fnc_notification_system;}; //Unlikely?
    group player setVariable ["gang_owner",_unitID,true];
    group player selectLeader _unit;
    ["TON_fnc_clientGangLeader",[_unit,group player],_unit] call life_fnc_relaySend; //Boot that bitch!
    if (LIFE_HC_ACTIVE) then {
        [3,group player] remoteExec ["HC_fnc_updateGang",HC_Life]; //Update the database.
    } else {
        [3,group player] remoteExec ["TON_fnc_updateGang",RSERV]; //Update the database.
    };
} else {
    [ localize "STR_GNOTF_TransferCancel",true,"fast"] call life_fnc_notification_system;
};
[] call life_fnc_gangMenu;
