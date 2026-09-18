#include "\life_server\script_macros.hpp"
/*
    File: fn_invInit.sqf
    Description:
    Starts the server-side copy of the virtual inventories (docs/INVENTORY_AUTHORITY.md, package 1).
    Mode from CfgServer >> InventoryMode: 0 = off, 1 = shadow mode (the server follows what the
    clients report and logs what does not add up), 2 = the server decides (later package).
*/
private _mode = INVENTORY_MODE;
localNamespace setVariable ["life_inv_store", createHashMap];
if (_mode isEqualTo 0) exitWith {
    diag_log "[INVENTORY] InventoryMode 0: server-side inventory is off";
};
[] spawn TON_fnc_invSync;
diag_log format ["[INVENTORY] %1 active, full compare every %2 s",
    ["shadow mode", "enforce mode"] select (_mode >= 2),
    getNumber (missionConfigFile >> "CfgInventory" >> "syncInterval")];
