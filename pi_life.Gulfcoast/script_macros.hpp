/* System Wide Stuff */
#define SYSTEM_TAG "life"
#define ITEM_TAG format ["%1%2",SYSTEM_TAG,"item_"]
#define CASH life_cash
#define BANK life_atmbank
#define GANG_FUNDS group player getVariable ["gang_bank",0];
//RemoteExec Macros
#define RSERV 2 //Only server
#define RCLIENT -2 //Except server
#define RANY 0 //Global
//Scripting Macros
#define CONST(var1,var2) var1 = compileFinal (if (var2 isEqualType "") then {var2} else {str(var2)})
#define CONSTVAR(var) var = compileFinal (if (var isEqualType "") then {var} else {str(var)})
#define FETCH_CONST(var) (call var)
//Sicherheitsphase 0.1: Funktion darf remote nur vom Server ausgeloest werden; lokale Aufrufe bleiben erlaubt
#define SERVER_ONLY_REMOTE if (isRemoteExecuted && {!(remoteExecutedOwner isEqualTo 2)}) exitWith {}
//Sicherheitsphase 0.2: Headless-Client-Modus nur, wenn description.ext ihn erlaubt; life_HC_isActive allein kann jeder Client per publicVariable setzen
#define LIFE_HC_ACTIVE ((getNumber (missionConfigFile >> "CfgServer" >> "HeadlessSupport")) isEqualTo 1 && {life_HC_isActive isEqualTo true})
//Geld-Umbau (docs/ECONOMY_AUTHORITY.md): ab 1 bucht der Server die umgestellten Geldfluesse, der Client fragt nur an
#define ECONOMY_MODE (getNumber (missionConfigFile >> "CfgServer" >> "EconomyMode"))
//Sicherheitsphase 0.1b: Aktion zwischen Spielern. Solange CfgRelay >> enabled = 1 ist (config\Config_Relay.hpp), nimmt
//die Funktion Remote-Aufrufe nur vom Server (TON_fnc_relay) oder vom eigenen Client an; lokale Aufrufe bleiben erlaubt
#define RELAY_ONLY_REMOTE if (isRemoteExecuted && {!(remoteExecutedOwner in [2, clientOwner])} && {(getNumber (missionConfigFile >> "CfgRelay" >> "enabled")) isEqualTo 1}) exitWith {diag_log format ["[SECURITY] %1: direct remote call from owner %2 ignored, CfgRelay is active", (if (isNil "_fnc_scriptName") then {"?"} else {_fnc_scriptName}), remoteExecutedOwner]}
//Dienst-System: Rang und Gehalt aendern sich beim Wechsel, deshalb compile statt compileFinal (compileFinal laesst sich nicht ueberschreiben)
#define CONST_MUTABLE(var1,var2) var1 = compile (if (var2 isEqualType "") then {var2} else {str(var2)})
#define CONSTVAR_MUTABLE(var) var = compile (if (var isEqualType "") then {var} else {str(var)})
//Dienst-System: Fraktion eines Spielers (life_side wird oeffentlich am Spieler gesetzt, sonst Engine-Seite)
#define SIDE_OF(UNIT) ((UNIT) getVariable ["life_side", side (UNIT)])
//Display Macros
#define CONTROL(disp,ctrl) ((findDisplay ##disp) displayCtrl ##ctrl)
#define CONTROL_DATA(ctrl) (lbData[ctrl,lbCurSel ctrl])
#define CONTROL_DATAI(ctrl,index) ctrl lbData index
//System Macros
#define LICENSE_VARNAME(varName,flag) format ["license_%1_%2",flag,M_CONFIG(getText,"Licenses",varName,"variable")]
#define LICENSE_VALUE(varName,flag) missionNamespace getVariable [LICENSE_VARNAME(varName,flag),false]
#define ITEM_VARNAME(varName) format ["life_inv_%1",M_CONFIG(getText,"VirtualItems",varName,"variable")]
#define ITEM_VALUE(varName) missionNamespace getVariable [ITEM_VARNAME(varName),0]
#define ITEM_ILLEGAL(varName) M_CONFIG(getNumber,"VirtualItems",varName,"illegal")
#define ITEM_SELLPRICE(varName) M_CONFIG(getNumber,"VirtualItems",varName,"sellPrice")
#define ITEM_BUYPRICE(varName) M_CONFIG(getNumber,"VirtualItems",varName,"buyPrice")
#define ITEM_NAME(varName) M_CONFIG(getText,"VirtualItems",varName,"displayName")
//Condition Macros
#define KINDOF_ARRAY(a,b) [##a,##b] call {_veh = _this select 0;_types = _this select 1;_res = false; {if (_veh isKindOf _x) exitWith { _res = true };} forEach _types;_res}
//Config Macros
#define FETCH_CONFIG(TYPE,CFG,SECTION,CLASS,ENTRY) TYPE(configFile >> CFG >> SECTION >> CLASS >> ENTRY)
#define FETCH_CONFIG2(TYPE,CFG,CLASS,ENTRY) TYPE(configFile >> CFG >> CLASS >> ENTRY)
#define FETCH_CONFIG3(TYPE,CFG,SECTION,CLASS,ENTRY,SUB) TYPE(configFile >> CFG >> SECTION >> CLASS >> ENTRY >> SUB)
#define FETCH_CONFIG4(TYPE,CFG,SECTION,CLASS,ENTRY,SUB,SUB2) TYPE(configFile >> CFG >> SECTION >> CLASS >> ENTRY >> SUB >> SUB2)
#define M_CONFIG(TYPE,CFG,CLASS,ENTRY) TYPE(missionConfigFile >> CFG >> CLASS >> ENTRY)
#define BASE_CONFIG(CFG,CLASS) inheritsFrom(configFile >> CFG >> CLASS)
#define LIFE_SETTINGS(TYPE,SETTING) TYPE(missionConfigFile >> "Life_Settings" >> SETTING)
//Community-Name aus config\Config_Community.hpp (nur dort aendern)
#define COMMUNITY_NAME_TEXT (getText (missionConfigFile >> "CfgCommunity" >> "name"))
#define COMMUNITY_MISSION_NAME_TEXT (getText (missionConfigFile >> "CfgCommunity" >> "missionName"))
//UI Macros
#define LIFEdisplay (uiNamespace getVariable ["playerHUD",displayNull])
#define LIFEctrl(ctrl) ((uiNamespace getVariable ["playerHUD",displayNull]) displayCtrl ctrl)
