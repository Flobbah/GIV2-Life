#include "..\..\script_macros.hpp"
/*
    File: fn_repairTruck.sqf
    Author: Bryan "Tonic" Boardwine
    Edited: Reparatur-Animation ohne Ruckeln

    Description:
    Repariert ein Fahrzeug mit einem Toolkit.

    Animation:
    "Acts_carFixingWheel" ist eine 20-Sekunden-Animation (Rad reparieren, kniend).
    Die alte "AinvPknlMstpSnonWnonDnon_medic_1" ist laut Spiel-Config nicht geloopt,
    endet nach ca. 6 s und verbindet dann automatisch in die Aufsteh-Transition.
    Das alte Skript hat sie deshalb alle paar Sekunden per switchMove hart neu
    gestartet - das war das sichtbare Ruckeln (auch fuer Mitspieler, weil jedes
    Mal ein remoteExec rausging).

    Jetzt:
    - Reparaturdauer = Animationslaenge (20 s), die Animation laeuft genau einmal durch
    - Start nur per playMoveNow (weiche Einblendung, kein switchMove-Sprung)
    - Sync an Mitspieler nur einmal beim Start
    - Neustart nur, falls die Animation vorzeitig verlassen wurde (z.B. wenn jemand
      _repairTime hochsetzt oder etwas dazwischenfunkt)
    - Ausstieg per playActionNow "stop": die Actions-Klasse der Animation
      (Acts_CarFixingWheel_actions) definiert Stop = AmovPknlMstpSnonWnonDnon (kniend)
*/
private ["_veh","_upp","_ui","_progress","_pgText","_cP","_displayName","_sideRepairArray","_anim","_repairTime","_steps"];

_veh = param [0,objNull,[objNull]];
if (isNull _veh) then {_veh = cursorObject;}; // Fallback, falls ohne Ziel aufgerufen
life_interrupted = false;
if (isNull _veh) exitWith {};
if !((_veh isKindOf "Car") || (_veh isKindOf "Ship") || (_veh isKindOf "Air")) exitWith {};
if (life_inv_toolkit < 1) exitWith {};

_anim = "Acts_carFixingWheel"; //kniend am Fahrzeug arbeiten, 20 s, auch mit Waffe in der Hand stabil
_repairTime = 20 * (1 - ((["repair"] call life_fnc_skillBonus) / 100)); //Skill Reparatur   // Sekunden. 20 = exakt eine Animationslaenge. Hoehere Werte gehen, dann startet die Animation nach 20 s weich neu.
_steps = 100;       // Schritte des Fortschrittsbalkens

life_action_inUse = true;
//Skill Reparatur: XP nur, wenn das Fahrzeug wirklich beschaedigt war (sonst XP-Schleifen am heilen Fahrzeug)
private _wasDamaged = (damage _veh) > 0.05 || {((getAllHitPointsDamage _veh) param [2, []]) findIf {_x > 0.1} > -1};
_displayName = FETCH_CONFIG2(getText,"CfgVehicles",(typeOf _veh),"displayName");
_upp = format [localize "STR_NOTF_Repairing",_displayName];

//Setup our progress bar.
disableSerialization;
"progressBar" cutRsc ["life_progress","PLAIN"];
_ui = uiNamespace getVariable "life_progress";
_progress = _ui displayCtrl 38201;
_pgText = _ui displayCtrl 38202;
_pgText ctrlSetText format ["%2 (1%1)...","%",_upp];
_progress progressSetPosition 0.01;
_cP = 0.01;

//Animation einmal starten (life_fnc_actionAnim: Waffe wegstecken, playMoveNow, Sync)
["start",_anim] call life_fnc_actionAnim;

for "_i" from 0 to 1 step 0 do {
    uiSleep (_repairTime / _steps);
    _cP = _cP + (1 / _steps);
    _progress progressSetPosition _cP;
    _pgText ctrlSetText format ["%3 (%1%2)...",round(_cP * 100),"%",_upp];
    if (_cP >= 1) exitWith {};
    if (!alive player) exitWith {};
    if !(isNull objectParent player) exitWith {};
    if (life_interrupted) exitWith {};
    ["keep",_anim] call life_fnc_actionAnim; //startet nur neu, falls die Animation vorzeitig verlassen wurde
};

life_action_inUse = false;
"progressBar" cutText ["","PLAIN"];
["stop"] call life_fnc_actionAnim;
if (life_interrupted) exitWith {life_interrupted = false; titleText[localize "STR_NOTF_ActionCancel","PLAIN"]; life_action_inUse = false;};
if !(isNull objectParent player) exitWith {titleText[localize "STR_NOTF_ActionInVehicle","PLAIN"];};
if (!alive player) exitWith {};

_sideRepairArray = LIFE_SETTINGS(getArray,"vehicle_infiniteRepair");
//Check if life_side has infinite repair enabled
if (life_side isEqualTo civilian && (_sideRepairArray select 0) isEqualTo 0) then {
    [false,"toolkit",1] call life_fnc_handleInv;
};
if (life_side isEqualTo west && (_sideRepairArray select 1) isEqualTo 0) then {
    [false,"toolkit",1] call life_fnc_handleInv;
};
if (life_side isEqualTo independent && (_sideRepairArray select 2) isEqualTo 0) then {
    [false,"toolkit",1] call life_fnc_handleInv;
};
if (life_side isEqualTo east && (_sideRepairArray select 3) isEqualTo 0) then {
    [false,"toolkit",1] call life_fnc_handleInv;
};
_veh setDamage 0;
if (_wasDamaged) then {["repair"] call life_fnc_skillAddXP;};
titleText[localize "STR_NOTF_RepairedVehicle","PLAIN"];
