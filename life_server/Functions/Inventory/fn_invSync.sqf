#include "\life_server\script_macros.hpp"
/*
    File: fn_invSync.sqf
    Description:
    Asks every player for a full list of their virtual items every CfgInventory >> syncInterval
    seconds (life_fnc_invReport answers to TON_fnc_invReport). Single changes arrive through
    TON_fnc_invTrack; this loop catches everything that never reported, which is exactly what a
    script executor does. Spawned by TON_fnc_invInit.
*/
private _interval = getNumber (missionConfigFile >> "CfgInventory" >> "syncInterval");
if (_interval < 10) exitWith {
    diag_log "[INVENTORY] full compare off (CfgInventory >> syncInterval)";
};
private _summary = getNumber (missionConfigFile >> "CfgInventory" >> "summaryCycles");
localNamespace setVariable ["life_inv_stats", [0, 0]]; //beantwortete Abgleiche, davon mit Abweichung
private _cycle = 0;
while {true} do {
    uiSleep _interval;
    private _asked = 0;
    {
        if ((owner _x) > 2 && {!((getPlayerUID _x) isEqualTo "")}) then {
            [] remoteExecCall ["life_fnc_invReport", owner _x];
            _asked = _asked + 1;
        };
    } forEach allPlayers;
    _cycle = _cycle + 1;
    //Eine Zeile, die belegt, dass der Vergleich laeuft. Ohne sie ist ein stilles Log nicht zu
    //unterscheiden von einem Vergleich, der gar nicht stattfindet - und darauf soll vor dem
    //Scharfschalten (Modus 2) niemand vertrauen muessen.
    if (_summary >= 1 && {(_cycle % _summary) isEqualTo 0} && {_asked > 0}) then {
        (localNamespace getVariable ["life_inv_stats", [0, 0]]) params ["_answers", "_diffs"];
        diag_log format ["[INVENTORY] compare alive: %1 player(s) asked, %2 answers with %3 differences in the last %4 rounds",
            _asked, _answers, _diffs, _summary];
        localNamespace setVariable ["life_inv_stats", [0, 0]];
    };
};
