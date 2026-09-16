#include "\life_server\script_macros.hpp"
/*
    File: fn_econShop.sqf
    Description:
    Shop purchases paid in cash (docs/ECONOMY_AUTHORITY.md, step 2 package 3b). The client names the
    shop and what it wants; the server takes the price from the mission config, checks that the
    shop sells it and belongs to the player's faction, and charges the cash. The client hands out
    the goods after the answer (life_fnc_econRequest / life_fnc_econReply).
    Parameters:
        0: NUMBER - request id from life_fnc_econRequest
        1: STRING - "virtual", "weapon" or "clothing"
        2: STRING - shop class (VirtualShops, WeaponShops or Clothing)
        3: ANY    - virtual: item class; weapon: item class; clothing: ARRAY of 5 BOOL, one per slot
                    (uniform, headgear, goggles, vest, backpack) that is bought
        4: NUMBER - virtual: amount
    Clothing is priced by what the player wears when buying (the shop preview puts it on).
*/
private _owner = CALLER_OWNER;
params [["_id", -1, [0]], ["_kind", "", [""]], ["_shop", "", [""]], ["_item", "", ["", []]], ["_amount", 1, [0]], ["_gangFunds", false, [false]]];
if (ECONOMY_MODE isEqualTo 0) exitWith {};
private _info = [_owner] call TON_fnc_callerInfo;
if (_info isEqualTo []) exitWith {};
_info params ["_uid", "_unit", "_side"];
private _answer = {
    params ["_ok", ["_data", []]];
    [_id, _ok, _data] remoteExecCall ["life_fnc_econReply", _owner];
};
private _sideFlag = switch (_side) do {case west: {"cop"}; case independent: {"med"}; default {"civ"}};
private _price = -1;
private _meta = "";
private _deny = "";

switch (_kind) do {
    case "virtual": {
        private _cfg = missionConfigFile >> "VirtualShops" >> _shop;
        _amount = round _amount;
        switch (true) do {
            case (!isClass _cfg): {_deny = "unknown virtual shop"};
            case (!((getText (_cfg >> "side")) in ["", _sideFlag])): {_deny = format ["shop %1 is not for side %2", _shop, _side]};
            case (!(_item isEqualType "") || {!(_item in getArray (_cfg >> "items"))}): {_deny = format ["shop %1 does not sell %2", _shop, _item]};
            case (_amount < 1 || {_amount > 1000}): {_deny = format ["invalid amount %1", _amount]};
        };
        if !(_deny isEqualTo "") exitWith {};
        private _unitPrice = getNumber (missionConfigFile >> "VirtualItems" >> _item >> "buyPrice");
        if (_unitPrice < 0) exitWith {_deny = format ["%1 cannot be bought", _item]};
        _price = _unitPrice * _amount;
        _meta = format ["%1 %2x%3", _shop, _item, _amount];
    };
    case "weapon": {
        private _cfg = missionConfigFile >> "WeaponShops" >> _shop;
        if (!isClass _cfg) exitWith {_deny = "unknown weapon shop"};
        if !((getText (_cfg >> "side")) in ["", _sideFlag]) exitWith {_deny = format ["shop %1 is not for side %2", _shop, _side]};
        if !(_item isEqualType "") exitWith {_deny = "invalid item"};
        {
            private _entry = (getArray (_cfg >> _x)) select {(_x param [0, ""]) == _item};
            if !(_entry isEqualTo []) exitWith {_price = (_entry select 0) param [2, -1]};
        } forEach ["items", "mags", "accs"];
        if (_price < 0) exitWith {_deny = format ["shop %1 does not sell %2", _shop, _item]};
        _meta = format ["%1 %2", _shop, _item];
    };
    case "clothing": {
        private _cfg = missionConfigFile >> "Clothing" >> _shop;
        if (!isClass _cfg) exitWith {_deny = "unknown clothing shop"};
        if !((getText (_cfg >> "side")) in ["", _sideFlag]) exitWith {_deny = format ["shop %1 is not for side %2", _shop, _side]};
        if (!(_item isEqualType []) || {count _item < 5}) exitWith {_deny = "invalid slots"};
        _price = 0;
        private _worn = [uniform _unit, headgear _unit, goggles _unit, vest _unit, backpack _unit];
        {
            if ((_item select _forEachIndex) isEqualTo true) then {
                private _class = _worn select _forEachIndex;
                if (_class isEqualTo "") then {_class = "NONE"};
                private _entry = (getArray (_cfg >> _x)) select {(_x param [0, ""]) == _class};
                if (_entry isEqualTo []) exitWith {_deny = format ["shop %1 does not sell %2", _shop, _class]};
                _price = _price + ((_entry select 0) param [2, 0]);
                _meta = _meta + _class + " ";
            };
        } forEach ["uniforms", "headgear", "goggles", "vests", "backpacks"];
    };
    case "vehicle": {
        //_item = vehicle class, _amount: 1 = rent, 0 = buy. A bought vehicle may then be registered once (TON_fnc_vehicleCreate)
        private _cfg = missionConfigFile >> "CarShops" >> _shop;
        if (!isClass _cfg) exitWith {_deny = "unknown vehicle shop"};
        if !((getText (_cfg >> "side")) in ["", _sideFlag]) exitWith {_deny = format ["shop %1 is not for side %2", _shop, _side]};
        if (!(_item isEqualType "") || {((getArray (_cfg >> "vehicles")) findIf {(_x param [0, ""]) == _item}) isEqualTo -1}) exitWith {
            _deny = format ["shop %1 does not sell %2", _shop, _item];
        };
        private _rent = _amount isEqualTo 1;
        _price = [_item, _side, ["buy", "rent"] select _rent] call TON_fnc_econVehiclePrice;
        if (_price < 0) exitWith {_deny = format ["%1 cannot be bought by side %2", _item, _side]};
        _meta = format ["%1 %2 %3", _shop, _item, ["buy", "rent"] select _rent];
    };
    default {_deny = format ["unknown purchase %1", _kind]};
};

