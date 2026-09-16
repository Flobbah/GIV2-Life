#include "\life_server\script_macros.hpp"
/*
    File: fn_wantedAdd.sqf
    Author: Bryan "Tonic" Boardwine"
    Database Persistence By: ColinM
    Assistance by: Paronity
    Stress Tests by: Midgetgrimm
    Description:
    Adds or appends a unit to the wanted list.
*/
params [
    ["_uid","",[""]],
    ["_name","",[""]],
    ["_type","",[""]],
    ["_customBounty",-1,[0]]
];
if (_uid isEqualTo "" || {_type isEqualTo ""} || {_name isEqualTo ""}) exitWith {}; //Bad data passed.
//Sicherheitsphase 0.1: Polizei darf jede Tat eintragen. Andere Spieler duerfen sich selbst belasten
//oder als Opfer Mord (187, 187V), Raub (211) und Tankstellenraub (23) melden; eigene Kopfgelder nur Polizei.
private _caller = CALLER_OWNER;
private _deny = "";
if !(_caller isEqualTo 2) then {
    private _info = [_caller] call TON_fnc_callerInfo;
    if (_info isEqualTo []) then {_deny = "unknown sender";} else {
        _info params ["_senderUid", "", "_senderSide"];
        private _isCop = _senderSide isEqualTo west;
        switch (true) do {
            case (!(_uid regexMatch "\d{17}")): {_deny = format ["invalid uid %1", _uid];};
            case (!_isCop && {!(_customBounty isEqualTo -1)}): {_deny = "custom bounty from a non-cop";};
            case (!_isCop && {!(_uid isEqualTo _senderUid)} && {!(_type in ["187","187V","211","23"])}): {_deny = format ["crime %1 against another player from a non-cop", _type];};
        };
    };
};
if (!(_deny isEqualTo "") && {[_caller, "life_fnc_wantedAdd", _deny] call TON_fnc_denyCaller}) exitWith {};
//What is the crime?
private _crimesConfig = getArray(missionConfigFile >> "Life_Settings" >> "crimes");
private _index = [_type,_crimesConfig] call TON_fnc_index;
if (_index isEqualTo -1) exitWith {};
_type = [_type, parseNumber ((_crimesConfig select _index) select 1)];
if (count _type isEqualTo 0) exitWith {}; //Not our information being passed...
//Is there a custom bounty being sent? Set that as the pricing.
if !(_customBounty isEqualTo -1) then {_type set[1,_customBounty];};
//Search the wanted list to make sure they are not on it.
private _query = format ["SELECT wantedID FROM wanted WHERE wantedID='%1'",_uid];
private _queryResult = [_query,2,true] call DB_fnc_asyncCall;
private _val = [_type select 1] call DB_fnc_numberSafe;
private _number = _type select 0;
if !(count _queryResult isEqualTo 0) then {
    _query = format ["SELECT wantedCrimes, wantedBounty FROM wanted WHERE wantedID='%1'",_uid];
    _queryResult = [_query,2] call DB_fnc_asyncCall;
    _pastCrimes = [_queryResult select 0] call DB_fnc_mresToArray;
    if (_pastCrimes isEqualType "") then {_pastCrimes = call compile format ["%1", _pastCrimes];};
    _pastCrimes pushBack _number;
    _pastCrimes = [_pastCrimes] call DB_fnc_mresArray;
    _query = format ["UPDATE wanted SET wantedCrimes = '%1', wantedBounty = wantedBounty + '%2', active = '1' WHERE wantedID='%3'",_pastCrimes,_val,_uid];
    [_query,1] call DB_fnc_asyncCall;
} else {
    _crime = [_type select 0];
    _crime = [_crime] call DB_fnc_mresArray;
    _query = format ["INSERT INTO wanted (wantedID, wantedName, wantedCrimes, wantedBounty, active) VALUES('%1', '%2', '%3', '%4', '1')",_uid,_name,_crime,_val];
    [_query,1] call DB_fnc_asyncCall;
};
