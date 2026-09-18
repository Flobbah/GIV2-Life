#include "player_sys.sqf"
/*
    File: player_inv.hpp
    Description:
    Spielermenue (Z-Taste) im Smartphone-Layout.
    Startseite mit App-Kacheln; Inventar, Lizenzen und Geld sind Seiten innerhalb dieses
    Dialogs und werden ueber life_fnc_p_showPage ein- und ausgeblendet. Die uebrigen Apps
    oeffnen eigene Dialoge im gleichen Telefonrahmen (siehe phone.hpp).

    Die IDCs der Inventar- und Geld-Steuerelemente (2001, 2002, 2005, 2009, 2010, 2014,
    2015, 2018, 2022, 2023) sind unveraendert - die Skripte in core\pmenu greifen darauf zu.
    Neue IDCs 2030-2065 sind in core\pmenu\fn_p_showPage.sqf den Seiten zugeordnet.
*/
class playerSettings {
    idd = playersys_DIALOG;
    movingEnable = 0;
    enableSimulation = 1;
    //Uhrzeit und Name fuellt der Dialog selbst - egal ob er ueber die Taste, Home oder Zurueck aufgeht
    onLoad = "[_this select 0] call life_fnc_phoneStatus;";
    class controlsBackground {
        PHONE_FRAME
    };
    class controls {

        /* ===================== Startseite ===================== */
        class HomeHeaderCard : Life_RscPhoneCard {
            idc = 2030;
            y = PH_Y(1.5);
            h = PH_H(2.9);
        };
        class HomePlayerName : Life_RscText {
            idc = 2031;
            text = "";
            x = PH_X(0.9);
            y = PH_Y(1.6);
            w = PH_W(8.7);
            h = PH_H(0.9);
            sizeEx = PH_FONT(1.0);
        };
        class HomeMoney : Life_RscPhoneStructured {
            idc = 2015;
            x = PH_X(0.9);
            y = PH_Y(2.45);
            w = PH_W(8.7);
            h = PH_H(0.9);
        };
        class HomeWeight : Life_RscPhoneLabel {
            idc = carry_weight;
            x = PH_X(0.9);
            y = PH_Y(3.35);
            w = PH_W(8.7);
        };
        // Reihe 1
        class TileInventory : Life_RscPhoneTileTeal {
            idc = 2032;
            text = "$STR_PM_App_Inventory";
            x = PH_X(0.6);
            y = PH_Y(4.8);
            onButtonClick = "['inventory'] call life_fnc_p_showPage;";
        };
        class TileLicenses : Life_RscPhoneTileBlue {
            idc = 2033;
            text = "$STR_PM_App_Licenses";
            x = PH_X(3.8);
            y = PH_Y(4.8);
            onButtonClick = "['licenses'] call life_fnc_p_showPage;";
        };
        class TileMoney : Life_RscPhoneTileGreen {
            idc = 2034;
            text = "$STR_PM_App_Money";
            x = PH_X(7.0);
            y = PH_Y(4.8);
            onButtonClick = "['money'] call life_fnc_p_showPage;";
        };
        // Reihe 2
        class TileKeys : Life_RscPhoneTileOrange {
            idc = 2013;
            text = "$STR_PM_App_Keys";
            x = PH_X(0.6);
            y = PH_Y(7.8);
            onButtonClick = "[""Life_key_management""] call life_fnc_p_openApp;";
        };
        class TilePhone : Life_RscPhoneTileCyan {
            idc = 2035;
            text = "$STR_PM_App_Phone";
            x = PH_X(3.8);
            y = PH_Y(7.8);
            onButtonClick = "[""Life_cell_phone""] call life_fnc_p_openApp;";
        };
        class TileSettings : Life_RscPhoneTileGrey {
            idc = 2036;
            text = "$STR_PM_App_Settings";
            x = PH_X(7.0);
            y = PH_Y(7.8);
            onButtonClick = "[] call life_fnc_settingsMenu;";
        };
        // Reihe 3: Karte, Navi, dann Gang (Zivilisten) bzw. Fahndung (Polizei) auf dem dritten Platz
        class TileGang : Life_RscPhoneTileRed {
            idc = 2011;
            text = "$STR_PM_App_Gang";
            x = PH_X(7.0);
            y = PH_Y(10.8);
            onButtonClick = "if (isNil ""life_action_gangInUse"") then {if (isNil {(group player) getVariable ""gang_owner""}) then {createDialog ""Life_Create_Gang_Diag"";} else {[] spawn life_fnc_gangMenu;};};";
        };
        class TileWanted : Life_RscPhoneTileIndigo {
            idc = 2012;
            text = "$STR_PM_App_Wanted";
            x = PH_X(7.0);
            y = PH_Y(10.8);
            onButtonClick = "[] call life_fnc_wantedMenu";
        };
        class TileMap : Life_RscPhoneTileOlive {
            idc = 2048;
            text = "$STR_PM_App_Map";
            x = PH_X(0.6);
            y = PH_Y(10.8);
            onButtonClick = "[""Life_Map_Filter""] call life_fnc_p_openApp;";
        };
        class TileNav : Life_RscPhoneTileNavy {
            idc = 2049;
            text = "$STR_PM_App_Nav";
            x = PH_X(3.8);
            y = PH_Y(10.8);
            onButtonClick = "[""Life_Navigation""] call life_fnc_p_openApp;";
        };
        // Reihe 4: Skills, Admin (nur fuer Admins)
        class TileSkills : Life_RscPhoneTileGold {
            idc = 2047;
            text = "$STR_PM_App_Skills";
            x = PH_X(0.6);
            y = PH_Y(13.8);
            onButtonClick = "[""Life_Skills""] call life_fnc_p_openApp;";
        };
        class TileAdmin : Life_RscPhoneTileMagenta {
            idc = 2021;
            text = "$STR_PM_App_Admin";
            x = PH_X(3.8);
            y = PH_Y(13.8);
            onButtonClick = "closeDialog 0; createDialog ""life_admin_menu"";";
        };
        // Dock
        class TileDuty : Life_RscPhoneTileSteel {
            idc = 2054;
            text = "$STR_PM_App_Duty";
            x = PH_X(7.0);
            y = PH_Y(13.8);
            onButtonClick = "[""Life_Duty""] call life_fnc_p_openApp;";
        };

