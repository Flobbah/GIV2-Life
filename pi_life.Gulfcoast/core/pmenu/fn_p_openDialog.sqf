#include "..\..\script_macros.hpp"
/*
    File: fn_p_openDialog.sqf
    Description:
    Oeffnet eine App des Telefons anhand ihres Dialognamens. Wird von life_fnc_p_openApp (Kachel
    auf der Startseite) und life_fnc_p_back (eine Ebene zurueck) benutzt.

    Warum der Umweg ueber eine Liste statt "createDialog _name":
    Der BattlEye-Filter (scripts.txt, Regel "createDialog") kickt jeden Aufruf, in dessen
    ausgefuehrtem Code keiner der erlaubten Dialognamen woertlich steht. Mit einer Variablen als
    Namen stuende dort nichts - deshalb steht hier jede App einzeln. Nebenbei ist das eine
    Positivliste: ueber das Telefon laesst sich nichts anderes oeffnen.

    Parameter:
        0: STRING - Klassenname des Dialogs
    Rueckgabe:
        BOOL - true, wenn der Dialog geoeffnet wurde
*/
params [["_class","",[""]]];
switch (toLower _class) do {
    case "life_key_management": {createDialog "Life_key_management"; true};
    case "life_cell_phone": {createDialog "Life_cell_phone"; true};
    case "life_map_filter": {createDialog "Life_Map_Filter"; true};
    case "life_navigation": {createDialog "Life_Navigation"; true};
    case "life_skills": {createDialog "Life_Skills"; true};
    case "life_duty": {createDialog "Life_Duty"; true};
    case "playersettings": {createDialog "playerSettings"; true};
    default {
        diag_log format ["[PHONE] Unbekannte App: %1",_class];
        false
    };
};
