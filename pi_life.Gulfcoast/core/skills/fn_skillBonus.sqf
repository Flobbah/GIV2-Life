/*
    File: fn_skillBonus.sqf
    Description:
    Liefert den aktuellen Bonus eines Skills (Wert je Stufe aus CfgSkills mal erreichte Stufe).
    Parameter:
        0: STRING - Skillname
        1: STRING - Feld in CfgSkills, Standard "bonusPerLevel" (alternativ "bonus2PerLevel")
    Rueckgabe:
        NUMBER
*/
params [["_skill","",[""]],["_field","bonusPerLevel",[""]]];
private _cfg = missionConfigFile >> "CfgSkills" >> _skill;
if (!isClass _cfg) exitWith {0};
(getNumber (_cfg >> _field)) * (([_skill] call life_fnc_skillLevel) select 0)
