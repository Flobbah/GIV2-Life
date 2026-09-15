/*
    File: wanted_list.hpp
    Description:
    Fahndungslisten-App (Polizei) im Telefonrahmen (siehe phone.hpp).
    IDCs unveraendert (1000-1002, 2401-2407, 9800).
*/
class life_wanted_menu {
    idd = 2400;
    name= "life_wanted_menu";
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "[_this select 0] call life_fnc_phoneStatus;";
    class controlsBackground {
        PHONE_FRAME
    };
    class controls {
        PHONE_APPBAR(-1,"$STR_Wanted_Title","closeDialog 0;")
        class WantedConnection : Life_RscPhoneLabel {
            idc = 2404;
            text = "";
            y = PH_Y(2.55);
            h = PH_H(0.7);
            sizeEx = PH_FONT(0.7);
        };
        class wantedText : Life_RscPhoneLabel {
            idc = 1000;
            text = "$STR_Wanted_People";
            y = PH_Y(3.25);
            h = PH_H(0.8);
        };
        class WantedList : Life_RscPhoneList {
            idc = 2401;
            text = "";
            onLBSelChanged = "[] spawn life_fnc_wantedGrab";
            y = PH_Y(4.05);
            h = PH_H(4.5);
        };
        class WantedDetails : Life_RscPhoneList {
            idc = 2402;
            text = "";
            y = PH_Y(8.7);
            h = PH_H(2.6);
            colorBackground[] = {0.13, 0.14, 0.18, 1};
        };
        class BountyPrice : Life_RscPhoneLabel {
            idc = 2403;
            text = "";
            y = PH_Y(11.35);
            h = PH_H(0.8);
            colorText[] = {1, 0.85, 0.4, 1};
        };
        class citizensText : Life_RscPhoneLabel {
            idc = 1001;
            text = "$STR_Wanted_Citizens";
            y = PH_Y(12.3);
            h = PH_H(0.8);
        };
        class PlayerList : Life_RscPhoneList {
            idc = 2406;
            text = "";
            y = PH_Y(13.1);
            h = PH_H(3.3);
        };
        class crimesText : Life_RscPhoneLabel {
            idc = 1002;
            text = "$STR_Wanted_Crimes";
            y = PH_Y(16.6);
            w = PH_W(3.0);
        };
        class WantedAddL : Life_RscPhoneCombo {
            idc = 2407;
            y = PH_Y(16.6);
        };
        class ButtonWantedAdd : Life_RscPhoneButton {
            idc = 9800;
            text = "$STR_Wanted_Add";
            x = PH_X(0.6);
            y = PH_Y(18.0);
            w = PH_W(4.5);
            onButtonClick = "[] call life_fnc_wantedAddP;";
        };
        class PardonButtonKey : Life_RscPhoneButtonAlt {
            idc = 2405;
            text = "$STR_Wanted_Pardon";
            x = PH_X(5.4);
            y = PH_Y(18.0);
            w = PH_W(4.5);
            onButtonClick = "[] call life_fnc_pardon; closeDialog 0;";
        };
    };
};