if !(_deny isEqualTo "") exitWith {
    [_owner, "TON_fnc_econShop " + _kind, _deny] call TON_fnc_denyCaller;
    [false, ["denied"]] call _answer;
};
if (_gangFunds) exitWith {
    //Gangkasse (Paket 4): nur Mitglieder laut Datenbank, nur an einem Gang-Versteck, nur virtuelle Gegenstaende und Waffen
    private _hideoutClasses = [[["Gulfcoast", ["Land_u_Barracks_V2_F","Land_i_Barracks_V2_F"]], ["Tanoa", ["Land_School_01_F","Land_Warehouse_03_F","Land_House_Small_02_F"]]]] call TON_fnc_terrainSort;
    private _gangId = [_uid, _unit] call TON_fnc_gangMemberId;
    switch (true) do {
        case !(_kind in ["virtual", "weapon"]): {[_owner, "TON_fnc_econShop " + _kind, "gang funds not allowed for this purchase"] call TON_fnc_denyCaller; [false, ["denied"]] call _answer};
        case (_gangId < 0): {[false, ["denied"]] call _answer};
        case ((nearestObjects [_unit, _hideoutClasses, 30]) isEqualTo []): {[_owner, "TON_fnc_econShop " + _kind, "gang purchase away from a hideout"] call TON_fnc_denyCaller; [false, ["denied"]] call _answer};
        case (_price > 0 && {!([_gangId, -_price, "gang_shop_" + _kind, _uid, _meta] call TON_fnc_gangMoney)}): {[false, ["money", _price]] call _answer};
        default {[true, [_price]] call _answer};
    };
};
if (_price > 0 && {!([_uid, "cash", -_price, "shop_" + _kind, "", _meta] call TON_fnc_moneyChange)}) exitWith {
    [false, ["money", _price]] call _answer;
};
if (_kind isEqualTo "vehicle" && {!(_amount isEqualTo 1)}) then {
    private _paid = [_uid, "vehiclesPaid", []] call TON_fnc_serverGet;
    _paid pushBack [_item, diag_tickTime];
    [_uid, "vehiclesPaid", _paid] call TON_fnc_serverSet;
};
[true, [_price]] call _answer;
