#include "\life_server\script_macros.hpp"
/*
    File: fn_wantedBounty.sqf
    Author: Bryan "Tonic" Boardwine"
    Database Persistence By: ColinM
    Assistance by: Paronity
    Stress Tests by: Midgetgrimm
    Description:
    Checks if the person is on the bounty list and awards the cop for killing them.
*/
params [
    ["_uid","",[""]],
    ["_civ",objNull,[objNull]],
    ["_cop",objNull,[objNull]],
    ["_half",false,[false]]
];
if (isNull _civ || isNull _cop) exitWith {};
//Sicherheitsphase 0.1: Kopfgeld bei Festnahme nur auf Anfrage des festnehmenden Polizisten in der Naehe,
//das halbe Kopfgeld nach dem Tod nur auf Anfrage des getoeteten Zivilisten selbst
private _caller = CALLER_OWNER;
private _deny = "";
if !(_caller isEqualTo 2) then {
    private _info = [_caller] call TON_fnc_callerInfo;
    if (_info isEqualTo []) then {_deny = "unknown sender";} else {
        private _senderUid = _info select 0;
        switch (true) do {
            case (!(_uid regexMatch "\d{17}") || {!((getPlayerUID _civ) isEqualTo _uid)}): {_deny = "uid does not belong to the civilian";};
            case (!((AUTH_SIDE(getPlayerUID _cop)) isEqualTo west)): {_deny = "bounty receiver is not a cop";};
            case (!_half && {!((owner _cop) isEqualTo _caller)}): {_deny = "arrest bounty not requested by the arresting cop";};
            case (!_half && {(_cop distance _civ) > 25}): {_deny = "arresting cop too far from the civilian";};
            case (_half && {!(_senderUid isEqualTo _uid)}): {_deny = "death bounty not requested by the civilian";};
        };
    };
};
if (!(_deny isEqualTo "") && {[_caller, "life_fnc_wantedBounty", _deny] call TON_fnc_denyCaller}) exitWith {};
private _query = format ["SELECT wantedID, wantedName, wantedCrimes, wantedBounty FROM wanted WHERE active='1' AND wantedID='%1'",_uid];
private _queryResult = [_query,2] call DB_fnc_asyncCall;
private "_amount";
if !(count _queryResult isEqualTo 0) then {
    _amount = _queryResult param [3];
    if (_amount isEqualType "") then {_amount = parseNumber _amount};
    //Geld-Umbau Schritt 2: der Server bucht das Kopfgeld, hoechstens einmal je Gesuchtem in CfgEconomy >> bountyCooldown
    if (!(_amount isEqualTo 0) && {ECONOMY_MODE >= 1}) then {
        private _last = [_uid, "bountyPaidAt", -1e9] call TON_fnc_serverGet;
        if ((diag_tickTime - _last) < getNumber (missionConfigFile >> "CfgEconomy" >> "bountyCooldown")) then {
            diag_log format ["[ECONOMY] bounty for %1 already paid %2 s ago, not paid again", _uid, round (diag_tickTime - _last)];
            _amount = 0;
        } else {
            [_uid, "bountyPaidAt", diag_tickTime] call TON_fnc_serverSet;
            [getPlayerUID _cop, "bank", round ([_amount, _amount / 2] select _half), ["bounty", "bounty_half"] select _half, _uid] call TON_fnc_moneyChange;
        };
    };
    if !(_amount isEqualTo 0) then {
        if (_half) then {
            [((_amount) / 2),_amount] remoteExecCall ["life_fnc_bountyReceive",(owner _cop)];
        } else {
            [_amount,_amount] remoteExecCall ["life_fnc_bountyReceive",(owner _cop)];
        };
    };
};