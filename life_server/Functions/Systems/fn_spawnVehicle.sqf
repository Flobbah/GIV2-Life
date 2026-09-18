#include "\life_server\script_macros.hpp"
/*
    File: fn_spawnVehicle.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Sends the query request to the database, if an array is returned then it creates
    the vehicle if it's not in use or dead.
    Edited: freies Abstellen. _sp darf jetzt auch [PosASL, VectorDir, VectorUp, aufWasser] sein
    (life_fnc_placementStart); dann wird Abstand zum Spieler geprueft, nur ein direkt ueberlappendes
    Fahrzeug blockiert und das Fahrzeug exakt so ausgerichtet wie die Vorschau.
*/
params [
    ["_vid", -1, [0]],
    ["_pid", "", [""]],
    ["_sp", [], [[],""]],
    ["_unit", objNull, [objNull]],
    ["_price", 0, [0]],
    ["_dir", 0, [0]],
    ["_spawntext", "", [""]]
];
if !([CALLER_OWNER, _unit, _pid, sideUnknown, "TON_fnc_spawnVehicle"] call TON_fnc_checkCaller) exitWith {};
private _unit_return = _unit;
private _name = name _unit;
private _side = AUTH_SIDE(_pid); //Sicherheitsphase 0.2: _pid ist per checkCaller die UID des Absenders
_unit = owner _unit;
if (_vid isEqualTo -1 || {_pid isEqualTo ""}) exitWith {};
private _svUse = localNamespace getVariable ["serv_sv_use", []]; //Sicherheitsphase 0.2 Welle 2
if (_vid in _svUse) exitWith {};
private _placed = (_sp isEqualTypeArray [[],[],[],true]) && {(_sp select 0) isEqualTypeArray [0,0,0]} && {(_sp select 1) isEqualTypeArray [0,0,0]} && {(_sp select 2) isEqualTypeArray [0,0,0]};
private _badSp = !_placed && {_sp isEqualType []} && {!(_sp isEqualTypeArray [0,0,0])};
if (_placed) then {
    private _cfgPl = missionConfigFile >> "CfgVehiclePlacement";
    private _plMax = ((getNumber (_cfgPl >> "maxDistanceCar")) max (getNumber (_cfgPl >> "maxDistanceAir")) max (getNumber (_cfgPl >> "maxDistanceShip"))) + 25;
    if (((getPosASL _unit_return) distance2D (_sp select 0)) > _plMax) then {_badSp = true;};
};
if (_badSp) exitWith {
    diag_log format ["[PLACEMENT] %1 (%2): Abstellplatz ungueltig oder zu weit entfernt, Fahrzeug %3 nicht erzeugt: %4", _name, _pid, _vid, _sp];
    if (ECONOMY_MODE isEqualTo 0) then {[_price,_unit_return] remoteExecCall ["life_fnc_garageRefund",_unit]}; //ab Modus 1 wird erst beim Erfolg gebucht
    [1,"STR_PLC_ErrServer",true] remoteExecCall ["life_fnc_broadcast",_unit];
};
_svUse pushBack _vid;
private _servIndex = _svUse find _vid;
private _query = format ["SELECT id, side, classname, type, pid, alive, active, plate, color, inventory, gear, fuel, damage, blacklist FROM vehicles WHERE id='%1' AND pid='%2'",_vid,_pid];
private _tickTime = diag_tickTime;
private _queryResult = [_query,2] call DB_fnc_asyncCall;
if (EXTDB_SETTING(getNumber,"DebugMode") isEqualTo 1) then {
    diag_log "------------- Client Query Request -------------";
    diag_log format ["QUERY: %1",_query];
    diag_log format ["Time to complete: %1 (in seconds)",(diag_tickTime - _tickTime)];
    diag_log format ["Result: %1",_queryResult];
    diag_log "------------------------------------------------";
};
if (_queryResult isEqualType "") exitWith {};
private _vInfo = _queryResult;
if (isNil "_vInfo") exitWith {_svUse deleteAt _servIndex;};
if (count _vInfo isEqualTo 0) exitWith {_svUse deleteAt _servIndex;};
if ((_vInfo select 5) isEqualTo 0) exitWith {
    _svUse deleteAt _servIndex;
    [1,"STR_Garage_SQLError_Destroyed",true,[_vInfo select 2]] remoteExecCall ["life_fnc_broadcast",_unit];
};
if ((_vInfo select 6) isEqualTo 1) exitWith {
    _svUse deleteAt _servIndex;
    [1,"STR_Garage_SQLError_Active",true,[_vInfo select 2]] remoteExecCall ["life_fnc_broadcast",_unit];
};
private "_nearVehicles";
if (_placed) then {
    //der Client prueft den Platz genau; hier nur Schutz gegen Stapeln auf ein anderes Fahrzeug
    _nearVehicles = nearestObjects [ASLToAGL (_sp select 0),["Car","Air","Ship","Tank"],2.5];
} else {
    if !(_sp isEqualType "") then {
        _nearVehicles = nearestObjects[_sp,["Car","Air","Ship"],10];
    } else {
        _nearVehicles = [];
    };
};
if (count _nearVehicles > 0) exitWith {
    _svUse deleteAt _servIndex;
    if (ECONOMY_MODE isEqualTo 0) then {[_price,_unit_return] remoteExecCall ["life_fnc_garageRefund",_unit]}; //ab Modus 1 wird erst beim Erfolg gebucht
    [1,"STR_Garage_SpawnPointError",true] remoteExecCall ["life_fnc_broadcast",_unit];
};
//Geld-Umbau Schritt 2: Garagen-/Verwahrgebuehr bucht der Server erst jetzt, wenn das Ausparken sicher klappt
private _feeFailed = -1;
if (ECONOMY_MODE >= 1) then {
    private _fee = [(_vInfo select 2), _side, "storage"] call TON_fnc_econVehiclePrice;
    if !([_pid, "bank", -_fee, "garage_fee", "", (_vInfo select 2)] call TON_fnc_moneyChange) then {_feeFailed = _fee};
};
if (_feeFailed >= 0) exitWith {
    _svUse deleteAt _servIndex;
    [1,"STR_Garage_CashError",true,[[_feeFailed] call life_fnc_numberText]] remoteExecCall ["life_fnc_broadcast",_unit];
};
_query = format ["UPDATE vehicles SET active='1', damage='""[]""' WHERE pid='%1' AND id='%2'",_pid,_vid];
private _trunk = [(_vInfo select 9)] call DB_fnc_mresToArray;
private _gear = [(_vInfo select 10)] call DB_fnc_mresToArray;
private _damage = [call compile (_vInfo select 12)] call DB_fnc_mresToArray;
private _wasIllegal = _vInfo select 13;
_wasIllegal = if (_wasIllegal isEqualTo 1) then { true } else { false };
[_query,1] call DB_fnc_asyncCall;
private "_vehicle";
if (_placed) then {
    _sp params ["_pPos","_pDir","_pUp","_pWater"];
    _pUp = vectorNormalized _pUp;
    if ((_pUp select 2) < 0.5) then {_pUp = [0,0,1];};
    _pDir = vectorNormalized (_pDir vectorDiff (_pUp vectorMultiply (_pDir vectorDotProduct _pUp)));
    if ((vectorMagnitude _pDir) < 0.5) then {_pDir = [0,1,0];};
    _vehicle = createVehicle [(_vInfo select 2),ASLToAGL _pPos,[],0,"CAN_COLLIDE"];
    waitUntil {!isNil "_vehicle" && {!isNull _vehicle}};
    _vehicle allowDamage false;
    _vehicle setVectorDirAndUp [_pDir,_pUp];
    if (_pWater) then {
        _vehicle setPosASLW [_pPos select 0,_pPos select 1,0];
    } else {
        _vehicle setPosASL (_pPos vectorAdd [0,0,0.05]);
    };
} else {
if (_sp isEqualType "") then {
    _vehicle = createVehicle[(_vInfo select 2),[0,0,999],[],0,"NONE"];
    waitUntil {!isNil "_vehicle" && {!isNull _vehicle}};
    _vehicle allowDamage false;
    private _hs;
    _hs = nearestObjects[getMarkerPos _sp,["Land_Hospital_side2_F"],50] select 0;
    _vehicle setPosATL (_hs modelToWorld [-0.4,-4,12.65]);
    uiSleep 0.6;
} else {
    _vehicle = createVehicle [(_vInfo select 2),_sp,[],0,"NONE"];
    waitUntil {!isNil "_vehicle" && {!isNull _vehicle}};
    _vehicle allowDamage false;
    _vehicle setPos _sp;
    _vehicle setVectorUp (surfaceNormal _sp);
    _vehicle setDir _dir;
};
};
if (_placed) then {
    //Schaden erst nach dem Einschwingen der Federung wieder zulassen
    [_vehicle] spawn {uiSleep 2; (_this select 0) allowDamage true;};
} else {
    _vehicle allowDamage true;
};
//Send keys over the network.
[_vehicle] remoteExecCall ["life_fnc_addVehicle2Chain",_unit];
[_pid,_side,_vehicle,1] call TON_fnc_keyManagement;
_vehicle lock 2;
//Reskin the vehicle
[_vehicle,(_vInfo select 8)] remoteExecCall ["life_fnc_colorVehicle",_unit];
// --- Set D3S License Plate (serverside) ---
private _plate = (_vInfo select 7);
if !(_plate isEqualType "") then { _plate = str _plate; };
_plate = toLower _plate;
// Optional: Set To 7 Numbers (D3S Uses 7 Slots: 20-26)
_plate = _plate select [0,7];
// Only For D3S Classes
if ((toLower typeOf _vehicle) find "d3s_" == 0) then {
    [_vehicle, _plate] call d3s_fnc_setlicense;
};
_vehicle setVariable ["vehicle_info_owners",[[_pid,_name]],true];
_vehicle setVariable ["dbInfo",[(_vInfo select 4),(_vInfo select 7)],true];
[_vehicle, "dbInfo", [(_vInfo select 4),(_vInfo select 7)]] call TON_fnc_serverSet; //Sicherheitsphase 0.2
_vehicle disableTIEquipment true; //No Thermals.. They're cheap but addictive.
[_vehicle] call life_fnc_clearVehicleAmmo;
if (LIFE_SETTINGS(getNumber,"save_vehicle_virtualItems") isEqualTo 1) then {
    _vehicle setVariable ["Trunk",_trunk,true];
    
    if (_wasIllegal) then {
        private _refPoint = switch (true) do {
            case (_placed): {ASLToAGL (_sp select 0)};
            case (_sp isEqualType ""): {getMarkerPos _sp};
            default {_sp};
        };
        
        private _distance = 100000;
        private "_location";
        {
            private _tempLocation = nearestLocation [_refPoint, _x];
            private _tempDistance = _refPoint distance _tempLocation;
    
            if (_tempDistance < _distance) then {
                _location = _tempLocation;
                _distance = _tempDistance;
            };
            false
    
        } count ["NameCityCapital", "NameCity", "NameVillage"];
 
        _location = text _location;
        [1,"STR_NOTF_BlackListedVehicle",true,[_location,_name]] remoteExecCall ["life_fnc_broadcast",west];
        _query = format ["UPDATE vehicles SET blacklist='0' WHERE id='%1' AND pid='%2'",_vid,_pid];
        [_query,1] call DB_fnc_asyncCall;
    };
} else {
    _vehicle setVariable ["Trunk",[[],0],true];
};
if (LIFE_SETTINGS(getNumber,"save_vehicle_fuel") isEqualTo 1) then {
    _vehicle setFuel (_vInfo select 11);
    }else{
    _vehicle setFuel 1;
};
if (count _gear > 0 && (LIFE_SETTINGS(getNumber,"save_vehicle_inventory") isEqualTo 1)) then {
    private _items = _gear select 0;
    private _mags = _gear select 1;
    private _weapons = _gear select 2;
    private _backpacks = _gear select 3;
    for "_i" from 0 to ((count (_items select 0)) - 1) do {
        _vehicle addItemCargoGlobal [((_items select 0) select _i), ((_items select 1) select _i)];
    };
    for "_i" from 0 to ((count (_mags select 0)) - 1) do {
        _vehicle addMagazineCargoGlobal [((_mags select 0) select _i), ((_mags select 1) select _i)];
    };
    for "_i" from 0 to ((count (_weapons select 0)) - 1) do {
        _vehicle addWeaponCargoGlobal [((_weapons select 0) select _i), ((_weapons select 1) select _i)];
    };
    for "_i" from 0 to ((count (_backpacks select 0)) - 1) do {
        _vehicle addBackpackCargoGlobal [((_backpacks select 0) select _i), ((_backpacks select 1) select _i)];
    };
};
if (count _damage > 0 && (LIFE_SETTINGS(getNumber,"save_vehicle_damage") isEqualTo 1)) then {
    private _parts = getAllHitPointsDamage _vehicle;
    for "_i" from 0 to ((count _damage) - 1) do {
        _vehicle setHitPointDamage [format ["%1",((_parts select 0) select _i)],_damage select _i];
    };
};
//Sets of animations
if ((_vInfo select 1) isEqualTo "civ" && (_vInfo select 2) isEqualTo "B_Heli_Light_01_F" && !((_vInfo select 8) isEqualTo 13)) then {
    [_vehicle,"civ_littlebird",true] remoteExecCall ["life_fnc_vehicleAnimate",_unit];
};
if ((_vInfo select 1) isEqualTo "cop" && ((_vInfo select 2)) in ["C_Offroad_01_F","B_MRAP_01_F","C_SUV_01_F","C_Hatchback_01_sport_F","B_Heli_Light_01_F","B_Heli_Transport_01_F"]) then {
    [_vehicle,"cop_offroad",true] remoteExecCall ["life_fnc_vehicleAnimate",_unit];
};
if ((_vInfo select 1) isEqualTo "med" && (_vInfo select 2) isEqualTo "C_Offroad_01_F") then {
    [_vehicle,"med_offroad",true] remoteExecCall ["life_fnc_vehicleAnimate",_unit];
};
[1,_spawntext] remoteExecCall ["life_fnc_broadcast",_unit];
_svUse deleteAt _servIndex;
