#include "..\..\script_macros.hpp"
/*
    File: fn_skillsMenu.sqf
    Description:
    Fuellt die Telefon-App "Skills" (Dialog 2980): je Skill Name, Stufe, Bonus, Erfahrung und
    Fortschrittsbalken bis zur naechsten Stufe. Zeigt die ersten fuenf Skills aus CfgSkills.
*/
disableSerialization;
waitUntil {!isNull (findDisplay 2980)};
private _display = findDisplay 2980;
private _skills = "true" configClasses (missionConfigFile >> "CfgSkills");
for "_i" from 0 to 4 do {
    private _card = _display displayCtrl (2981 + _i);
    private _title = _display displayCtrl (2986 + _i);
    private _bonus = _display displayCtrl (2991 + _i);
    private _xpText = _display displayCtrl (2996 + _i);
    private _bar = _display displayCtrl (3001 + _i);
    private _levelText = _display displayCtrl (3006 + _i);
    if (_i < count _skills) then {
        private _cfg = _skills select _i;
        private _name = configName _cfg;
        ([_name] call life_fnc_skillLevel) params ["_lvl","_xp","_cur","_next"];
        _title ctrlSetText (localize (getText (_cfg >> "displayName")));
        if (_next isEqualTo -1) then {
            _levelText ctrlSetText format [localize "STR_SK_LevelMax", _lvl];
            _xpText ctrlSetText format ["%1 XP", round _xp];
            _bar progressSetPosition 1;
        } else {
            _levelText ctrlSetText format [localize "STR_SK_Level", _lvl];
            _xpText ctrlSetText format [localize "STR_SK_XP", floor _xp, _next];
            _bar progressSetPosition ((_xp - _cur) / ((_next - _cur) max 1));
        };
        if (_lvl isEqualTo 0) then {
            _bonus ctrlSetText (localize "STR_SK_NoBonus");
        } else {
            //%3 = Prozentzeichen (format kennt keine %%-Maskierung)
            _bonus ctrlSetText format [localize (getText (_cfg >> "description")), [_name] call life_fnc_skillBonus, [_name, "bonus2PerLevel"] call life_fnc_skillBonus, "%"];
        };
        {_x ctrlShow true;} forEach [_card,_title,_bonus,_xpText,_bar,_levelText];
    } else {
        {_x ctrlShow false;} forEach [_card,_title,_bonus,_xpText,_bar,_levelText];
    };
};
