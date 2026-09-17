#include "..\script_macros.hpp"
/*
    File: fn_initCiv.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Initializes the civilian.
*/
waitUntil {!(isNull (findDisplay 46))};
if (life_is_alive && !life_is_arrested) then {
    /* Spawn at our last position */
    player setVehiclePosition [life_civ_position, [], 0, "CAN_COLLIDE"];
} else {
    if (!life_is_alive && !life_is_arrested) then {
        if (LIFE_SETTINGS(getNumber,"save_civilian_positionStrict") isEqualTo 1) then {
            [] call life_fnc_startLoadout;
            if (ECONOMY_MODE >= 1) then {["forfeit"] remoteExecCall ["TON_fnc_econCash",RSERV]}; //Geld-Umbau: Bargeld verfaellt auf dem Server
            CASH = 0;
            [0] call SOCK_fnc_updatePartial;
        };
        [] call life_fnc_spawnMenu;
        waitUntil{!isNull (findDisplay 38500)}; //Wait for the spawn selection to be open.
        waitUntil{isNull (findDisplay 38500)}; //Wait for the spawn selection to be done.
    } else {
        if (life_is_arrested) then {
            life_is_arrested = false;
            [player,true] spawn life_fnc_jail;
        };
    };
};
life_is_alive = true;