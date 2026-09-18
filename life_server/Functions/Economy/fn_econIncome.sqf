#include "\life_server\script_macros.hpp"
/*
    File: fn_econIncome.sqf
    Description:
    Income whose goods still come from client inventories (docs/ECONOMY_AUTHORITY.md, step 3). The
    server computes every price from the mission config, checks what it can see (shop, faction, place,
    duration) and applies the earning limits of TON_fnc_econEarnCheck. Also the fuel pump expense.
    Called through life_fnc_econRequest (request id first).
    Parameters:
        0: NUMBER - request id
        1: STRING - kind, see below
        2..: kind arguments
    Kinds:
        sellItem       [shop, item, amount]  VirtualItems >> sellPrice, item must be in the shop
        sellWeapon     [shop, class]         WeaponShops sell price (index 3)
        deliveryStart  [start object]        remembers the start of a delivery mission
        deliveryFinish [delivery point]      CfgEconomy >> deliveryPayPerMeter x distance, minimum travel time
        fuelTanker     [vehicle, litres]     price per litre by distance to the fuel storage (as the client did)
        fuelPump       [vehicle, litres]     charges Life_Settings >> fuel_cost per litre from the bank
        seize          [object, "vehicle"|"container"|"house"]  police: illegal items in the Trunk
        revive         [body]                patient pays revive_fee, EMS gets it
    Answer data on success: [amount]
*/
private _owner = CALLER_OWNER;
params [["_id", -1, [0]], ["_kind", "", [""]], ["_a", objNull], ["_b", objNull], ["_c", objNull]];
if (ECONOMY_MODE isEqualTo 0) exitWith {};
private _info = [_owner] call TON_fnc_callerInfo;
if (_info isEqualTo []) exitWith {};
_info params ["_uid", "_unit", "_side", "_name"];
private _answer = {
    params ["_ok", ["_data", []]];
    [_id, _ok, _data] remoteExecCall ["life_fnc_econReply", _owner];
};
private _deny = {
    [_owner, "TON_fnc_econIncome " + _kind, _this] call TON_fnc_denyCaller;
    [false, ["denied"]] call _answer;
};
private _pay = {
    params ["_account", "_amount", "_source", "_reason", ["_meta", ""]];
    _amount = round _amount;
    if (_amount <= 0) exitWith {false};
    if !([_uid, _source, _amount, _name] call TON_fnc_econEarnCheck) exitWith {false};
    [_uid, _account, _amount, _reason, "", _meta] call TON_fnc_moneyChange
};
private _cfg = missionConfigFile >> "CfgEconomy";

