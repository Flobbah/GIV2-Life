/*
    File: fn_numberSafe.sqf
    Author: Karel Moricky (original), rewritten for performance
    Description:
    Convert a number into a plain digit string (no scientific notation) for SQL statements.
    Uses toFixed instead of BIS_fnc_numberDigits/BIS_fnc_param.
    Parameter(s):
    0: NUMBER
    Returns:
    STRING
*/
params [["_number",0,[0]]];
_number toFixed 0
