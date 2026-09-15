#include "..\..\script_macros.hpp"
/*
    File: fn_p_openMenu.sqf
    Author: Bryan "Tonic" Boardwine
    Edit: Telefon-Layout - Startseite mit App-Kacheln, Seiten ueber life_fnc_p_showPage
    Description:
    Opens the players virtual inventory menu
*/
if (!alive player || dialog) exitWith {}; //Prevent them from opening this for exploits while dead.
createDialog "playerSettings";
disableSerialization;
life_pmenu_page = "home";
["home"] call life_fnc_p_showPage;
[] call life_fnc_p_updateMenu;
[findDisplay 2001] call life_fnc_phoneStatus;
