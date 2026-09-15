#include "..\..\script_macros.hpp"
/*
    File: fn_dutySwitch.sqf
    Description:
    Startet den Fraktionswechsel im Spiel (Telefon-App "Dienst"). Prueft die Voraussetzungen,
    speichert die aktuelle Fraktion komplett in der Datenbank und bittet den Server um die Daten
    der neuen Fraktion (TON_fnc_dutySwitch -> life_fnc_dutyReceive).
    Muss per spawn aufgerufen werden.
    Parameter:
        0: SIDE - Zielfraktion: west (Polizei), independent (Rettungsdienst) oder civilian (ausser Dienst)
*/
params [["_side",sideUnknown,[civilian]]];
if !(_side in [west,civilian,independent]) exitWith {};
if (_side isEqualTo life_side) exitWith {};
private _radius = getNumber (missionConfigFile >> "CfgDuty" >> "radius");
private _cooldown = getNumber (missionConfigFile >> "CfgDuty" >> "cooldown");
private _remaining = ceil (_cooldown - (time - life_duty_last));
private _fail = "";
if (life_duty_busy) then {_fail = localize "STR_DUTY_Saving";};
if (_fail isEqualTo "" && {_remaining > 0}) then {_fail = format [localize "STR_DUTY_ErrCooldown", _remaining];};
if (_fail isEqualTo "" && {!alive player || {life_action_inUse} || {life_istazed} || {life_isknocked} || {life_is_processing}}) then {_fail = localize "STR_DUTY_ErrBusy";};
if (_fail isEqualTo "" && {(player getVariable ["restrained",false]) || {player getVariable ["Escorting",false]} || {life_is_arrested}}) then {_fail = localize "STR_DUTY_ErrRestrained";};
if (_fail isEqualTo "" && {!isNull objectParent player}) then {_fail = localize "STR_DUTY_ErrVehicle";};
if (_fail isEqualTo "") then {
    //Dienststelle der uniformierten Seite: Ziel beim Antreten, eigene Seite beim Beenden
    private _uniformed = [_side, life_side] select (_side isEqualTo civilian);
    private _near = [_uniformed] call life_fnc_dutyNearest;
    if (_near isEqualTo [] || {(_near select 2) > _radius}) then {
        private _names = ([_uniformed] call life_fnc_dutyPoints) apply {_x select 1};
        _fail = format [localize "STR_DUTY_ErrStation", _names joinString ", "];
    };
};
if !(_fail isEqualTo "") exitWith {
    [_fail,true,"fast"] call life_fnc_notification_system;
    [] call life_fnc_dutyUpdate;
};
life_duty_busy = true;
[] call life_fnc_dutyUpdate;
closeDialog 0;
if (!isNull (findDisplay 2001)) then {closeDialog 0;};
[localize "STR_DUTY_Saving",false,"fast"] call life_fnc_notification_system;
//Aktuelle Fraktion vollstaendig sichern (Geld, Lizenzen, Ausruestung, Position)
[] call SOCK_fnc_updateRequest;
[player,_side] remoteExec ["TON_fnc_dutySwitch",RSERV];
//Absicherung: bleibt die Antwort aus, wieder freigeben
[] spawn {
    sleep 20;
    if (life_duty_busy) then {
        life_duty_busy = false;
        [localize "STR_DUTY_ErrServer",true,"fast"] call life_fnc_notification_system;
    };
};
