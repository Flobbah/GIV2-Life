/*
    File: map_filter.hpp
    Description:
    Telefon-App "Karte" (idd 2950): Karten-Marker nach Kategorie ein-/ausblenden.
    Acht Zeilen (Label 2971-2978, Checkbox 2951-2958, Zeilenhintergrund 2981-2988),
    Buttons 2961 (alle anzeigen) und 2962 (alle ausblenden).
    Hinweis: Der Arma-Praeprozessor ersetzt Makro-Parameter nicht innerhalb von Anfuehrungszeichen,
    deshalb uebergibt onCheckedChanged das Steuerelement und das Skript leitet die Zeile aus der IDC ab.
    Logik: core\pmenu\fn_markerFilterMenu.sqf, fn_markerFilterToggle.sqf, fn_markerFilterApply.sqf
*/
#define MF_ROW(IDX,Y) \
    class MfRow##IDX : Life_RscPhoneCard { idc = 2981 + IDX; y = PH_Y(Y); h = PH_H(1.15); }; \
    class MfLabel##IDX : Life_RscPhoneLabel { idc = 2971 + IDX; text = ""; x = PH_X(0.9); y = PH_Y(Y); w = PH_W(7.6); h = PH_H(1.15); colorText[] = {0.95,0.95,0.95,1}; }; \
    class MfCheck##IDX : Life_Checkbox { idc = 2951 + IDX; onCheckedChanged = "[_this select 0,_this select 1] call life_fnc_markerFilterToggle;"; x = PH_X(8.7); y = PH_Y(Y + 0.12); w = PH_W(0.9); h = PH_H(0.9); };
class Life_Map_Filter {
    idd = 2950;
    name = "life_map_filter";
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "[_this select 0] call life_fnc_phoneStatus; [] spawn life_fnc_markerFilterMenu;";
    class controlsBackground {
        PHONE_FRAME
    };
    class controls {

        PHONE_APPBAR(-1,"$STR_MF_Title","closeDialog 0;")
        MF_ROW(0,2.8)
        MF_ROW(1,4.1)
        MF_ROW(2,5.4)
        MF_ROW(3,6.7)
        MF_ROW(4,8.0)
        MF_ROW(5,9.3)
        MF_ROW(6,10.6)
        MF_ROW(7,11.9)
        class MfShowAll : Life_RscPhoneButton {
            idc = 2961;
            text = "$STR_MF_ShowAll";
            x = PH_X(0.6);
            y = PH_Y(13.6);
            w = PH_W(4.5);
            onButtonClick = "[-1,true] call life_fnc_markerFilterToggle;";
        };
        class MfHideAll : Life_RscPhoneButtonAlt {
            idc = 2962;
            text = "$STR_MF_HideAll";
            x = PH_X(5.4);
            y = PH_Y(13.6);
            w = PH_W(4.5);
            onButtonClick = "[-1,false] call life_fnc_markerFilterToggle;";
        };
        class MfHint : Life_RscPhoneStructured {
            idc = -1;
            text = "$STR_MF_Hint";
            y = PH_Y(15.2);
            h = PH_H(2.5);
            size = PH_FONT(0.75);
        };
        /* Leiste zuletzt, damit sie ueber den Inhalten liegt und Klicks bekommt */
        PHONE_NAVBAR
    };
};
#undef MF_ROW
