/*
    Admin dialog "Transaktionen" (idd 9940)
    9941 Liste, 9942 Filter, 9943 Info
    Logik: core\admin\fn_adminMoneyLog.sqf (Client), life_server\Functions\Systems\fn_adminMoneyQuery.sqf (Server)
*/
class Life_Admin_Money {
    idd = 9940;
    name = "life_admin_money";
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "[] spawn {waitUntil {!isNull (findDisplay 9940)}; [-1] call life_fnc_adminMoneyLog;};";
    class controlsBackground {
        class Life_RscTitleBackground: Life_RscText {
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])"};
            idc = -1;
            x = 0.1;
            y = 0.15;
            w = 0.8;
            h = (1 / 25);
        };
        class MainBackground: Life_RscText {
            colorBackground[] = {0, 0, 0, 0.7};
            idc = -1;
            x = 0.1;
            y = 0.15 + (11 / 250);
            w = 0.8;
            h = 0.6 - (22 / 250);
        };
    };
    class controls {
        class Title: Life_RscTitle {
            colorBackground[] = {0, 0, 0, 0};
            idc = -1;
            text = "$STR_Admin_Money";
            x = 0.1;
            y = 0.15;
            w = 0.8;
            h = (1 / 25);
        };
        class FilterEdit: Life_RscEdit {
            idc = 9942;
            text = "";
            x = 0.11;
            y = 0.21;
            w = 0.35;
            h = 0.03;
        };
        class FilterBtn: Life_RscButtonMenu {
            idc = -1;
            text = "$STR_Admin_MoneyFilter";
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            onButtonClick = "[0] call life_fnc_adminMoneyLog;";
            x = 0.47;
            y = 0.205;
            w = 0.15;
            h = (1 / 25);
        };
        class InfoText: Life_RscStructuredText {
            idc = 9943;
            text = "";
            x = 0.63;
            y = 0.205;
            w = 0.26;
            h = 0.04;
        };
        class MoneyList: Life_RscListBox {
            idc = 9941;
            x = 0.11;
            y = 0.26;
            w = 0.78;
            h = 0.42;
        };
        class MoneyClose: Life_RscButtonMenu {
            idc = -1;
            text = "$STR_Global_Close";
            onButtonClick = "closeDialog 0;";
            x = 0.11;
            y = 0.69;
            w = (6.25 / 40);
            h = (1 / 25);
        };
    };
};
