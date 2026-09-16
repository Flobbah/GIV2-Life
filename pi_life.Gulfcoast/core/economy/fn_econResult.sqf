#include "..\..\script_macros.hpp"
/*
    File: fn_econResult.sqf
    Description:
    Shows the server's answer to a money request (docs/ECONOMY_AUTHORITY.md). Arguments that are
    stringtable keys (STR_...) are translated on this client, so every player reads them in their
    own language.
    Parameters:
        0: STRING - stringtable key of the message
        1: ARRAY  - format arguments
        2: BOOL   - true = error style
        3: BOOL   - (optional) true = the message contains structured text tags
*/
SERVER_ONLY_REMOTE;
params [["_key", "", [""]], ["_args", [], [[]]], ["_error", false, [false]], ["_structured", false, [false]]];
if (_key isEqualTo "") exitWith {};
_args = _args apply {if (_x isEqualType "" && {(_x select [0, 4]) isEqualTo "STR_"}) then {localize _x} else {_x}};
private _text = format ([localize _key] + _args);
[[_text, parseText _text] select _structured, _error, "fast"] call life_fnc_notification_system;
