/*
    File: navigation.hpp
    Description:
    Telefon-App "Navi" (idd 2970): aktuelle Route (2971), Zielliste (2972),
    Route starten (2973) und beenden (2974), Suchfeld (2975). Logik: core\navigation\fn_navMenu*.sqf
*/
class Life_Navigation {
    idd = 2970;
    name = "life_navigation";
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "[_this select 0] call life_fnc_phoneStatus; [] spawn life_fnc_navMenu;";
    class controlsBackground {
        PHONE_FRAME
    };
    class controls {
        PHONE_APPBAR(-1,"$STR_NAV_Title","closeDialog 0;")
        class NavInfoCard : Life_RscPhoneCard {
            y = PH_Y(2.8);
            h = PH_H(2.6);
        };
        class NavInfo : Life_RscPhoneStructured {
            idc = 2971;
            x = PH_X(0.9);
            y = PH_Y(2.9);
            w = PH_W(8.7);
            h = PH_H(2.4);
        };
        class NavSearchLabel : Life_RscPhoneLabel {
            text = "$STR_NAV_Search";
            y = PH_Y(5.7);
            w = PH_W(2.2);
        };
        class NavSearch : Life_RscPhoneEdit {
            idc = 2975;
            text = "";
            tooltip = "$STR_NAV_SearchTip";
            x = PH_X(2.9);
            y = PH_Y(5.7);
            w = PH_W(7.0);
            h = PH_H(1.0);
            onKeyUp = "[] call life_fnc_navMenuFilter;";
        };
        class NavList : Life_RscPhoneList {
            idc = 2972;
            text = "";
            y = PH_Y(6.9);
            h = PH_H(9.0);
        };
        class NavStart : Life_RscPhoneButton {
            idc = 2973;
            text = "$STR_NAV_Start";
            x = PH_X(0.6);
            y = PH_Y(16.2);
            w = PH_W(4.5);
            onButtonClick = "[] call life_fnc_navMenuStart;";
        };
        class NavStop : Life_RscPhoneButtonDanger {
            idc = 2974;
            text = "$STR_NAV_Stop";
            x = PH_X(5.4);
            y = PH_Y(16.2);
            w = PH_W(4.5);
            onButtonClick = "[] call life_fnc_navStop;";
        };
        class NavHint : Life_RscPhoneStructured {
            idc = -1;
            text = "$STR_NAV_Hint";
            y = PH_Y(17.6);
            h = PH_H(2.6);
            size = PH_FONT(0.75);
        };
    };
};
