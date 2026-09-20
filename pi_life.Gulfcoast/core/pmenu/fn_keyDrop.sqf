/*
    File: fn_keyDrop.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Drops a key to a vehicle (Excluding houses).
*/
disableSerialization;
private _dialog = findDisplay 2700;
private _list = _dialog displayCtrl 2701;
private _sel = lbCurSel _list;
if (_sel isEqualTo -1) exitWith {
    [ localize "STR_NOTF_noDataSelected",true,"fast"] call life_fnc_notification_system
};
if (_list lbData _sel isEqualTo "") exitWith {
    [ localize "STR_NOTF_didNotSelectVehicle",true,"fast"] call life_fnc_notification_system
};
private _index = parseNumber (_list lbData _sel);
private _vehicle = life_vehicles param [_index, objNull, [objNull]];
if isNull _vehicle exitWith {};
// Do not let them drop the key to a house
if (_vehicle isKindOf "House_F") exitWith {
    [ localize "STR_NOTF_cannotRemoveHouseKeys",true,"fast"] call life_fnc_notification_system
};
// Solve stupidness
if (objectParent player isEqualTo _vehicle && {locked _vehicle isEqualTo 2}) exitWith {
    [ localize "STR_NOTF_cannotDropKeys",true,"fast"] call life_fnc_notification_system
};
life_vehicles = life_vehicles - [_vehicle];
// Update vehicle owners
//Sicherheitsprüfung #7: die Schluesselliste fuehrt der Server (TON_fnc_vehicleKeys)
[_vehicle, "drop"] remoteExecCall ["TON_fnc_vehicleKeys",RSERV];
//Die Anzeige am Fahrzeug schreibt der Server zurueck (TON_fnc_vehicleKeysSet)
// Reload
call life_fnc_keyMenu
