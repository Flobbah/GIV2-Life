#include "\life_server\script_macros.hpp"
/*
    File: fn_econResync.sqf
    Description:
    Enforce mode (EconomyMode 2, docs/ECONOMY_AUTHORITY.md step 4): every
    CfgEconomy >> resyncInterval seconds the server pushes its balances to every player and its gang
    banks to every gang. A client that wrote its own life_cash/life_atmbank sees the server's value
    again within one interval, and a display that ran out of step after a flow the server does not
    book yet corrects itself. Spawned by TON_fnc_econInit.
*/
private _interval = getNumber (missionConfigFile >> "CfgEconomy" >> "resyncInterval");
if (_interval < 5) exitWith {
    diag_log "[ECONOMY] resync loop off (CfgEconomy >> resyncInterval)";
};
diag_log format ["[ECONOMY] resync loop every %1 s", round _interval];
while {true} do {
    uiSleep _interval;
    private _wallets = localNamespace getVariable ["life_econ_wallets", createHashMap];
    {
        private _wallet = _wallets getOrDefault [getPlayerUID _x, []];
        if (count _wallet isEqualTo 2 && {(owner _x) > 2}) then {
            [_wallet select 0, _wallet select 1, 0, 0] remoteExecCall ["life_fnc_moneyUpdate", owner _x];
        };
    } forEach allPlayers;
    private _gangs = localNamespace getVariable ["life_econ_gangs", createHashMap];
    {
        private _id = _x getVariable ["gang_id", -1];
        if (_id isEqualType 0) then {
            private _bank = _gangs getOrDefault [_id, -1];
            if (_bank >= 0 && {!((_x getVariable ["gang_bank", -1]) isEqualTo _bank)}) then {
                _x setVariable ["gang_bank", _bank, true];
            };
        };
    } forEach allGroups;
};
