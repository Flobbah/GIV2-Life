#include "script_macros.hpp"
/*
    File: init.sqf
    Author: Bryan "Tonic" Boardwine
    Edit: Nanou for HeadlessClient optimization.
    Please read support for more informations.
    Description:
    Initialize the server and required systems.
*/
private ["_dome","_rsb","_timeStamp","_extDBNotLoaded"];
DB_Async_Active = false;
DB_Async_ExtraLock = false;
life_server_isReady = false;
_extDBNotLoaded = "";
localNamespace setVariable ["serv_sv_use", []]; //Sicherheitsphase 0.2 Welle 2: nicht mehr per publicVariable erreichbar
publicVariable "life_server_isReady";
life_save_civilian_position = if (LIFE_SETTINGS(getNumber,"save_civilian_position") isEqualTo 0) then {false} else {true};
fn_whoDoneIt = compile preprocessFileLineNumbers "\life_server\Functions\Systems\fn_whoDoneIt.sqf";
/*
    Prepare the headless client.
*/
life_HC_isActive = false;
publicVariable "life_HC_isActive";
HC_Life = false;
publicVariable "HC_Life";
if (EXTDB_SETTING(getNumber,"HeadlessSupport") isEqualTo 1) then {
    [] execVM "\life_server\initHC.sqf";
};
/*
    Prepare extDB before starting the initialization process
    for the server.
*/
if (isNil {uiNamespace getVariable "life_sql_id"}) then {
    life_sql_id = round(random(9999));
    CONSTVAR(life_sql_id);
    uiNamespace setVariable ["life_sql_id",life_sql_id];
        try {
        _result = EXTDB format ["9:ADD_DATABASE:%1",EXTDB_SETTING(getText,"DatabaseName")];
        if (!(_result isEqualTo "[1]")) then {throw "extDB3: Error with Database Connection"};
        _result = EXTDB format ["9:ADD_DATABASE_PROTOCOL:%2:SQL:%1:TEXT2",FETCH_CONST(life_sql_id),EXTDB_SETTING(getText,"DatabaseName")];
        if (!(_result isEqualTo "[1]")) then {throw "extDB3: Error with Database Connection"};
    } catch {
        diag_log _exception;
        _extDBNotLoaded = [true, _exception];
    };
    if (_extDBNotLoaded isEqualType []) exitWith {};
    EXTDB "9:LOCK";
    diag_log "extDB3: Connected to Database";
} else {
    life_sql_id = uiNamespace getVariable "life_sql_id";
    CONSTVAR(life_sql_id);
    diag_log "extDB3: Still Connected to Database";
};
if (_extDBNotLoaded isEqualType []) exitWith {
    life_server_extDB_notLoaded = true;
    publicVariable "life_server_extDB_notLoaded";
};
life_server_extDB_notLoaded = false;
publicVariable "life_server_extDB_notLoaded";
/* Run stored procedures for SQL side cleanup */
["CALL resetLifeVehicles",1] call DB_fnc_asyncCall;
["CALL deleteDeadVehicles",1] call DB_fnc_asyncCall;
["CALL deleteOldHouses",1] call DB_fnc_asyncCall;
["CALL deleteOldGangs",1] call DB_fnc_asyncCall;
[] spawn TON_fnc_econInit; //Geld-Umbau Schritt 1: Kontostaende und Transaktionslog
_timeStamp = diag_tickTime;
diag_log "----------------------------------------------------------------------------------------------------";
diag_log "---------------------------------- Starting Altis Life Server Init ---------------------------------";
diag_log format["------------------------------------------ Version %1 -------------------------------------------",(LIFE_SETTINGS(getText,"framework_version"))];
diag_log "----------------------------------------------------------------------------------------------------";
if (LIFE_SETTINGS(getNumber,"save_civilian_position_restart") isEqualTo 1) then {
    [] spawn {
        _query = "UPDATE players SET civ_alive = '0' WHERE civ_alive = '1'";
        [_query,1] call DB_fnc_asyncCall;
    };
};
/* Map-based server side initialization. */
master_group attachTo[bank_obj,[0,0,0]];
{
    if (!isPlayer _x) then {
        _npc = _x;
        {
            if (_x != "") then {
                _npc removeWeapon _x;
            };
        } forEach [primaryWeapon _npc,secondaryWeapon _npc,handgunWeapon _npc];
    };
} forEach allUnits;
[8,true,12] execFSM "\life_server\FSM\timeModule.fsm";
life_adminLevel = 0;
life_medicLevel = 0;
life_copLevel = 0;
CONST(JxMxE_PublishVehicle,"false");
/* Setup radio channels for west/independent/civilian */
//Sicherheitsphase 0.2 Welle 2: die Kanal-Nummern gehoeren dem Server, sonst kann ein Client den Seitenfunk kapern
localNamespace setVariable ["life_radio_west", radioChannelCreate [[0, 0.95, 1, 0.8], "Side Channel", "%UNIT_NAME", []]];
localNamespace setVariable ["life_radio_civ", radioChannelCreate [[0, 0.95, 1, 0.8], "Side Channel", "%UNIT_NAME", []]];
localNamespace setVariable ["life_radio_indep", radioChannelCreate [[0, 0.95, 1, 0.8], "Side Channel", "%UNIT_NAME", []]];
/* Set the amount of gold in the federal reserve at mission start */
//Sicherheitsphase 0.2 Welle 2: Bestand und Zustand fuehrt der Server (TON_fnc_fedSafe), am Objekt steht nur die Anzeige
["server", "fedSafe", count playableUnits] call TON_fnc_serverSet;
["server", "fedOpen", false] call TON_fnc_serverSet;
fed_bank setVariable ["safe",count playableUnits,true];
fed_bank setVariable ["safe_open",false,true];
[] spawn TON_fnc_federalUpdate;
/* Event handler for disconnecting players */
addMissionEventHandler ["HandleDisconnect",{_this call TON_fnc_clientDisconnect; false;}];
[] call compile preprocessFileLineNumbers "\life_server\functions.sqf";
/* Set OwnerID players for Headless Client */
TON_fnc_requestClientID =
{
    (_this select 1) setVariable ["life_clientID", owner (_this select 1), true];
};
"life_fnc_RequestClientId" addPublicVariableEventHandler TON_fnc_requestClientID;
/* Event handler for logs */
//Sicherheitsphase 0.2: money_log/advanced_log kommen ueber TON_fnc_clientLog mit geprueftem Absender, nicht mehr per publicVariableServer
/* Miscellaneous mission-required stuff */
life_wanted_list = [];
cleanupFSM = [] execFSM "\life_server\FSM\cleanup.fsm";
[] spawn {
    for "_i" from 0 to 1 step 0 do {
        uiSleep (30 * 60);
        {
            _x setVariable ["sellers",[],true];
        } forEach [Dealer_1,Dealer_2,Dealer_3];
    };
};
[] spawn TON_fnc_initHouses;
cleanup = [] spawn TON_fnc_cleanup;
//Sicherheitsphase 0.2 Welle 2: Spielzeiten bleiben auf dem Server (frueher publicVariable, jeder Client konnte sie ueberschreiben)
localNamespace setVariable ["TON_fnc_playtime_values", []];
localNamespace setVariable ["TON_fnc_playtime_values_request", []];
/* Setup the federal reserve building(s) */
private _vaultHouse = [[["Gulfcoast", "Land_Research_house_V1_F"], ["Tanoa", "Land_Medevac_house_V1_F"]]] call TON_fnc_terrainSort;
private _altisArray = [14778.333,12362.36,0];
private _tanoaArray = [11074.2,11501.5,0.00137329];
private _pos = [[["Gulfcoast", _altisArray], ["Tanoa", _tanoaArray]]] call TON_fnc_terrainSort;
_dome = nearestObject [_pos,"Land_Dome_Big_F"];
_rsb = nearestObject [_pos,_vaultHouse];
for "_i" from 1 to 3 do {_dome setVariable [format ["bis_disabled_Door_%1",_i],1,true]; _dome animateSource [format ["Door_%1_source", _i], 0];};
_dome setVariable ["locked",true,true];
_rsb setVariable ["locked",true,true];
_rsb setVariable ["bis_disabled_Door_1",1,true];
_dome allowDamage false;
_rsb allowDamage false;
/* Tell clients that the server is ready and is accepting queries */
life_server_isReady = true;
publicVariable "life_server_isReady";
/* Sicherheitsphase 0.2: Statusvariablen, die jeder Client per publicVariable ueberschreiben koennte (Join-Sperre,
   Datenbank-Aufrufe aller Spieler an einen falschen Headless Client). Der Server stellt sie sofort wieder her. */
