#include "\life_server\script_macros.hpp"
/*
    File: fn_custodyWatch.sqf
    Description:
    Aufsicht ueber den Gewahrsam (Sicherheitsprüfung, Fund #7). Drei Regeln, die frueher der
    Client des Festgenommenen selbst angewendet hat - und damit jeder Cheater nach Belieben:

      1. Wer tot ist, ist nicht mehr gefesselt.
      2. Ist laenger als CfgServer >> RestrainTimeout Sekunden kein Polizist in der Naehe und
         sitzt der Festgenommene in keinem Fahrzeug, kommt er frei ("vergessene Festnahme").
      3. Stirbt der begleitende Polizist oder ist er zu weit weg, endet das Begleiten.

    Gestartet aus life_server\init.sqf.
*/
private _timeout = getNumber (missionConfigFile >> "CfgServer" >> "RestrainTimeout");
if (_timeout <= 0) then {_timeout = 300};
diag_log format ["[CUSTODY] watch active, forgotten arrests end after %1 s", _timeout];

while {true} do {
    uiSleep 10;
    private _custody = localNamespace getVariable "life_custody";
    if (isNil "_custody") then {
        _custody = createHashMap;
        localNamespace setVariable ["life_custody", _custody];
    };
    //Polizisten laut Serverspeicher, nicht laut Variable am Spieler
    private _cops = allPlayers select {alive _x && {(AUTH_SIDE(getPlayerUID _x)) isEqualTo west}};
    {
        private _unit = _x;
        if (_unit getVariable ["restrained", false]) then {
            private _uid = getPlayerUID _unit;
            private _entry = _custody getOrDefault [_uid, [time, objNull, time]];
            _entry params ["_since", "_cop", "_seen"];
            switch (true) do {
                case (!alive _unit): {
                    [_unit, "release"] call TON_fnc_custodySet;
                };
                //Im Fahrzeug laeuft keine Uhr - der Transport dauert, so lange er dauert
                case (!(isNull objectParent _unit)): {
                    _entry set [2, time];
                    _custody set [_uid, _entry];
                };
                case ((_cops findIf {(_x distance _unit) < 30}) > -1): {
                    _entry set [2, time];
                    _custody set [_uid, _entry];
                };
                case ((time - _seen) > _timeout): {
                    [_unit, "release"] call TON_fnc_custodySet;
                    [0, "STR_Cop_ExcessiveRestrain", true, []] remoteExecCall ["life_fnc_broadcast", owner _unit];
                    diag_log format ["[CUSTODY] %1 (%2) was released, no police nearby for %3 s",
                        name _unit, _uid, round (time - _seen)];
                };
            };
            //Begleiten endet, wenn der Polizist tot oder weg ist
            if ((_unit getVariable ["Escorting", false]) && {!isNull _cop} && {!alive _cop || {(_cop distance _unit) > 12}}) then {
                [_unit, "stopEscort"] call TON_fnc_custodySet;
            };
        };
    } forEach allPlayers;
};
