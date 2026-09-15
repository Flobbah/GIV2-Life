/*
    Admin compensation dialog (idd 9920)
    9921 info text, 9922 amount, 9923 account (bank / cash), 9924 "to selected player" button
    Logic: core\admin\fn_adminCompensate.sqf
*/
class Life_Admin_Compensate {
    idd = 9920;
    name= "life_admin_compensate_give";
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "[] spawn {waitUntil {!isNull (findDisplay 9920)}; [-1] call life_fnc_adminCompensate;};";
    class controlsBackground {
        class Life_RscTitleBackground: Life_RscText {
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])"};
            idc = -1;
            x = 0.1;
            y = 0.2;
            w = 0.5;
            h = (1 / 25);
        };
        class MainBackground: Life_RscText {
            colorBackground[] = {0, 0, 0, 0.7};
            idc = -1;
            x = 0.1;
            y = 0.2 + (11 / 250);
            w = 0.5;
            h = 0.36 - (22 / 250);
        };
    };
    class controls {
        class Title: Life_RscTitle {
            colorBackground[] = {0, 0, 0, 0};
            idc = -1;
            text = "$STR_Admin_Compensate";
            x = 0.1;
            y = 0.2;
            w = 0.5;
            h = (1 / 25);
        };
        class InfoMsg: Life_RscStructuredText {
            idc = 9921;
            sizeEx = 0.020;
            text = "";
            x = 0.11;
            y = 0.25;
            w = 0.48;
            h = 0.09;
        };
        class AmountLabel: Life_RscText {
            idc = -1;
            text = "$STR_Admin_Amount";
            sizeEx = 0.03;
            x = 0.11;
            y = 0.345;
            w = 0.48;
            h = 0.03;
        };
        class AdminCompensTex: Life_RscEdit {
            idc = 9922;
            text = "";
            x = 0.11;
            y = 0.38;
            w = 0.28;
            h = (1 / 25);
        };
        class AccountLabel: Life_RscText {
            idc = -1;
            text = "$STR_Admin_CompAccount";
            sizeEx = 0.03;
            x = 0.41;
            y = 0.345;
            w = 0.18;
            h = 0.03;
        };
        class AccountCombo: Life_RscCombo {
            idc = 9923;
            x = 0.41;
            y = 0.385;
            w = 0.18;
            h = 0.03;
        };
        class AdminCloseComp: Life_RscButtonMenu {
            idc = -1;
            text = "$STR_Global_Close";
            onButtonClick = "closeDialog 0;";
            x = 0.11;
            y = 0.46;
            w = (6.25 / 40);
            h = (1 / 25);
        };
        class AdminCompSelf: Life_RscButtonMenu {
            idc = -1;
            text = "$STR_Admin_CompSelf";
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            onButtonClick = "[0] spawn life_fnc_adminCompensate;";
            x = 0.275;
            y = 0.46;
            w = (6.25 / 40);
            h = (1 / 25);
        };
        class AdminCompTarget: Life_RscButtonMenu {
            idc = 9924;
            text = "$STR_Admin_CompTarget";
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            onButtonClick = "[1] spawn life_fnc_adminCompensate;";
            x = 0.4325;
            y = 0.46;
            w = (6.25 / 40);
            h = (1 / 25);
        };
    };
};
