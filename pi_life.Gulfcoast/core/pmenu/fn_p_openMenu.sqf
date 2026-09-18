#include "..\..\script_macros.hpp"
/*
    File: fn_p_openMenu.sqf
    Author: Bryan "Tonic" Boardwine
    Edit: Telefon-Layout - Startseite mit App-Kacheln, Seiten ueber life_fnc_p_showPage
    Description:
    Opens the players virtual inventory menu
*/
if (!alive player || dialog) exitWith {}; //Prevent them from opening this for exploits while dead.
missionNamespace setVariable ["life_phone_stack", []]; //Telefon-Verlauf beginnt neu
missionNamespace setVariable ["life_phone_dialog", ""];
createDialog "playerSettings";
disableSerialization;
life_pmenu_page = "home";
["home"] call life_fnc_p_showPage;
[] call life_fnc_p_updateMenu;
