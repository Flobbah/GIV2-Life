#include "..\..\script_macros.hpp"
/*
    File: fn_bailPaid.sqf
    Description:
    The server booked the bail (TON_fnc_econJustice). Releases the player through the jail loop in
    life_fnc_jailMe, like the old client-side payment did.
*/
SERVER_ONLY_REMOTE;
life_bail_paid = true;
