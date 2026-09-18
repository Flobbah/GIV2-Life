/*
    File: fn_packupSpikes.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Packs up a deployed spike strip.
*/
private ["_spikes"];
_spikes = nearestObjects[getPos player,["Land_Razorwire_F"],8] select 0;
if (isNil "_spikes") exitWith {};
//Inventar-Umbau: der Server prueft das Objekt, bucht den Krähenfuß und loescht ihn
if (INVENTORY_MODE >= 1) exitWith {
    ["TON_fnc_invHarvest", [_spikes], {
        titleText[localize "STR_NOTF_SpikeStrip","PLAIN"];
        player removeAction life_action_spikeStripPickup;
        life_action_spikeStripPickup = nil;
    }, {}] call life_fnc_econRequest;
};
if ([true,"spikeStrip",1] call life_fnc_handleInv) then {
    titleText[localize "STR_NOTF_SpikeStrip","PLAIN"];
    player removeAction life_action_spikeStripPickup;
    life_action_spikeStripPickup = nil;
    deleteVehicle _spikes;
};