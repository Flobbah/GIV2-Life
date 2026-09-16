#include "..\..\script_macros.hpp"
/*
    File: fn_buyLicense.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Called when purchasing a license. May need to be revised.
*/
private ["_type","_varName","_displayName","_sideFlag","_price"];
_type = _this select 3;
if (!isClass (missionConfigFile >> "Licenses" >> _type)) exitWith {}; //Bad entry?
_displayName = M_CONFIG(getText,"Licenses",_type,"displayName");
_price = M_CONFIG(getNumber,"Licenses",_type,"price");
_sideFlag = M_CONFIG(getText,"Licenses",_type,"side");
_varName = LICENSE_VARNAME(_type,_sideFlag);
if (CASH < _price) exitWith {[ format [localize "STR_NOTF_NE_1",[_price] call life_fnc_numberText,localize _displayName],true,"fast"] call life_fnc_notification_system;};
if (ECONOMY_MODE >= 1) exitWith {
    //Geld-Umbau Schritt 2: der Server bucht den Preis aus Config_Licenses, die Lizenz gibt es erst nach seiner Zusage
    ["TON_fnc_econFee", ["license", _type], {
        (_this select 1) params ["_varName", "_displayName", "_price"];
        titleText[format [localize "STR_NOTF_B_1", localize _displayName,[_price] call life_fnc_numberText],"PLAIN"];
        missionNamespace setVariable [_varName,true];
        [2] call SOCK_fnc_updatePartial;
    }, {
        (_this select 1) params ["", "_displayName", "_price"];
        [ format [localize "STR_NOTF_NE_1",[_price] call life_fnc_numberText,localize _displayName],true,"fast"] call life_fnc_notification_system;
    }, [_varName, _displayName, _price]] call life_fnc_econRequest;
};
CASH = CASH - _price;
[0] call SOCK_fnc_updatePartial;
titleText[format [localize "STR_NOTF_B_1", localize _displayName,[_price] call life_fnc_numberText],"PLAIN"];
missionNamespace setVariable [_varName,true];
[2] call SOCK_fnc_updatePartial;
