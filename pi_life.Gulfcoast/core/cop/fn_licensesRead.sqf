#include "..\..\script_macros.hpp"
/*
    File: fn_licensesRead.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Outprints the licenses.
*/
RELAY_ONLY_REMOTE; //Sicherheitsphase 0.1b: Aufrufe anderer Spieler nur ueber den Server (CfgRelay)
params [
    ["_civ","",[""]],
    ["_licenses",(localize "STR_Cop_NoLicenses"),[""]]
];
[ parseText format ["<t color='#FF0000'><t size='2'>%1</t></t><br/><t color='#FFD700'><t size='1.5'>" +(localize "STR_Cop_Licenses")+ "</t></t><br/>%2",_civ,_licenses],false,"slow"] call life_fnc_notification_system;