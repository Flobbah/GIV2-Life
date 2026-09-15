/*
    Admin dialog "Spieler verwalten" (idd 9930)
    9931 Info, 9932 Lizenz-Combo, 9933 Erteilen, 9934 Entziehen,
    9935 Cop-Rang-Combo, 9936 Setzen, 9937 Medic-Rang-Combo, 9938 Setzen
    Logik: core\admin\fn_adminManage.sqf (Client) und life_server\Functions\Systems\fn_adminManage*.sqf (Server)
*/
class Life_Admin_Manage {
    idd = 9930;
    name= "life_admin_manage";
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "[] spawn {waitUntil {!isNull (findDisplay 9930)}; [-1] call life_fnc_adminManage;};";
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
            h = 0.51 - (22 / 250);
        };
    };
    class controls {
        class Title: Life_RscTitle {
            colorBackground[] = {0, 0, 0, 0};
            idc = -1;
            text = "$STR_Admin_Manage";
            x = 0.1;
            y = 0.2;
            w = 0.5;
            h = (1 / 25);
        };
        class InfoMsg: Life_RscStructuredText {
            idc = 9931;
            sizeEx = 0.020;
            text = "";
            x = 0.11;
            y = 0.25;
            w = 0.48;
            h = 0.08;
        };
        /* Lizenz */
        class LicenseLabel: Life_RscText {
            idc = -1;
            text = "$STR_Admin_ManageLicense";
            sizeEx = 0.03;
            x = 0.11;
            y = 0.335;
            w = 0.28;
            h = 0.03;
        };
        class LicenseCombo: Life_RscCombo {
            idc = 9932;
            x = 0.11;
            y = 0.37;
            w = 0.28;
            h = 0.03;
        };
        class LicenseGrant: Life_RscButtonMenu {
            idc = 9933;
            text = "$STR_Admin_ManageGrant";
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            onButtonClick = "[0] call life_fnc_adminManage;";
            x = 0.41;
            y = 0.365;
            w = 0.09;
            h = (1 / 25);
        };
        class LicenseRevoke: Life_RscButtonMenu {
            idc = 9934;
            text = "$STR_Admin_ManageRevoke";
            colorBackground[] = {0.538433, 0, 0, 0.6};
            onButtonClick = "[1] call life_fnc_adminManage;";
            x = 0.505;
            y = 0.365;
            w = 0.09;
            h = (1 / 25);
        };
        /* Cop-Rang */
        class CopLabel: Life_RscText {
            idc = -1;
            text = "$STR_Admin_ManageCopRank";
            sizeEx = 0.03;
            x = 0.11;
            y = 0.425;
            w = 0.28;
            h = 0.03;
        };
        class CopCombo: Life_RscCombo {
            idc = 9935;
            x = 0.11;
            y = 0.46;
            w = 0.28;
            h = 0.03;
        };
        class CopSet: Life_RscButtonMenu {
            idc = 9936;
            text = "$STR_Admin_ManageSet";
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            onButtonClick = "[2] spawn life_fnc_adminManage;";
            x = 0.41;
            y = 0.455;
            w = 0.185;
            h = (1 / 25);
        };
        /* Medic-Rang */
        class MedLabel: Life_RscText {
            idc = -1;
            text = "$STR_Admin_ManageMedicRank";
            sizeEx = 0.03;
            x = 0.11;
            y = 0.515;
            w = 0.28;
            h = 0.03;
        };
        class MedCombo: Life_RscCombo {
            idc = 9937;
            x = 0.11;
            y = 0.55;
            w = 0.28;
            h = 0.03;
        };
        class MedSet: Life_RscButtonMenu {
            idc = 9938;
            text = "$STR_Admin_ManageSet";
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            onButtonClick = "[3] spawn life_fnc_adminManage;";
            x = 0.41;
            y = 0.545;
            w = 0.185;
            h = (1 / 25);
        };
        class ManageClose: Life_RscButtonMenu {
            idc = -1;
            text = "$STR_Global_Close";
            onButtonClick = "closeDialog 0;";
            x = 0.11;
            y = 0.615;
            w = (6.25 / 40);
            h = (1 / 25);
        };
    };
};
