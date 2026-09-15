#include "..\..\script_macros.hpp"
/*
    File: fn_dutyPaycheck.sqf
    Description:
    Setzt life_paycheck passend zur aktuellen Fraktion (life_side) und zum Cop-Rang.
    Wird beim Login (core\init.sqf) und nach jedem Dienstwechsel aufgerufen.
*/
private _pay = switch (life_side) do {
    case west: {
        private _byRank = [900,1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000,2100];
        private _rank = FETCH_CONST(life_coplevel);
        if (_rank >= 1 && {_rank <= count _byRank}) then {_byRank select (_rank - 1)} else {LIFE_SETTINGS(getNumber,"paycheck_cop")};
    };
    case independent: {LIFE_SETTINGS(getNumber,"paycheck_med")};
    default {LIFE_SETTINGS(getNumber,"paycheck_civ")};
};
life_paycheck = _pay;
CONSTVAR_MUTABLE(life_paycheck);
