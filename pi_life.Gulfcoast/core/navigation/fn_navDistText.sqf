/*
    File: fn_navDistText.sqf
    Description:
    Formatiert eine Entfernung in Metern als "850 m" bzw. "3,2 km".
    Parameter:
        0: NUMBER - Entfernung in Metern
    Rueckgabe:
        STRING
*/
params [["_m",0,[0]]];
if (_m < 1000) exitWith {format ["%1 m", round _m]};
private _km = (round (_m / 100)) / 10;
private _txt = str _km;
if ((_txt find ".") isEqualTo -1) then {_txt = _txt + ".0";};
format ["%1 km", _txt]