private _protected = [["life_server_isReady", true], ["life_server_extDB_notLoaded", false]];
if !(EXTDB_SETTING(getNumber,"HeadlessSupport") isEqualTo 1) then {
    _protected append [["life_HC_isActive", false], ["HC_Life", false]];
};
{
    _x params ["_name", "_value"];
    localNamespace setVariable ["life_protected_" + _name, _value];
    _name addPublicVariableEventHandler {
        params ["_name", "_value"];
        private _real = localNamespace getVariable ("life_protected_" + _name);
        if (_value isEqualTo _real) exitWith {};
        diag_log format ["[SECURITY] publicVariable %1 = %2 was sent by a client, restored to %3", _name, _value, _real];
        missionNamespace setVariable [_name, _real];
        publicVariable _name;
    };
} forEach _protected;
/* Initialize hunting zone(s) */
aiSpawn = ["hunting_zone",30] spawn TON_fnc_huntingZone;
server_corpses = [];
addMissionEventHandler ["EntityRespawned", {_this call TON_fnc_entityRespawned}];
/* Sicherheitsphase 0.1b: letzten Tod je Client fuer TON_fnc_relay merken (Lizenzentzug durch das Opfer, Reichweite am Koerper) */
localNamespace setVariable ["life_relay_deaths", createHashMap];
addMissionEventHandler ["EntityKilled", {
    params ["_unit", "_killer", "_instigator"];
    if !(_unit isKindOf "CAManBase") exitWith {};
    private _owner = owner _unit;
    if (_owner < 3) exitWith {};
    (localNamespace getVariable "life_relay_deaths") set [_owner, [diag_tickTime, _unit, _killer, _instigator]];
}];
if (ECONOMY_MODE >= 1) then {
    //Geld-Umbau Schritt 2: Raub-Sperren setzt nur noch der Server (TON_fnc_econRobbery), Client-Broadcasts werden zurueckgesetzt
    ["life_nextrob", 0] call TON_fnc_publishProtected;
    ["life_firstrob", true] call TON_fnc_publishProtected;
    ["DevB_BankRobbing", false] call TON_fnc_publishProtected;
    [] spawn {
        uiSleep (10 * 60);
        ["life_firstrob", false] call TON_fnc_publishProtected;
    };
} else {
life_nextrob = 0; // 10 min nach Restart, funzt das Überfallen erst.
publicVariable "life_nextrob";
life_firstrob = true;
publicVariable "life_firstrob";
[] spawn {
    uiSleep (10 * 60);
    life_firstrob = false;
    publicVariable "life_firstrob";
};
};
diag_log "----------------------------------------------------------------------------------------------------";
diag_log format ["               End of Altis Life Server Init :: Total Execution Time %1 seconds ",(diag_tickTime) - _timeStamp];
diag_log "----------------------------------------------------------------------------------------------------";
