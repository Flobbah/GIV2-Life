#include "..\..\script_macros.hpp"
/*
    File: fn_adminHeal.sqf
    Description:
    Heals the admin himself (mode 0) or the player selected in the admin menu (mode 1).
    The actual healing runs on the target client in fn_adminHealed.sqf.
*/
params [["_mode",0,[0]]];
if (FETCH_CONST(life_adminlevel) < 2) exitWith {closeDialog 0; [ localize "STR_ANOTF_ErrorLevel",true,"fast"] call life_fnc_notification_system;};
if (_mode isEqualTo 0) exitWith {
    [player] call life_fnc_adminHealed;
    [ localize "STR_ANOTF_HealedSelf",false,"fast"] call life_fnc_notification_system;
};
private _target = [] call life_fnc_adminTarget;
if (isNull _target) exitWith {[ localize "STR_ANOTF_NoTarget",true,"fast"] call life_fnc_notification_system;};
if (!alive _target) exitWith {[ localize "STR_ANOTF_Error",true,"fast"] call life_fnc_notification_system;};
if (_target isEqualTo player) exitWith {[0] call life_fnc_adminHeal;};
["life_fnc_adminHealed",[player],_target] call life_fnc_relaySend;
[ format [localize "STR_ANOTF_HealedTarget",_target getVariable ["realname",name _target]],false,"fast"] call life_fnc_notification_system;
