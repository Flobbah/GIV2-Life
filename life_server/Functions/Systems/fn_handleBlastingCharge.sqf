#include "\life_server\script_macros.hpp"
/*
    Author: GetSomePanda / Panda
    SteamID: 76561198145366418
    File Name: fn_handleBlastingCharge.sqf
    Information: Nothing really special, just handles the fed explosion over the server so if the client who place the charge logs out it still blows up.
*/
private ["_bomb","_time"];
//Sicherheitsphase 0.1: nur wenn eine Ladung liegt und der Absender am Tresor steht
private _caller = CALLER_OWNER;
private _deny = "";
if !(_caller isEqualTo 2) then {
    private _info = [_caller] call TON_fnc_callerInfo;
    switch (true) do {
        case (_info isEqualTo []): {_deny = "unknown sender";};
        case (isNil "fed_bank"): {_deny = "no federal reserve vault on this map";};
        case (((_info select 1) distance fed_bank) > 30): {_deny = "sender too far from the vault";};
        case (!(fed_bank getVariable ["chargeplaced", false])): {_deny = "no charge placed";};
    };
};
if (!(_deny isEqualTo "") && {[_caller, "TON_fnc_handleBlastingCharge", _deny] call TON_fnc_denyCaller}) exitWith {};
_time = time + (5 * 60);
waitUntil{(round(_time - time) < 1)};
sleep 0.9;
if (!(fed_bank getVariable["chargeplaced",false])) exitWith {};
_bomb = "Bo_GBU12_LGB_MI10" createVehicle [getPosATL fed_bank select 0, getPosATL fed_bank select 1, (getPosATL fed_bank select 2)+0.5];
fed_bank setVariable ["chargeplaced",false,true];
["server", "fedOpen", true] call TON_fnc_serverSet; //Sicherheitsphase 0.2 Welle 2
fed_bank setVariable ["safe_open",true,true];
