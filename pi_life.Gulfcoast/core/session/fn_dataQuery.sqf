#include "..\..\script_macros.hpp"
/*
    File: fn_dataQuery.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Starts the 'authentication' process and sends a request out to
    the server to check for player information.
*/
SERVER_ONLY_REMOTE; //Sicherheitsphase 0.1: nur der Server darf diese Funktion remote aufrufen
private ["_uid","_side","_sender"];
if (life_session_completed) exitWith {}; //Why did this get executed when the client already initialized? Fucking arma...
_sender = player;
_uid = getPlayerUID _sender;
_side = life_side;
cutText[format [localize "STR_Session_Query",_uid],"BLACK FADED"];
0 cutFadeOut 999999999;
if (LIFE_HC_ACTIVE) then {
    [_uid,_side,_sender] remoteExec ["HC_fnc_queryRequest",HC_Life];
} else {
    [_uid,_side,_sender] remoteExec ["DB_fnc_queryRequest",RSERV];
};
