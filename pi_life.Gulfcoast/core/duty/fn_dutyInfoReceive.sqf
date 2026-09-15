#include "..\..\script_macros.hpp"
/*
    File: fn_dutyInfoReceive.sqf
    Description:
    Antwort des Servers auf TON_fnc_dutyInfo mit den Freigaben des Spielers.
    Parameter:
        0: NUMBER - Cop-Rang
        1: NUMBER - Medic-Rang
        2: NUMBER - Adminlevel
        3: BOOL   - Polizei-Sperre (blacklist)
        4: BOOL   - aktuell gesucht
*/
if !(remoteExecutedOwner isEqualTo 2) exitWith {};
params [["_cop",0,[0]],["_med",0,[0]],["_admin",0,[0]],["_blacklist",false,[false]],["_wanted",false,[false]]];
life_duty_info = [_cop,_med,_admin,_blacklist,_wanted];
[] call life_fnc_dutyUpdate;
