#include "\life_server\script_macros.hpp"
/*
    File: fn_econPaycheck.sqf
    Description:
    Pays every player's paycheck from the server (docs/ECONOMY_AUTHORITY.md, step 2), replacing the
    client loop in core\fsm\client.fsm. Each player gets paid once per Life_Settings >> paycheck_period
    after their wallet was loaded; reconnecting does not restart the timer. Amount by faction
    (AUTH_SIDE) and police rank (CfgEconomy >> paycheckCopByRank), police near the federal reserve get
    CfgEconomy >> paycheckFedReserveBonus on top. Dead players miss the paycheck, as before.
    Spawned by TON_fnc_econInit.
*/
private _times = createHashMap;
localNamespace setVariable ["life_econ_paytimes", _times];
for "_i" from 0 to 1 step 0 do {
    uiSleep 10;
    private _period = (LIFE_SETTINGS(getNumber,"paycheck_period") max 1) * 60;
    private _wallets = localNamespace getVariable ["life_econ_wallets", createHashMap];
    {
        private _uid = getPlayerUID _x;
        if (_uid regexMatch "\d{17}" && {_uid in _wallets}) then {
            private _last = _times getOrDefault [_uid, -1];
            if (_last < 0) then {
                _times set [_uid, diag_tickTime];
            } else {
                if ((diag_tickTime - _last) >= _period) then {
                    _times set [_uid, diag_tickTime];
                    if (!alive _x) then {
                        ["STR_FSM_MissedPay", [], true] remoteExecCall ["life_fnc_econResult", owner _x];
                    } else {
                        private _side = AUTH_SIDE(_uid);
                        private _pay = switch (_side) do {
                            case west: {
                                private _byRank = getArray (missionConfigFile >> "CfgEconomy" >> "paycheckCopByRank");
                                private _rank = [_uid, "coplevel", 0] call TON_fnc_serverGet;
                                if (_rank >= 1 && {_rank <= count _byRank}) then {_byRank select (_rank - 1)} else {LIFE_SETTINGS(getNumber,"paycheck_cop")};
                            };
                            case independent: {LIFE_SETTINGS(getNumber,"paycheck_med")};
                            case civilian: {LIFE_SETTINGS(getNumber,"paycheck_civ")};
                            default {0};
                        };
                        if (_side isEqualTo west && {(_x distance (getMarkerPos "fed_reserve")) < 120}) then {
                            _pay = _pay + getNumber (missionConfigFile >> "CfgEconomy" >> "paycheckFedReserveBonus");
                        };
                        if (_pay > 0 && {[_uid, "bank", _pay, "paycheck", "", str _side] call TON_fnc_moneyChange}) then {
                            [_pay] remoteExecCall ["life_fnc_paycheckReceive", owner _x];
                        };
                    };
                };
            };
        };
    } forEach allPlayers;
};
