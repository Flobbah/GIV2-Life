#include "..\..\script_macros.hpp"
/*
    File: fn_ticketPay.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Pays the ticket.
*/
if (isNil "life_ticket_val" || isNil "life_ticket_cop") exitWith {};
if (ECONOMY_MODE >= 1 && {CASH >= life_ticket_val || {BANK >= life_ticket_val}}) exitWith {
    //Geld-Umbau Schritt 2: der Server bucht den gespeicherten Strafzettel an den ausstellenden Polizisten
    life_ticket_paid = true;
    closeDialog 0;
    ["ticketPay"] remoteExecCall ["TON_fnc_econJustice",RSERV];
};
if (CASH < life_ticket_val) exitWith {
    if (BANK < life_ticket_val) exitWith {
        [ localize "STR_Cop_Ticket_NotEnough",true,"fast"] call life_fnc_notification_system;
        ["life_fnc_broadcast",[1,"STR_Cop_Ticket_NotEnoughNOTF",true,[profileName]],life_ticket_cop] call life_fnc_relaySend;
        closeDialog 0;
    };
    [ format [localize "STR_Cop_Ticket_Paid",[life_ticket_val] call life_fnc_numberText],false,"fast"] call life_fnc_notification_system;
    BANK = BANK - life_ticket_val;
    [1] call SOCK_fnc_updatePartial;
    life_ticket_paid = true;
    ["life_fnc_broadcast",[0,"STR_Cop_Ticket_PaidNOTF",true,[profileName,[life_ticket_val] call life_fnc_numberText]],west] call life_fnc_relaySend;
    ["life_fnc_broadcast",[1,"STR_Cop_Ticket_PaidNOTF_2",true,[profileName]],life_ticket_cop] call life_fnc_relaySend;
    ["life_fnc_ticketPaid",[life_ticket_val,player,life_ticket_cop],life_ticket_cop] call life_fnc_relaySend;
    if (LIFE_HC_ACTIVE) then {
        [getPlayerUID player] remoteExecCall ["HC_fnc_wantedRemove",HC_Life];
    } else {
        [getPlayerUID player] remoteExecCall ["life_fnc_wantedRemove",RSERV];
    };
    closeDialog 0;
};
CASH = CASH - life_ticket_val;
[0] call SOCK_fnc_updatePartial;
life_ticket_paid = true;
if (LIFE_HC_ACTIVE) then {
    [getPlayerUID player] remoteExecCall ["HC_fnc_wantedRemove",HC_Life];
} else {
    [getPlayerUID player] remoteExecCall ["life_fnc_wantedRemove",RSERV];
};
["life_fnc_broadcast",[0,"STR_Cop_Ticket_PaidNOTF",true,[profileName,[life_ticket_val] call life_fnc_numberText]],west] call life_fnc_relaySend;
closeDialog 0;
["life_fnc_broadcast",[1,"STR_Cop_Ticket_PaidNOTF_2",true,[profileName]],life_ticket_cop] call life_fnc_relaySend;
["life_fnc_ticketPaid",[life_ticket_val,player,life_ticket_cop],life_ticket_cop] call life_fnc_relaySend;