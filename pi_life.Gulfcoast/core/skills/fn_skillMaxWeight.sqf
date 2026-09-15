#include "..\..\script_macros.hpp"
/*
    File: fn_skillMaxWeight.sqf
    Description:
    Berechnet die maximale Tragkraft des Spielers: Grundwert aus Config_Master (total_maxWeight),
    plus Rucksack (maximumload / 4 wie im Framework), plus Bonus des Skills "Tragkraft".
    Rueckgabe:
        NUMBER
*/
private _w = LIFE_SETTINGS(getNumber,"total_maxWeight");
if !(backpack player isEqualTo "") then {
    _w = _w + round (FETCH_CONFIG2(getNumber,"CfgVehicles",(backpack player),"maximumload") / 4);
};
_w + (["carry"] call life_fnc_skillBonus)
