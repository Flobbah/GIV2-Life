/*
    File: fn_numberText.sqf
    Author: Karel Moricky (original), rewritten for performance
    Description:
    Convert a number into a string with thousands separators (avoiding scientific notation).
    Uses toFixed instead of BIS_fnc_numberDigits/BIS_fnc_param - this function is called
    every second by the HUD and in nearly every money related script.
    Parameter(s):
    0: NUMBER
    1: NUMBER (optional) - digits per group, default 3
    Returns:
    STRING
*/
params [["_number",0,[0]],["_mod",3,[0]]];
private _str = (abs _number) toFixed 0;
private _len = count _str;
if (_len <= _mod) exitWith {if (_number < 0) then {"-" + _str} else {_str}};
private _out = "";
{
    _out = _out + _x;
    private _remaining = _len - _forEachIndex - 1;
    if (_remaining > 0 && {(_remaining % _mod) isEqualTo 0}) then {_out = _out + ",";};
} forEach (_str splitString "");
if (_number < 0) then {"-" + _out} else {_out};
