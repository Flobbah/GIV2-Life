#include "..\..\script_macros.hpp"
/*
    File: fn_dutyUpdate.sqf
    Description:
    Aktualisiert die Anzeige der Telefon-App "Dienst" (Dialog 3020): Fraktion, Freigaben,
    naechste Dienststellen mit Entfernung, Buttons und Hinweise.
*/
disableSerialization;
private _display = findDisplay 3020;
if (isNull _display) exitWith {};
private _radius = getNumber (missionConfigFile >> "CfgDuty" >> "radius");
private _cooldown = getNumber (missionConfigFile >> "CfgDuty" >> "cooldown");
private _allowAdmin = (getNumber (missionConfigFile >> "CfgDuty" >> "allowAdmin")) isEqualTo 1;

//Fraktion
private _statusText = switch (life_side) do {
    case west: {format [localize "STR_DUTY_SideCop", FETCH_CONST(life_coplevel)]};
    case independent: {format [localize "STR_DUTY_SideMed", FETCH_CONST(life_medicLevel)]};
    default {localize "STR_DUTY_SideCiv"};
};
(_display displayCtrl 3021) ctrlSetText _statusText;

//Freigaben
private _infoLoaded = (count life_duty_info) >= 5;
private _rankText = localize "STR_DUTY_Checking";
if (_infoLoaded) then {
    _rankText = format [localize "STR_DUTY_Ranks", life_duty_info select 0, life_duty_info select 1];
};
(_display displayCtrl 3022) ctrlSetText _rankText;

//Dienststellen
private _nearCop = [west] call life_fnc_dutyNearest;
private _nearMed = [independent] call life_fnc_dutyNearest;
private _fnc_line = {
    params ["_label","_near"];
    if (_near isEqualTo []) exitWith {format ["%1: %2", _label, localize "STR_DUTY_None"]};
    format ["%1: %2 (%3)", _label, _near select 1, [_near select 2] call life_fnc_navDistText]
};
(_display displayCtrl 3023) ctrlSetText ([localize "STR_DUTY_Police", _nearCop] call _fnc_line);
(_display displayCtrl 3024) ctrlSetText ([localize "STR_DUTY_Hospital", _nearMed] call _fnc_line);

//Buttons und Hinweise
private _canCop = false;
private _canMed = false;
private _canOff = false;
private _reasons = [];
private _remaining = ceil (_cooldown - (time - life_duty_last));
if (_infoLoaded) then {
    life_duty_info params ["_cop","_med","_admin","_blacklist","_wanted"];
    private _copAllowed = ((_cop >= 1) || {_allowAdmin && {_admin >= 1}}) && {!_blacklist};
    private _medAllowed = (_med >= 1) || {_allowAdmin && {_admin >= 1}};
    private _atCop = !(_nearCop isEqualTo []) && {(_nearCop select 2) <= _radius};
    private _atMed = !(_nearMed isEqualTo []) && {(_nearMed select 2) <= _radius};
    private _atOwn = switch (life_side) do {case west: {_atCop}; case independent: {_atMed}; default {false};};
    private _free = !life_duty_busy && {_remaining <= 0};
    _canCop = _free && {!(life_side isEqualTo west)} && {_copAllowed} && {!_wanted} && {_atCop};
    _canMed = _free && {!(life_side isEqualTo independent)} && {_medAllowed} && {!_wanted} && {_atMed};
    _canOff = _free && {!(life_side isEqualTo civilian)} && {_atOwn};
    if (life_duty_busy) then {_reasons pushBack (localize "STR_DUTY_Saving");};
    if (_remaining > 0) then {_reasons pushBack (format [localize "STR_DUTY_ErrCooldown", _remaining]);};
    if (_blacklist) then {_reasons pushBack (localize "STR_DUTY_ErrBlacklist");};
    if (_wanted && {life_side isEqualTo civilian}) then {_reasons pushBack (localize "STR_DUTY_ErrWanted");};
    if (!_copAllowed && !_medAllowed && !_blacklist) then {_reasons pushBack (localize "STR_DUTY_ErrLevel");};
    private _wantsCop = _copAllowed && {!(life_side isEqualTo west)};
    private _wantsMed = _medAllowed && {!(life_side isEqualTo independent)};
    if ((_wantsCop && !_atCop) || {_wantsMed && !_atMed} || {!(life_side isEqualTo civilian) && !_atOwn}) then {
        _reasons pushBack (format [localize "STR_DUTY_ErrDistance", _radius]);
    };
};
(_display displayCtrl 3025) ctrlEnable _canCop;
(_display displayCtrl 3026) ctrlEnable _canMed;
(_display displayCtrl 3027) ctrlEnable _canOff;
private _hint = localize "STR_DUTY_Hint";
if (count _reasons > 0) then {
    _hint = _hint + "<br/><br/><t color='#f0b040'>" + (_reasons joinString "<br/>") + "</t>";
};
(_display displayCtrl 3028) ctrlSetStructuredText parseText _hint;
