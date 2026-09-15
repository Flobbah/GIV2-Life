#include "..\..\script_macros.hpp"
/*
    File: fn_dutyReceive.sqf
    Description:
    Antwort des Servers auf TON_fnc_dutySwitch: entweder ein Ablehnungsgrund (STRING mit
    Stringtable-Schluessel) oder die Daten der neuen Fraktion. Stellt den Spieler komplett um:
    life_side, Gruppe (Engine-Seite), Raenge, Lizenzen, Gehalt, Fahrzeugschluessel, Haeuser, Gang,
    Haft, Aktionen, Absperrungen, Seitenkanal, virtuelles Inventar und Ausruestung.
    Muss per remoteExec (spawn) laufen, weil das Laden der Ausruestung wartet.
    Parameter:
        0: SIDE   - neue Fraktion (oder STRING - Ablehnungsgrund)
        1: ARRAY  - Lizenzen [[Variablenname, BOOL], ...]
        2: ARRAY  - Ausruestung im life_gear-Format (leer = Standard-Loadout)
        3: NUMBER - Cop-Rang
        4: NUMBER - Medic-Rang
        5: BOOL   - Polizei-Sperre
        6: BOOL   - als Zivilist verhaftet
        7: ARRAY  - Fahrzeugschluessel der Fraktion
        8: ARRAY  - Haeuser (nur Zivilist)
        9: ARRAY  - Gang-Daten (nur Zivilist)
*/
if !(remoteExecutedOwner isEqualTo 2) exitWith {};
if ((_this select 0) isEqualType "") exitWith {
    life_duty_busy = false;
    [localize (_this select 0),true,"fast"] call life_fnc_notification_system;
    [] call life_fnc_dutyUpdate;
};
params [
    ["_side",sideUnknown,[civilian]],
    ["_licenses",[],[[]]],
    ["_gear",[],[[]]],
    ["_coplevel",0,[0]],
    ["_mediclevel",0,[0]],
    ["_blacklist",false,[false]],
    ["_arrested",false,[false]],
    ["_keys",[],[[]]],
    ["_houses",[],[[]]],
    ["_gang",[],[[]]]
];
if !(_side in [west,civilian,independent]) exitWith {life_duty_busy = false;};
if (_side isEqualTo life_side) exitWith {life_duty_busy = false;};
private _old = life_side;

//1. Fraktion und Gruppe: die Engine-Seite folgt der Gruppe, eine Gang wird dabei verlassen
life_side = _side;
player setVariable ["life_side",_side,true];
private _oldGroup = group player;
[player] joinSilent (createGroup [_side,true]);
if (!isNull _oldGroup && {count (units _oldGroup) isEqualTo 0}) then {deleteGroup _oldGroup;};

//2. Raenge
private _newCop = [0,_coplevel] select (_side isEqualTo west);
private _newMed = [0,_mediclevel] select (_side isEqualTo independent);
CONST_MUTABLE(life_coplevel,_newCop);
CONST_MUTABLE(life_medicLevel,_newMed);
life_blacklisted = _blacklist && {_side isEqualTo west};
if (_side isEqualTo west) then {
    player setVariable ["coplevel",1,true];
    player setVariable ["rank",_coplevel,true];
} else {
    player setVariable ["coplevel",nil,true];
    player setVariable ["rank",nil,true];
};

//3. Lizenzen der neuen Fraktion und Gehalt
{
    if (_x isEqualType [] && {count _x > 1}) then {missionNamespace setVariable [_x select 0,_x select 1];};
} forEach _licenses;
[] call life_fnc_dutyPaycheck;

//4. Fahrzeugschluessel, Haeuser, Gang, Haft
life_vehicles = +_keys;
life_houses = _houses;
life_gangData = _gang;
life_is_arrested = false;
if (_side isEqualTo civilian) then {
    {
        private _house = nearestObject [(call compile format ["%1",(_x select 0)]),"House"];
        life_vehicles pushBack _house;
    } forEach life_houses;
    if !(life_duty_housesInit) then {
        life_duty_housesInit = true;
        [] spawn life_fnc_initHouses;
    };
    if (count _gang > 0) then {[] spawn life_fnc_initGang;};
    life_is_arrested = _arrested;
};

//5. Aktionen, Absperrungen, Seitenkanal
{player removeAction _x;} forEach life_actions;
[] call life_fnc_setupActions;
if (_side in [west,independent]) then {[] call life_fnc_placeablesInit;};
[player,false,_old] remoteExecCall ["TON_fnc_manageSC",RSERV];
[player,life_settings_enableSidechannel,_side] remoteExecCall ["TON_fnc_manageSC",RSERV];

//6. Virtuelles Inventar leeren (die speicherbaren Gegenstaende der alten Fraktion liegen in der
//   Datenbank und kommen beim naechsten Wechsel zurueck), dann Ausruestung der neuen Fraktion laden
{
    missionNamespace setVariable [ITEM_VARNAME(configName _x),0];
} forEach ("true" configClasses (missionConfigFile >> "VirtualItems"));
life_carryWeight = 0;
life_gear = _gear;
[] call life_fnc_loadGear;
[] call life_fnc_saveGear;

//7. Fertig
life_duty_last = time;
life_duty_busy = false;
private _msg = switch (_side) do {case west: {"STR_DUTY_DoneCop"}; case independent: {"STR_DUTY_DoneMed"}; default {"STR_DUTY_DoneCiv"};};
[localize _msg,false,"fast"] call life_fnc_notification_system;
playSound "FD_Finish_F";
[] call life_fnc_hudUpdate;
if (life_is_arrested) then {[player,true] spawn life_fnc_jail;};
