#include "\life_server\script_macros.hpp"
/*
    File: fn_updateGang.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Updates the gang information?
*/
private ["_groupID","_bank","_maxMembers","_members","_membersFinal","_query","_owner"];
params [
    ["_mode",0,[0]],
    ["_group",grpNull,[grpNull]]
];
if (isNull _group) exitWith {}; //FAIL
_groupID = _group getVariable ["gang_id",-1];
if (!(_groupID isEqualType 0) || {_groupID isEqualTo -1}) exitWith {}; //Sicherheitsphase 0.2: gang_id kann jeder Client setzen, nur Zahlen (SQL)
//Sicherheitsphase 0.1: nur Mitglieder der Gang (Mitgliederliste locker, weil Verlassen und Beitreten
//sich mit dem Gruppenwechsel ueberschneiden); Gangkasse nur fuer die eigene Einheit
private _caller = CALLER_OWNER;
private _deny = "";
if !(_caller isEqualTo 2) then {
    private _info = [_caller] call TON_fnc_callerInfo;
    if (_info isEqualTo []) then {_deny = "unknown sender";} else {
        private _senderUnit = _info select 1;
        if (!(_mode isEqualTo 4) && {!(_senderUnit in (units _group))}) then {_deny = format ["sender is not a member of the gang (mode %1)", _mode];};
        private _bankUnit = _this param [4, objNull];
        if (_deny isEqualTo "" && {_mode isEqualTo 1} && {_bankUnit isEqualType objNull} && {!isNull _bankUnit} && {!(_bankUnit isEqualTo _senderUnit)}) then {_deny = "gang bank request for another unit";};
        //Sicherheitsphase 0.2: Besitzer und Besitzerwechsel nur fuer den Besitzer laut Datenbank (gang_owner am Objekt ist faelschbar)
        if (_deny isEqualTo "" && {_mode in [0, 3]} && {([format ["SELECT id FROM gangs WHERE id='%1' AND owner='%2' AND active='1'", _groupID, _info select 0], 2] call DB_fnc_asyncCall) isEqualTo []}) then {_deny = format ["sender is not the gang owner in the database (mode %1)", _mode];};
    };
};
if (!(_deny isEqualTo "") && {[_caller, "TON_fnc_updateGang", _deny] call TON_fnc_denyCaller}) exitWith {};
//Geld-Umbau Schritt 2: ab Modus 1 fuehrt der Server die Gangkasse (TON_fnc_gangMoney); Modus 1 hier nur noch fuer den Server selbst
if (ECONOMY_MODE >= 1 && {_mode isEqualTo 1} && {!(_caller isEqualTo 2)}) exitWith {
    [_caller, "TON_fnc_updateGang", "gang bank via updateGang is replaced by TON_fnc_econBank"] call TON_fnc_denyCaller;
};
switch (_mode) do {
    case 0: {
        _bank = [([_group getVariable ["gang_bank",0]] param [0, 0, [0]])] call DB_fnc_numberSafe; //Sicherheitsphase 0.2: nur Zahlen/UIDs in SQL
        _maxMembers = [_group getVariable ["gang_maxMembers",8]] param [0, 8, [0]];
        _members = [(_group getVariable "gang_members")] call DB_fnc_mresArray;
        _owner = [_group getVariable ["gang_owner",""]] param [0, "", [""]];
        if !(_owner regexMatch "\d{17}") exitWith {};
        _query = if (ECONOMY_MODE >= 1) then {
            format ["UPDATE gangs SET maxmembers='%1', owner='%2' WHERE id='%3'",_maxMembers,_owner,_groupID] //Kasse nicht aus der Gruppen-Variable
        } else {
            format ["UPDATE gangs SET bank='%1', maxmembers='%2', owner='%3' WHERE id='%4'",_bank,_maxMembers,_owner,_groupID]
        };
    };
    case 1: {
        params [
            "",
            "",
            ["_deposit",false,[false]],
            ["_value",0,[0]],
            ["_unit",objNull,[objNull]],
            ["_cash",0,[0]]
        ];
        private _funds = [_group getVariable ["gang_bank",0]] param [0, 0, [0]];
        if (_deposit) then {
            _funds = _funds + _value;
            _group setVariable ["gang_bank",_funds,true];
            [1,"STR_ATM_DepositSuccessG",true,[_value]] remoteExecCall ["life_fnc_broadcast",remoteExecutedOwner];
            _cash = _cash - _value;
        } else {
            if (_value > _funds) exitWith {
                [1,"STR_ATM_NotEnoughFundsG",true] remoteExecCall ["life_fnc_broadcast",remoteExecutedOwner];
                breakOut "";
            };
            _funds = _funds - _value;
            _group setVariable ["gang_bank",_funds,true];
            [_value] remoteExecCall ["life_fnc_gangBankResponse",remoteExecutedOwner];
            _cash = _cash + _value;
        };
        if (LIFE_SETTINGS(getNumber,"player_moneyLog") isEqualTo 1) then {
            if (LIFE_SETTINGS(getNumber,"battlEye_friendlyLogging") isEqualTo 1) then {
                diag_log (format [localize "STR_DL_ML_withdrewGang_BEF",_value,[_funds] call life_fnc_numberText,[0] call life_fnc_numberText,[_cash] call life_fnc_numberText]);
            } else {
                diag_log (format [localize "STR_DL_ML_withdrewGang",name _unit,(getPlayerUID _unit),_value,[_funds] call life_fnc_numberText,[0] call life_fnc_numberText,[_cash] call life_fnc_numberText]);
            };
        };
        _query = format ["UPDATE gangs SET bank='%1' WHERE id='%2'",([_funds] call DB_fnc_numberSafe),_groupID];
        [getPlayerUID _unit,AUTH_SIDE(getPlayerUID _unit),_cash,0] call DB_fnc_updatePartial;
    };
    case 2: {
        if (ECONOMY_MODE >= 1 && {!(_caller isEqualTo 2)}) then {
            //Geld-Umbau Schritt 2: Plaetze aus der Datenbank +4, Preis wie im Client, gebucht beim Absender
            private _old = ([format ["SELECT maxmembers FROM gangs WHERE id='%1'", _groupID], 2] call DB_fnc_asyncCall) param [0, 8];
            if (_old isEqualType "") then {_old = parseNumber _old};
            private _new = _old + 4;
            private _price = round (_new * LIFE_SETTINGS(getNumber,"gang_upgradeBase") / LIFE_SETTINGS(getNumber,"gang_upgradeMultiplier"));
            private _payer = ([_caller] call TON_fnc_callerInfo) param [0, ""];
            if ([_payer, "bank", -_price, "gang_upgrade", str _groupID] call TON_fnc_moneyChange) then {
                _group setVariable ["gang_maxMembers", _new, true];
                _query = format ["UPDATE gangs SET maxmembers='%1' WHERE id='%2'", _new, _groupID];
                ["STR_GNOTF_UpgradeSuccess", [_old, _new, [_price] call life_fnc_numberText], false, true] remoteExecCall ["life_fnc_econResult", _caller];
            } else {
                ["STR_GNOTF_NotEnoughMoney", [[_price] call life_fnc_numberText], true] remoteExecCall ["life_fnc_econResult", _caller];
            };
        } else {
            _query = format ["UPDATE gangs SET maxmembers='%1' WHERE id='%2'",([_group getVariable ["gang_maxMembers",8]] param [0, 8, [0]]),_groupID];
        };
    };
    case 3: {
        _owner = [_group getVariable ["gang_owner",""]] param [0, "", [""]];
        if !(_owner regexMatch "\d{17}") exitWith {};
        _query = format ["UPDATE gangs SET owner='%1' WHERE id='%2'",_owner,_groupID];
    };
    case 4: {
        _members = ([_group getVariable "gang_members"] param [0, [], [[]]]) select {_x isEqualType "" && {_x regexMatch "\d{17}"}};
        _maxMembers = [_group getVariable ["gang_maxMembers",8]] param [0, 8, [0]];
        //Sicherheitsphase 0.2 Welle 2: die Mitgliederliste ist eine Gruppenvariable, die jeder Client setzen
        //kann. Der Server geht deshalb vom Stand der Datenbank aus und uebernimmt nur, was der Absender
        //selbst darf: sich eintragen oder austragen, als Besitzer laut Datenbank Mitglieder entfernen.
        //Alles andere wird still zurechtgerueckt (eine offene Einladung steht schon in der Gruppenvariable,
        //ein Ablehnen waere also die falsche Antwort) und als [SECURITY] gemeldet.
        if !(_caller isEqualTo 2) then {
            private _senderUid = ([_caller] call TON_fnc_callerInfo) param [0, ""];
            private _raw = ([format ["SELECT members FROM gangs WHERE id='%1' AND active='1'", _groupID], 2] call DB_fnc_asyncCall) param [0, ""];
            if !(_raw isEqualType "") then {_raw = str _raw};
            private _old = ((_raw regexReplace ["[^0-9]", " "]) splitString " ") select {_x regexMatch "\d{17}"};
            private _final = +_old;
            if (_senderUid in _members && {!(_senderUid in _final)}) then {_final pushBack _senderUid};
            if (!(_senderUid in _members) && {_senderUid in _final}) then {_final deleteAt (_final find _senderUid)};
            if (!(([format ["SELECT id FROM gangs WHERE id='%1' AND owner='%2' AND active='1'", _groupID, _senderUid], 2] call DB_fnc_asyncCall) isEqualTo [])) then {
                {if (!(_x in _members)) then {_final deleteAt (_final find _x)}} forEach (+_old);
            };
            if (!((_members - _final) isEqualTo []) || {!((_final - _members) isEqualTo [])}) then {
                [_caller, "TON_fnc_updateGang", format ["member list corrected: client sent %1 names, allowed are %2", count _members, count _final]] call TON_fnc_denyCaller;
            };
            _members = _final;
            _group setVariable ["gang_members", _members, true];
        };
        if (count _members > _maxMembers) then {
            _membersFinal = [];
            for "_i" from 0 to _maxMembers -1 do {
                _membersFinal pushBack (_members select _i);
            };
        } else {
            _membersFinal = _members;
        };
        _membersFinal = [_membersFinal] call DB_fnc_mresArray;
        _query = format ["UPDATE gangs SET members='%1' WHERE id='%2'",_membersFinal,_groupID];
    };
};
if (!isNil "_query") then {
    [_query,1] call DB_fnc_asyncCall;
};
