#include "..\..\script_macros.hpp"
/*
    File: fn_p_updateMenu.sqf
    Author: Bryan "Tonic" Boardwine
    Edit: Telefon-Layout - fuellt Startseite (Name, Geld, Gewicht), Inventar-, Lizenz- und Geldseite
    Description:
    Updates the player menu (Virtual Interaction Menu)
*/
private ["_inv","_lic","_licenses","_near","_near_units","_mstatus","_mpage","_shrt","_side","_struct","_bank","_cash","_gridW","_gridH","_textH"];
disableSerialization;
if (isNull (findDisplay 2001)) exitWith {};
_side = switch (life_side) do {case west:{"cop"}; case civilian:{"civ"}; case independent:{"med"};};
_inv = CONTROL(2001,2005);
_lic = CONTROL(2001,2014);
_near = CONTROL(2001,2022);
_near_i = CONTROL(2001,2023);
_mstatus = CONTROL(2001,2015);
_mpage = CONTROL(2001,2063);
_struct = "";
lbClear _inv;
lbClear _near;
lbClear _near_i;
//Near players
_near_units = [];
{ if (player distance _x < 10) then {_near_units pushBack _x};} forEach playableUnits;
{
    if (!isNull _x && alive _x && player distance _x < 10 && !(_x isEqualTo player)) then {
        _near lbAdd format ["%1 - %2",_x getVariable ["realname",name _x], SIDE_OF(_x)];
        _near lbSetData [(lbSize _near)-1,str(_x)];
        _near_i lbAdd format ["%1 - %2",_x getVariable ["realname",name _x], SIDE_OF(_x)];
        _near_i lbSetData [(lbSize _near)-1,str(_x)];
    };
} forEach _near_units;
//Kopfzeile der Startseite und Geldseite
_bank = [BANK] call life_fnc_numberText;
_cash = [CASH] call life_fnc_numberText;
_mstatus ctrlSetStructuredText parseText format ["<img size='1.1' image='\pi_data\icons\ico_bank.paa'/> <t size='0.9'>$%1</t>      <img size='1.1' image='\pi_data\icons\ico_money.paa'/> <t size='0.9'>$%2</t>",_bank,_cash];
_mpage ctrlSetStructuredText parseText format ["<img size='1.2' image='\pi_data\icons\ico_bank.paa'/> <t size='0.95'>%1: $%2</t><br/><img size='1.2' image='\pi_data\icons\ico_money.paa'/> <t size='0.95'>%3: $%4</t>",localize "STR_PM_Bank",_bank,localize "STR_PM_Cash",_cash];
ctrlSetText[2031,player getVariable ["realname",name player]];
ctrlSetText[2009,format [localize "STR_PM_Weight", life_carryWeight, life_maxWeight]];
//Inventar
{
    if (ITEM_VALUE(configName _x) > 0) then {
        _inv lbAdd format ["%2 [x%1]",ITEM_VALUE(configName _x),localize (getText(_x >> "displayName"))];
        _inv lbSetData [(lbSize _inv)-1,configName _x];
        _icon = M_CONFIG(getText,"VirtualItems",configName _x,"icon");
        if (!(_icon isEqualTo "")) then {
            _inv lbSetPicture [(lbSize _inv)-1,_icon];
        };
    };
} forEach ("true" configClasses (missionConfigFile >> "VirtualItems"));
//Lizenzen
{
    _displayName = getText(_x >> "displayName");
    if (LICENSE_VALUE(configName _x,_side)) then {
        _struct = _struct + format ["%1<br/>",localize _displayName];
    };
} forEach (format ["getText(_x >> 'side') isEqualTo '%1'",_side] configClasses (missionConfigFile >> "Licenses"));
if (_struct isEqualTo "") then {
    _struct = localize "STR_PM_NoLicenses";
};
_lic ctrlSetStructuredText parseText format ["<t size='0.95'>%1</t>",_struct];
//Textfeld an den Inhalt anpassen, damit lange Lizenzlisten in der Gruppe scrollbar sind
_gridW = (((safezoneW / safezoneH) min 1.2) / 40);
_gridH = ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25);
_lic ctrlSetPosition [0, 0, 8.9 * _gridW, 17.4 * _gridH];
_lic ctrlCommit 0;
_textH = ctrlTextHeight _lic;
_lic ctrlSetPosition [0, 0, 8.9 * _gridW, (_textH + _gridH) max (17.4 * _gridH)];
_lic ctrlCommit 0;
