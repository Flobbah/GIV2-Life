/*
    File: fn_federalUpdate.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Uhhh, adds to it?
*/
private "_funds";
for "_i" from 0 to 1 step 0 do {
    uiSleep (30 * 60);
    //Sicherheitsphase 0.2 Welle 2: Bestand aus dem Serverspeicher, am Objekt steht nur die Anzeige
    _funds = round ((["server", "fedSafe", 0] call TON_fnc_serverGet) + ((count playableUnits) / 2));
    ["server", "fedSafe", _funds] call TON_fnc_serverSet;
    fed_bank setVariable ["safe",_funds,true];
};
