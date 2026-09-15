/*
    File: fn_navHookMinimap.sqf
    Description:
    Haengt den Routen-Zeichencode an die GPS-Kaertchen: RscMiniMap (GPS zu Fuss) und
    RscCustomInfoMiniMap (Fahrzeug-Infopanel, idd 311). Beide bestehen aus der Steuerelement-
    gruppe 13301 mit dem Kartensteuerelement 101 darin (aus a3\ui_f\config gelesen) und werden
    ueber BIS_fnc_initDisplay im uiNamespace unter ihrem Klassennamen abgelegt. Arma erzeugt sie
    bei jedem Ein-/Ausblenden neu, deshalb wird diese Funktion regelmaessig aus fn_navLoop
    aufgerufen; ein Merker auf dem Display verhindert doppelte Handler.
*/
disableSerialization;
private _candidates = [
    uiNamespace getVariable ["RscCustomInfoMiniMap", displayNull],
    uiNamespace getVariable ["RscMiniMap", displayNull],
    findDisplay 311
];
{
    private _display = _x;
    if (!isNull _display && {!(_display getVariable ["life_nav_hooked", false])}) then {
        private _group = _display displayCtrl 13301;
        private _map = if (isNull _group) then {controlNull} else {_group controlsGroupCtrl 101};
        if (isNull _map) then {
            //Fallback: irgendein Kartensteuerelement im Display
            {
                if ((ctrlType _x) in [100, 101]) exitWith {_map = _x;};
            } forEach (allControls _display);
        };
        if (!isNull _map) then {
            _map ctrlAddEventHandler ["Draw", life_nav_drawCode];
        };
        _display setVariable ["life_nav_hooked", true];
    };
} forEach _candidates;
