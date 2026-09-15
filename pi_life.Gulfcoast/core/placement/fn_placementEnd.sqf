#include "..\..\script_macros.hpp"
/*
    File: fn_placementEnd.sqf
    Description:
    Beendet das Abstellen: entfernt Ereignisse, Hinweisleiste und Vorschau (vor dem echten Fahrzeug,
    damit beide nicht kollidieren) und ruft den passenden Rueckruf gespawnt auf.
    Parameter:
        0: BOOL   - true = abstellen bestaetigt, false = abgebrochen
        1: STRING - Stringtable-Schluessel fuer die Abbruchmeldung ("" = keine Meldung)
*/
params [["_confirmed", false, [false]], ["_reason", "", [""]]];
if (!life_placement_active) exitWith {};
life_placement_active = false;
private _p = life_placement;
removeMissionEventHandler ["EachFrame", _p get "ehFrame"];
removeMissionEventHandler ["Draw3D", _p get "ehDraw"];
(findDisplay 46) displayRemoveEventHandler ["MouseZChanged", _p get "ehWheel"];
{inGameUISetEventHandler [_x, ""];} forEach ["PrevAction", "NextAction", "Action"];
("life_placement" call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
private _ghost = _p get "ghost";
if (!isNull _ghost) then {
    {deleteVehicle _x;} forEach (attachedObjects _ghost);
    deleteVehicle _ghost;
};
if (_confirmed) then {
    [_p get "args", _p get "pos", _p get "vDir", _p get "vUp", _p get "water", _p get "class"] spawn (_p get "onConfirm");
} else {
    if !(_reason isEqualTo "") then {[localize _reason, true, "fast"] call life_fnc_notification_system;};
    [_p get "args"] spawn (_p get "onCancel");
};
