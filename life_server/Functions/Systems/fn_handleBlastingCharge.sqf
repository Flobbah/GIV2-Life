#include "\life_server\script_macros.hpp"
/*
    Author: GetSomePanda / Panda
    File Name: fn_handleBlastingCharge.sqf
    Information: Handles the federal reserve explosion on the server, so it still goes off when the
    player who placed the charge logs out.
    Sicherheitsphase 0.2 Welle 2 (Audit #7): Frueher setzte der Client die oeffentliche Objektvariable
    "chargeplaced" selbst und der Server glaubte sie - damit liess sich der Tresor ohne Ladung oeffnen.
    Der Server entscheidet jetzt, ob eine Ladung liegt (Serverspeicher "fedCharge"), und meldet sich
    ueber life_fnc_econReply zurueck; am Objekt steht nur noch die Anzeige fuer den Countdown.
    Parameters:
        0: NUMBER - request id
*/
private _owner = CALLER_OWNER;
params [["_id", -1, [0]]];
private _info = [_owner] call TON_fnc_callerInfo;
if (_info isEqualTo []) exitWith {};
_info params ["_uid", "_unit", "_side", "_name"];
private _answer = {
    params ["_ok", ["_data", []]];
    [_id, _ok, _data] remoteExecCall ["life_fnc_econReply", _owner];
};
private _deny = {
    [_owner, "TON_fnc_handleBlastingCharge", _this] call TON_fnc_denyCaller;
    [false, ["denied"]] call _answer;
};
private _cops = {(AUTH_SIDE(getPlayerUID _x)) isEqualTo west} count allPlayers;
switch (true) do {
    case (isNil "fed_bank" || {isNull fed_bank}): {[false, ["denied"]] call _answer};
    case (!(_side isEqualTo civilian)): {"only civilians place a charge" call _deny};
    case ((_unit distance fed_bank) > 30): {"sender too far from the vault" call _deny};
    case (["server", "fedOpen", false] call TON_fnc_serverGet): {[false, ["open"]] call _answer};
    case (["server", "fedCharge", false] call TON_fnc_serverGet): {[false, ["placed"]] call _answer};
    case (_cops < (LIFE_SETTINGS(getNumber,"minimum_cops"))): {[false, ["cops"]] call _answer};
    default {
        //Inventar-Umbau: die Ladung nimmt der Server aus dem Inventar, wenn er sie annimmt
        if (INVENTORY_MODE >= 1 && {!([_uid, "blastingcharge", -1, "blasting_charge"] call TON_fnc_invChange)}) exitWith {[false, ["items"]] call _answer};
        ["server", "fedCharge", true] call TON_fnc_serverSet;
        fed_bank setVariable ["chargeplaced", true, true];
        diag_log format ["[VAULT] %1 (%2) placed a blasting charge, %3 police online", _name, _uid, _cops];
        [true] call _answer;
        [0, "STR_ISTR_Blast_Placed", true, []] remoteExecCall ["life_fnc_broadcast", west];
        [] remoteExec ["life_fnc_demoChargeTimer", west];
        [] remoteExec ["life_fnc_demoChargeTimer", _owner];
        [] spawn {
            uiSleep (5 * 60);
            if (!(["server", "fedCharge", false] call TON_fnc_serverGet)) exitWith {};
            "Bo_GBU12_LGB_MI10" createVehicle [getPosATL fed_bank select 0, getPosATL fed_bank select 1, (getPosATL fed_bank select 2) + 0.5];
            ["server", "fedCharge", false] call TON_fnc_serverSet;
            ["server", "fedOpen", true] call TON_fnc_serverSet;
            fed_bank setVariable ["chargeplaced", false, true];
            fed_bank setVariable ["safe_open", true, true];
        };
    };
};
