#include "..\script_macros.hpp"
/*
    File: configuration.sqf
    Author:
    Description:
    Master Life Configuration File
    This file is to setup variables for the client, there are still other configuration files in the system
*****************************
****** Backend Variables *****
*****************************
*/
life_action_delay = time;
life_trunk_vehicle = objNull;
life_session_completed = false;
//Dienst-System: aktuelle Fraktion, aenderbar im Spiel ueber die Telefon-App "Dienst" (statt Engine-playerSide).
//Ohne Lobby vergibt die Engine irgendeinen freien Slot - deshalb zaehlt der Slot nicht mehr, jeder
//faengt als Zivilist an und geht im Spiel in den Dienst.
life_side = playerSide;
if ((getNumber (missionConfigFile >> "CfgServer" >> "StartAsCivilian")) isEqualTo 1) then {life_side = civilian};
life_duty_busy = false;
life_duty_last = -9999;
life_duty_info = [];
life_placement_active = false; //freies Abstellen von Fahrzeugen (core\placement)
life_duty_housesInit = life_side isEqualTo civilian;
//Alle Lizenzvariablen aller Seiten mit false vorbelegen: Shop-Bedingungen greifen direkt darauf zu, die Datenbank
//liefert beim Login nur die Lizenzen der eigenen Seite (und nur die, die es beim Anlegen des Spielers schon gab)
{
    missionNamespace setVariable [format ["license_%1_%2", getText (_x >> "side"), getText (_x >> "variable")], false];
} forEach ("true" configClasses (missionConfigFile >> "Licenses"));
//In Fahrzeugshop-Bedingungen (Config_Vehicles.hpp) verwendete, aber nirgends definierte Lizenzen: bleiben gesperrt,
//aber ohne Skriptfehler. Entweder in Config_Licenses.hpp anlegen oder die Bedingungen aendern.
{missionNamespace setVariable [_x, false];} forEach ["license_cop_swat","license_cop_fbi","license_civ_amc","license_civ_tuning"];
life_garage_store = false;
life_session_tries = 0;
life_siren_active = false;
life_clothing_filter = 0;
life_redgull_effect = time;
life_is_processing = false;
life_bail_paid = false;
life_impound_inuse = false;
life_action_inUse = false;
life_spikestrip = objNull;
life_knockout = false;
life_interrupted = false;
life_respawned = false;
life_removeWanted = false;
life_action_gathering = false;
life_god = false;
life_frozen = false;
life_save_gear = [];
life_container_activeObj = objNull;
life_disable_getIn = false;
life_disable_getOut = false;
life_admin_debug = false;
life_civ_position = [];
life_markers = false;
life_markers_active = false;
life_canpay_bail = true;
life_storagePlacing = scriptNull;
life_hideoutBuildings = [];
life_firstSpawn = true;
life_open_notifications = [];
//Performance caches (see fn_revealObjects, fn_hudUpdate, fn_keyHandler)
life_revealObjects_next = 0;
life_hud_cache = [-1,-1,-1,-1,-1];
life_settings_disableCommanderView = LIFE_SETTINGS(getNumber,"disableCommanderView") isEqualTo 1;
life_vehicleDoorSources = ["door_back_R","door_back_L","door_R","door_L","Door_L_source","Door_rear","Door_rear_source","Door_1_source","Door_2_source","Door_3_source","Door_LM","Door_RM","Door_LF","Door_RF","Door_LB","Door_RB","DoorL_Front_Open","DoorR_Front_Open","DoorL_Back_Open","DoorR_Back_Open"];
//Farbkorrektur in der Nacht
CHBN_adjustBrightness = 10;
CHBN_adjustColor = [1,1,1];
/*
**************************************
****** Placeables Variables *****
**************************************
*/
life_definePlaceables = //Array aller Absperrungen (Cop + Medic)
[
 "RoadCone_F",
 "RoadCone_L_F",
 "RoadBarrier_F",
 "RoadBarrier_small_F",
 "PlasticBarrier_03_orange_F",
 "Land_CncBarrier_stripes_F",
 "Land_PortableLight_single_F",
 "Land_PortableLight_double_F"
];
life_bar_limit = 100; //Maximale Anzahl Absperrungen pro Person
//Settings
life_settings_enableNewsBroadcast = profileNamespace getVariable ["life_enableNewsBroadcast", true];
life_settings_enableSidechannel = profileNamespace getVariable ["life_enableSidechannel", true];
life_settings_tagson = profileNamespace getVariable ["life_settings_tagson", true];
life_settings_revealObjects = profileNamespace getVariable ["life_settings_revealObjects", true];
life_settings_viewDistanceFoot = profileNamespace getVariable ["life_viewDistanceFoot", 1250];
life_settings_viewDistanceCar = profileNamespace getVariable ["life_viewDistanceCar", 1250];
life_settings_viewDistanceAir = profileNamespace getVariable ["life_viewDistanceAir", 1250];
//Uniform price (0),Hat Price (1),Glasses Price (2),Vest Price (3),Backpack Price (4)
life_clothing_purchase = [-1, -1, -1, -1, -1];
/*
*****************************
****** Weight Variables *****
*****************************
*/
life_maxWeight = LIFE_SETTINGS(getNumber, "total_maxWeight");
life_carryWeight = 0; //Represents the players current inventory weight (MUST START AT 0).
/*
*****************************
****** Life Variables *******
*****************************
*/
life_net_dropped = false;
life_use_atm = true;
life_is_arrested = false;
life_is_alive = false;
life_delivery_in_progress = false;
life_thirst = 100;
life_hunger = 100;
CASH = 0;
life_istazed = false;
life_isknocked = false;
life_vehicles = [];
/*
    Master Array of items?
*/
//Setup variable inv vars.
{
    missionNamespace setVariable [ITEM_VARNAME(configName _x), 0];
} forEach ("true" configClasses (missionConfigFile >> "VirtualItems"));
/* Setup the BLAH! */
{
    _varName = getText(_x >> "variable");
    _sideFlag = getText(_x >> "side");
    missionNamespace setVariable [LICENSE_VARNAME(_varName,_sideFlag), false];
} forEach ("true" configClasses (missionConfigFile >> "Licenses"));
/* Setup life_hideoutBuildings */
{
    _building = nearestBuilding getMarkerPos _x;
    life_hideoutBuildings pushBack _building
} forEach (LIFE_SETTINGS(getArray,"gang_area"));
