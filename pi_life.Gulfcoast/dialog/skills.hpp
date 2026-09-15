/*
    File: skills.hpp
    Description:
    Telefon-App "Skills" (idd 2980): fuenf Zeilen mit Karte (2981+), Name (2986+), Bonus (2991+),
    Erfahrung (2996+), Fortschrittsbalken (3001+) und Stufe (3006+).
    Logik: core\skills\fn_skillsMenu.sqf
*/
class Life_RscPhoneProgress : Life_RscProgress {
    texture = "\A3\ui_f\data\GUI\RscCommon\RscProgress\progressbar_ca.paa";
    colorFrame[] = {0, 0, 0, 0};
    colorBackground[] = {0.08, 0.09, 0.11, 1};
    colorBar[] = {0.24, 0.52, 0.88, 1};
    shadow = 0;
};
#define SK_ROW(IDX,Y) \
    class SkCard##IDX : Life_RscPhoneCard { idc = 2981 + IDX; y = PH_Y(Y); h = PH_H(3.0); }; \
    class SkTitle##IDX : Life_RscText { idc = 2986 + IDX; text = ""; x = PH_X(0.9); y = PH_Y(Y + 0.15); w = PH_W(5.5); h = PH_H(0.9); sizeEx = PH_FONT(0.95); }; \
    class SkLevel##IDX : Life_RscText { idc = 3006 + IDX; text = ""; style = 1; x = PH_X(6.2); y = PH_Y(Y + 0.15); w = PH_W(3.4); h = PH_H(0.9); sizeEx = PH_FONT(0.85); colorText[] = {0.55,0.80,1,1}; }; \
    class SkBonus##IDX : Life_RscPhoneLabel { idc = 2991 + IDX; text = ""; x = PH_X(0.9); y = PH_Y(Y + 1.05); w = PH_W(5.8); h = PH_H(0.8); sizeEx = PH_FONT(0.72); }; \
    class SkXp##IDX : Life_RscPhoneLabel { idc = 2996 + IDX; text = ""; style = 1; x = PH_X(6.2); y = PH_Y(Y + 1.05); w = PH_W(3.4); h = PH_H(0.8); sizeEx = PH_FONT(0.72); }; \
    class SkBar##IDX : Life_RscPhoneProgress { idc = 3001 + IDX; x = PH_X(0.9); y = PH_Y(Y + 2.1); w = PH_W(8.7); h = PH_H(0.5); };
class Life_Skills {
    idd = 2980;
    name = "life_skills";
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "[_this select 0] call life_fnc_phoneStatus; [] spawn life_fnc_skillsMenu;";
    class controlsBackground {
        PHONE_FRAME
    };
    class controls {
        PHONE_APPBAR(-1,"$STR_SK_Title","closeDialog 0;")
        SK_ROW(0,2.8)
        SK_ROW(1,6.05)
        SK_ROW(2,9.3)
        SK_ROW(3,12.55)
        SK_ROW(4,15.8)
        class SkHint : Life_RscPhoneStructured {
            idc = -1;
            text = "$STR_SK_Hint";
            y = PH_Y(19.0);
            h = PH_H(2.0);
            size = PH_FONT(0.7);
        };
    };
};
#undef SK_ROW
