#include "..\..\script_macros.hpp"
/*
    File: fn_licenseCheck.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Returns the licenses to the cop.
*/
RELAY_ONLY_REMOTE; //Sicherheitsphase 0.1b: Aufrufe anderer Spieler nur ueber den Server (CfgRelay)
private ["_cop","_licenses","_licensesConfigs"];
_cop = param [0,objNull,[objNull]];
if (isNull _cop) exitWith {}; //Bad entry
_licenses = "";
//Config entries for licenses that are civilian
_licensesConfigs = "getText(_x >> 'side') isEqualTo 'civ'" configClasses (missionConfigFile >> "Licenses");
{
    if (LICENSE_VALUE(configName _x,"civ")) then {
        _licenses = _licenses + localize getText(_x >> "displayName") + "<br/>";
    };
} forEach _licensesConfigs;
if (_licenses isEqualTo "") then {_licenses = (localize "STR_Cop_NoLicensesFound");};
["life_fnc_licensesRead",[profileName,_licenses],_cop] call life_fnc_relaySend;
