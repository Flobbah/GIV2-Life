#include "\life_server\script_macros.hpp"
/*
    File : fn_sellHouseContainer.sqf
    Author: NiiRoZz
    Description:
    Used in selling the house, container sets the owned to 0 and will cleanup with a
    stored procedure on restart.
*/
private ["_house","_houseID","_ownerID","_housePos","_query","_radius","_containers"];
_container = [_this,0,objNull,[objNull]] call BIS_fnc_param;
if (isNull _container) exitWith {};
private _caller = CALLER_OWNER; //Sicherheitsphase 0.1: Absender pruefen
if (!(_caller isEqualTo 2) && {!((([_caller] call TON_fnc_callerInfo) param [0, ""]) isEqualTo (([_container, "container_owner", []] call TON_fnc_serverGet) param [0, "-"]))} && {[_caller, "TON_fnc_sellHouseContainer", "sender does not own the container"] call TON_fnc_denyCaller}) exitWith {};
_containerID = [_container, "container_id", -1] call TON_fnc_serverGet; //Sicherheitsphase 0.2: nicht die faelschbare Objekt-Variable (SQL)
if (_containerID isEqualTo -1) then {
    _containerPos = getPosATL _container;
    _ownerID = ([_container, "container_owner", []] call TON_fnc_serverGet) param [0, ""];
    _query = format ["UPDATE containers SET owned='0', pos='[]' WHERE pid='%1' AND pos='%2' AND owned='1'",_ownerID,_containerPos];
} else {
    _query = format ["UPDATE containers SET owned='0', pos='[]' WHERE id='%1'",_containerID];
};
_container setVariable ["container_id",nil,true];
_container setVariable ["container_owner",nil,true];
[_container, "container_id"] call TON_fnc_serverSet;
[_container, "container_owner"] call TON_fnc_serverSet;
deleteVehicle _container;
[_query,1] call DB_fnc_asyncCall;
["CALL deleteOldContainers",1] call DB_fnc_asyncCall;
