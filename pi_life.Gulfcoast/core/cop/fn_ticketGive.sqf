#include "..\..\script_macros.hpp"
/*
    File: fn_ticketGive.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Gives a ticket to the targeted player.
*/
if (isNil "life_ticket_unit") exitWith {[ localize "STR_Cop_TicketNil",true,"fast"] call life_fnc_notification_system};
if (isNull life_ticket_unit) exitWith {[ localize "STR_Cop_TicketExist",true,"fast"] call life_fnc_notification_system};
private _val = ctrlText 2652;
if (!([_val] call TON_fnc_isnumber)) exitWith {[ localize "STR_Cop_TicketNum",true,"fast"] call life_fnc_notification_system};
if ((parseNumber _val) > (getNumber (missionConfigFile >> "CfgEconomy" >> "ticketMax"))) exitWith {[ localize "STR_Cop_TicketOver100",true,"fast"] call life_fnc_notification_system};
if (ECONOMY_MODE >= 1) exitWith {["ticketIssue", life_ticket_unit, parseNumber _val] remoteExecCall ["TON_fnc_econJustice",RSERV]; closeDialog 0;}; //Geld-Umbau Schritt 2: Strafzettel speichert der Server
["life_fnc_broadcast",[0,"STR_Cop_TicketGive",true,[profileName,[(parseNumber _val)] call life_fnc_numberText,life_ticket_unit getVariable ["realname",name life_ticket_unit]]],RCLIENT] call life_fnc_relaySend;
["life_fnc_ticketPrompt",[player,(parseNumber _val)],life_ticket_unit] call life_fnc_relaySend;
closeDialog 0;