        /* ===================== Seite: Inventar ===================== */
        class InvAppBar : Life_RscPhoneAppBar {
            idc = 2040;
        };
        class InvTitle : Life_RscPhoneAppTitle {
            idc = 2041;
            text = "$STR_PM_App_Inventory";
        };
        class InvList : Life_RscPhoneList {
            idc = item_list;
            y = PH_Y(2.8);
            h = PH_H(8.55);
        };
        /* Gewicht: Beschriftung (11.4 - 12.05), darunter Spur und Fuellung (12.1 - 12.5),
           die Mengenzeile beginnt bei 12.7. Gefuellt wird beides in fn_p_updateMenu. */
        class InvWeightLabel : Life_RscPhoneLabel {
            idc = 2072;
            text = "";
            y = PH_Y(11.4);
            h = PH_H(0.65);
            sizeEx = PH_FONT(0.72);
        };
        class InvWeightTrack : Life_RscPhoneCard {
            idc = 2070;
            y = PH_Y(12.1);
            h = PH_H(0.4);
            colorBackground[] = {0.10, 0.11, 0.14, 1};
        };
        class InvWeightFill : Life_RscPhoneCard {
            idc = 2071;
            y = PH_Y(12.1);
            w = PH_W(0.1);
            h = PH_H(0.4);
            colorBackground[] = {0.24, 0.62, 0.42, 1};
        };
        class InvAmountLabel : Life_RscPhoneLabel {
            idc = 2043;
            text = "$STR_PM_Amount";
            y = PH_Y(12.7);
            w = PH_W(3.0);
        };
        class InvAmount : Life_RscPhoneEdit {
            idc = item_edit;
            text = "1";
            y = PH_Y(12.7);
        };
        class InvTargetLabel : Life_RscPhoneLabel {
            idc = 2044;
            text = "$STR_PM_Recipient";
            y = PH_Y(13.8);
            w = PH_W(3.0);
        };
        class InvTarget : Life_RscPhoneCombo {
            idc = 2023;
            y = PH_Y(13.8);
        };
        class InvUse : Life_RscPhoneButton {
            idc = 2045;
            text = "$STR_Global_Use";
            x = PH_X(0.6);
            y = PH_Y(15.2);
            w = PH_W(2.95);
            onButtonClick = "[] call life_fnc_useItem;";
        };
        class InvGive : Life_RscPhoneButtonAlt {
            idc = 2002;
            text = "$STR_Global_Give";
            x = PH_X(3.775);
            y = PH_Y(15.2);
            w = PH_W(2.95);
            onButtonClick = "[] call life_fnc_giveItem;";
        };
        class InvRemove : Life_RscPhoneButtonDanger {
            idc = 2046;
            text = "$STR_Global_Remove";
            x = PH_X(6.95);
            y = PH_Y(15.2);
            w = PH_W(2.95);
            onButtonClick = "[] call life_fnc_removeItem;";
        };

        /* ===================== Seite: Lizenzen ===================== */
        class LicAppBar : Life_RscPhoneAppBar {
            idc = 2050;
        };
        class LicTitle : Life_RscPhoneAppTitle {
            idc = 2051;
            text = "$STR_PM_App_Licenses";
        };
        class LicGroup : Life_RscControlsGroup {
            idc = 2053;
            x = PH_X(0.6);
            y = PH_Y(2.8);
            w = PH_W(9.3);
            h = PH_H(17.5);
            class Controls {
                class LicText : Life_RscStructuredText {
                    idc = 2014;
                    text = "";
                    x = 0;
                    y = 0;
                    w = PH_W(8.9);
                    h = PH_H(17.4);
                    size = PH_FONT(0.9);
                };
            };
        };

        /* ===================== Seite: Geld ===================== */
        class MoneyAppBar : Life_RscPhoneAppBar {
            idc = 2060;
        };
        class MoneyTitle : Life_RscPhoneAppTitle {
            idc = 2061;
            text = "$STR_PM_App_Money";
        };
        class MoneyCard : Life_RscPhoneStructured {
            idc = 2063;
            y = PH_Y(2.8);
            h = PH_H(2.6);
            size = PH_FONT(1.0);
        };
        class MoneyAmountLabel : Life_RscPhoneLabel {
            idc = 2064;
            text = "$STR_PM_AmountMoney";
            y = PH_Y(5.8);
            w = PH_W(3.0);
        };
        class MoneyAmount : Life_RscPhoneEdit {
            idc = 2018;
            text = "1";
            y = PH_Y(5.8);
        };
        class MoneyTargetLabel : Life_RscPhoneLabel {
            idc = 2065;
            text = "$STR_PM_Recipient";
            y = PH_Y(6.9);
            w = PH_W(3.0);
        };
        class MoneyTarget : Life_RscPhoneCombo {
            idc = 2022;
            y = PH_Y(6.9);
        };
        class MoneyGive : Life_RscPhoneButton {
            idc = 2001;
            text = "$STR_Global_Give";
            y = PH_Y(8.3);
            onButtonClick = "[] call life_fnc_giveMoney";
        };
        /* Leiste zuletzt, damit sie ueber den Inhalten liegt und Klicks bekommt */
        PHONE_NAVBAR
    };
};
