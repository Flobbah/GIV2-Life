#include "..\..\script_macros.hpp"
/*
	File: fn_chopShopSold.sqf
	Author: Casperento
	
	Description:
	Finish chopshop sell process properly
*/
SERVER_ONLY_REMOTE; //Sicherheitsphase 0.1: nur der Server darf diese Funktion remote aufrufen
params [
    ["_price",-1,[-1]],
    ["_displayName","",[""]]
];
life_action_inUse = false;
if (_price > 0) then {
    if (ECONOMY_MODE isEqualTo 0) then { //ab Modus 1 bucht der Server den Erloes (TON_fnc_chopShopSell)
        CASH = CASH + _price;
        [0] call SOCK_fnc_updatePartial;
    };
    titleText [format[(localize "STR_NOTF_ChopSoldCar"),_displayName,[_price] call life_fnc_numberText],"PLAIN",1];
};