switch (_kind) do {
    case "sellItem": {
        private _shopCfg = missionConfigFile >> "VirtualShops" >> ([_a] param [0, "", [""]]);
        private _item = [_b] param [0, "", [""]];
        private _amount = round ([_c] param [0, 0, [0]]);
        private _price = getNumber (missionConfigFile >> "VirtualItems" >> _item >> "sellPrice");
        switch (true) do {
            case (!isClass _shopCfg || {!(_item in getArray (_shopCfg >> "items"))}): {format ["shop %1 does not buy %2", _a, _item] call _deny};
            case (_price < 0 || {_amount < 1} || {_amount > 10000}): {format ["invalid sale %1 x%2", _item, _amount] call _deny};
            //Inventar-Umbau Paket 2: verkauft wird nur, was der Spieler laut Serverkopie hat
            case (INVENTORY_MODE >= 1 && {([_uid, _item] call TON_fnc_invGet) < _amount}): {[false, ["items"]] call _answer};
            case (!(["cash", _price * _amount, "itemSale", "sale_item", format ["%1 %2x%3", _a, _item, _amount]] call _pay)): {[false, ["limit"]] call _answer};
            default {
                if (INVENTORY_MODE >= 1) then {[_uid, _item, -_amount, "sale_item"] call TON_fnc_invChange};
                [true, [round (_price * _amount)]] call _answer;
            };
        };
    };
    case "sellWeapon": {
        private _shopCfg = missionConfigFile >> "WeaponShops" >> ([_a] param [0, "", [""]]);
        private _class = [_b] param [0, "", [""]];
        private _price = -1;
        if (isClass _shopCfg) then {
            {
                private _entry = (getArray (_shopCfg >> _x)) select {(_x param [0, ""]) == _class};
                if !(_entry isEqualTo []) exitWith {_price = (_entry select 0) param [3, -1]};
            } forEach ["items", "mags", "accs"];
        };
        switch (true) do {
            case (_price < 0): {format ["shop %1 does not buy %2", _a, _class] call _deny};
            case (!(["cash", _price, "weaponSale", "sale_weapon", format ["%1 %2", _a, _class]] call _pay)): {[false, ["limit"]] call _answer};
            default {[true, [_price]] call _answer};
        };
    };
    case "deliveryStart": {
        if !(_a isEqualType objNull && {!isNull _a}) exitWith {[false] call _answer};
        [_uid, "delivery", [netId _a, diag_tickTime]] call TON_fnc_serverSet;
        [true] call _answer;
    };
    case "deliveryFinish": {
        private _record = [_uid, "delivery", []] call TON_fnc_serverGet;
        [_uid, "delivery"] call TON_fnc_serverSet;
        _record params [["_startId", ""], ["_started", -1e9]];
        private _start = objectFromNetId _startId;
        private _distance = if (isNull _start || {!(_a isEqualType objNull)} || {isNull _a}) then {-1} else {_start distance2D _a};
        switch (true) do {
            case (_distance < 0 || {!((str _a) in LIFE_SETTINGS(getArray,"delivery_points"))}): {[false, ["norob"]] call _answer};
            case ((_unit distance2D _a) > 40): {[false, ["distance"]] call _answer};
            case ((diag_tickTime - _started) < (_distance / 70)): {format ["delivery of %1 m finished after %2 s", round _distance, round (diag_tickTime - _started)] call _deny};
            case (!(["cash", _distance * getNumber (_cfg >> "deliveryPayPerMeter"), "delivery", "delivery", str _a] call _pay)): {[false, ["limit"]] call _answer};
            default {[true, [round (_distance * getNumber (_cfg >> "deliveryPayPerMeter"))]] call _answer};
        };
    };
    case "fuelTanker": {
        private _litres = round ([_b] param [0, 0, [0]]);
        private _shortest = 100000;
        if (_a isEqualType objNull && {!isNull _a}) then {
            {_shortest = _shortest min (_a distance (getMarkerPos _x))} forEach ["fuel_storage_1", "fuel_storage_2"];
        };
        private _price = floor ((((floor (_shortest / 100) * 100) / 1337) * LIFE_SETTINGS(getNumber,"fuelTank_winMultiplier")) * 100) / 100;
        switch (true) do {
            case (!(_a isEqualType objNull) || {isNull _a} || {!((typeOf _a) in ["C_Van_01_fuel_F","I_Truck_02_fuel_F","B_Truck_01_fuel_F"])} || {(_unit distance _a) > 25}): {"no fuel truck near the player" call _deny};
            case (_shortest < 1000 || {_litres < 1} || {_litres > 20000}): {[false, ["denied"]] call _answer};
            case (!(["cash", _price * _litres, "fuelTanker", "job_fuel_tanker", format ["%1 l", _litres]] call _pay)): {[false, ["limit"]] call _answer};
            default {[true, [floor (_price * _litres)]] call _answer};
        };
    };
    case "fuelPump": {
        private _litres = round ([_b] param [0, 0, [0]]);
        private _cost = _litres * LIFE_SETTINGS(getNumber,"fuel_cost");
        switch (true) do {
            case (!(_a isEqualType objNull) || {isNull _a} || {(_unit distance _a) > 20} || {_litres < 0} || {_litres > 1000}): {"invalid refuel" call _deny};
            case (_cost > 0 && {!([_uid, "bank", -_cost, "fee_fuel", "", typeOf _a] call TON_fnc_moneyChange)}): {[false, ["money", _cost]] call _answer};
            default {[true, [_cost]] call _answer};
        };
    };
    case "seize": {
        private _mode = [_b] param [0, "", [""]];
        if (!(_side isEqualTo west) || {!(_a isEqualType objNull)} || {isNull _a} || {(_unit distance _a) > 20} || {!(_mode in ["vehicle", "container", "house"])}) exitWith {"seizure not allowed" call _deny};
        private _trunk = if (INVENTORY_MODE >= 1) then {[_a] call TON_fnc_trunkGet} else {_a getVariable ["Trunk", [[], 0]]};
        _trunk params [["_items", [], [[]]], ["_weight", 0, [0]]];
        private _value = 0;
        private _keep = [];
        {
            _x params [["_var", ""], ["_val", 0]];
            private _itemCfg = missionConfigFile >> "VirtualItems" >> _var;
            if ((getNumber (_itemCfg >> "illegal")) isEqualTo 1) then {
                if (_mode isEqualTo "house") then {
                    private _price = getNumber (_itemCfg >> "sellPrice");
                    if (_price isEqualTo -1) then {_keep pushBack _x} else {
                        _value = _value + (_val * _price);
                        _weight = _weight - ((getNumber (_itemCfg >> "weight")) * _val);
                    };
                } else {
                    private _processed = getText (_itemCfg >> "processedItem");
                    private _price = if (_processed isEqualTo "") then {getNumber (_itemCfg >> "sellPrice")} else {getNumber (missionConfigFile >> "VirtualItems" >> _processed >> "sellPrice")};
                    _value = _value + round (_val * _price / 2);
                };
            } else {
                _keep pushBack _x;
            };
        } forEach _items;
        if (_value <= 0) exitWith {[false, ["empty"]] call _answer};
        private _payout = [_value, round (_value / 2)] select (_mode isEqualTo "house");
        if (INVENTORY_MODE >= 1) then {
            [_a, [_keep, []] select (!(_mode isEqualTo "house"))] call TON_fnc_trunkSet;
        } else {
            if (_mode isEqualTo "house") then {
                _a setVariable ["Trunk", [_keep, _weight max 0], true];
            } else {
                _a setVariable ["Trunk", [[], 0], true];
            };
        };
        if (_mode in ["container", "house"]) then {[_a] spawn TON_fnc_updateHouseTrunk};
        private _key = switch (_mode) do {case "vehicle": {"STR_NOTF_VehContraband"}; case "container": {"STR_NOTF_ContainerContraband"}; default {"STR_House_Raid_Successful"}};
        [0, _key, true, [[_value] call life_fnc_numberText]] remoteExecCall ["life_fnc_broadcast", -2];
        if !(["bank", _payout, "police", "seize_" + _mode, typeOf _a] call _pay) exitWith {[false, ["limit"]] call _answer};
        [true, [_payout]] call _answer;
    };
    case "revive": {
        private _fee = LIFE_SETTINGS(getNumber,"revive_fee");
        if (!(_a isEqualType objNull) || {isNull _a} || {!(_a isKindOf "CAManBase")} || {alive _a} || {(_unit distance _a) > 15}) exitWith {"invalid revive target" call _deny};
        if ([_a, "revivePaid", false] call TON_fnc_serverGet) exitWith {[false, ["denied"]] call _answer};
        [_a, "revivePaid", true] call TON_fnc_serverSet;
        //Patient: owner of this body according to the death records
        private _patientUid = "";
        {
            if (((_y param [1, objNull]) isEqualTo _a)) exitWith {_patientUid = ([_x] call TON_fnc_callerInfo) param [0, ""]};
        } forEach (localNamespace getVariable ["life_relay_deaths", createHashMap]);
        if !(_patientUid isEqualTo "") then {
            private _bank = ((localNamespace getVariable ["life_econ_wallets", createHashMap]) getOrDefault [_patientUid, [0, 0]]) select 1;
            private _charge = _fee min _bank;
            if (_charge > 0) then {[_patientUid, "bank", -_charge, "revive_fee", _uid] call TON_fnc_moneyChange};
        };
        if (_side isEqualTo independent) then {
            ["bank", _fee, "medic", "revive_payout", _patientUid] call _pay;
        };
        [true, [_fee]] call _answer;
    };
    default {format ["unknown income %1", _kind] call _deny};
};
