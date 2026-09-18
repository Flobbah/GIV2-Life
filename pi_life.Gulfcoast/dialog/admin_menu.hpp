/*
    Admin menu (idd 2900)
    Button grid: 4 columns x 5 rows below the player list / info box.
    Visibility per admin level is handled in core\admin\fn_adminMenu.sqf (idc -> level table).
*/
#define ADM_COL(n) ((0.29 + (n) * 0.1075) * safezoneW + safezoneX)
#define ADM_ROW(n) ((0.535 + (n) * 0.028) * safezoneH + safezoneY)
class Life_RscAdminButton: Life_RscButtonMenu {
    idc = -1;
    w = 0.1025 * safezoneW;
    h = 0.022 * safezoneH;
};
class life_admin_menu {
    idd = 2900;
    name= "life_admin_menu";
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "[] spawn life_fnc_adminMenu;";
    class controlsBackground {
        class MainBackground: Life_RscText {
            idc = -1;
            colorBackground[] = {0,0,0,0.7};
            x = 0.28 * safezoneW + safezoneX;
            y = 0.24 * safezoneH + safezoneY;
            w = 0.44 * safezoneW;
            h = 0.45 * safezoneH;
        };
        class Life_RscTitleBackground: Life_RscText {
            idc = -1;
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])"};
            text = "$STR_Admin_Title";
            x = 0.28 * safezoneW + safezoneX;
            y = 0.218 * safezoneH + safezoneY;
            w = 0.44 * safezoneW;
            h = 0.022 * safezoneH;
        };
    };
    class controls {
        class PlayerList_Admin: Life_RscListBox {
            idc = 2902;
            text = "";
            sizeEx = 0.035;
            onLBSelChanged = "[_this] spawn life_fnc_adminQuery";
            x = 0.29 * safezoneW + safezoneX;
            y = 0.262 * safezoneH + safezoneY;
            w = 0.17 * safezoneW;
            h = 0.26 * safezoneH;
        };
        class PlayerBInfo: Life_RscStructuredText {
            idc = 2903;
            text = "";
            x = 0.47 * safezoneW + safezoneX;
            y = 0.262 * safezoneH + safezoneY;
            w = 0.24 * safezoneW;
            h = 0.26 * safezoneH;
            colorBackground[] = {0,0,0,0.7};
        };
        /* Row 1 */
        class BtnGetID: Life_RscAdminButton {
            idc = 2919;
            text = "$STR_Admin_GetID";
            onButtonClick = "[] call life_fnc_adminGetID;";
            x = ADM_COL(0);
            y = ADM_ROW(0);
        };
        class BtnCompensate: Life_RscAdminButton {
            idc = 2904;
            text = "$STR_Admin_Compensate";
            onButtonClick = "life_admin_target = [] call life_fnc_adminTarget; createDialog ""Life_Admin_Compensate"";";
            x = ADM_COL(1);
            y = ADM_ROW(0);
        };
        class BtnSpectate: Life_RscAdminButton {
            idc = 2905;
            text = "$STR_Admin_Spectate";
            onButtonClick = "[] call life_fnc_adminSpectate;";
            x = ADM_COL(2);
            y = ADM_ROW(0);
        };
        class BtnTeleport: Life_RscAdminButton {
            idc = 2906;
            text = "$STR_Admin_Teleport";
            onButtonClick = "[] call life_fnc_adminTeleport; [ localize 'STR_Admin_TeleportHint',false,'fast'] call life_fnc_notification_system;";
            x = ADM_COL(3);
            y = ADM_ROW(0);
        };
        /* Row 2 */
        class BtnTpHere: Life_RscAdminButton {
            idc = 2907;
            text = "$STR_Admin_TpHere";
            onButtonClick = "[] call life_fnc_adminTpHere;";
            x = ADM_COL(0);
            y = ADM_ROW(1);
        };
        class BtnTpTo: Life_RscAdminButton {
            idc = 2912;
            text = "$STR_Admin_TpTo";
            onButtonClick = "[] call life_fnc_adminTpTo;";
            x = ADM_COL(1);
            y = ADM_ROW(1);
        };
        class BtnGod: Life_RscAdminButton {
            idc = 2908;
            text = "$STR_Admin_God";
            onButtonClick = "[] call life_fnc_adminGodMode;";
            x = ADM_COL(2);
            y = ADM_ROW(1);
        };
        class BtnFreeze: Life_RscAdminButton {
            idc = 2909;
            text = "$STR_Admin_Freeze";
            onButtonClick = "[] call life_fnc_adminFreeze;";
            x = ADM_COL(3);
            y = ADM_ROW(1);
        };
        /* Row 3 */
        class BtnMarkers: Life_RscAdminButton {
            idc = 2910;
            text = "$STR_Admin_Markers";
            onButtonClick = "[] spawn life_fnc_adminMarkers;closeDialog 0;";
            x = ADM_COL(0);
            y = ADM_ROW(2);
        };
        class BtnArsenal: Life_RscAdminButton {
            idc = 2913;
            text = "$STR_Admin_Arsenal";
            onButtonClick = "[] spawn life_fnc_adminArsenal;";
            x = ADM_COL(1);
            y = ADM_ROW(2);
        };
        class BtnVehSpawn: Life_RscAdminButton {
            idc = 2914;
            text = "$STR_Admin_VehSpawn";
            onButtonClick = "closeDialog 0; createDialog ""Life_Admin_VehicleSpawn"";";
            x = ADM_COL(2);
            y = ADM_ROW(2);
        };
        class BtnHealSelf: Life_RscAdminButton {
            idc = 2915;
            text = "$STR_Admin_HealSelf";
            onButtonClick = "[0] call life_fnc_adminHeal;";
            x = ADM_COL(3);
            y = ADM_ROW(2);
        };
        /* Row 4 */
        class BtnHealTarget: Life_RscAdminButton {
            idc = 2916;
            text = "$STR_Admin_HealTarget";
            onButtonClick = "[1] call life_fnc_adminHeal;";
            x = ADM_COL(0);
            y = ADM_ROW(3);
        };
        class BtnRepairVeh: Life_RscAdminButton {
            idc = 2917;
            text = "$STR_Admin_RepairVeh";
            onButtonClick = "[] call life_fnc_adminRepairVeh;";
            x = ADM_COL(1);
            y = ADM_ROW(3);
        };
        class BtnDeleteVeh: Life_RscAdminButton {
            idc = 2918;
            text = "$STR_Admin_DeleteVeh";
            onButtonClick = "[] call life_fnc_adminDeleteVeh;";
            x = ADM_COL(2);
            y = ADM_ROW(3);
        };
        class BtnDebug: Life_RscAdminButton {
            idc = 2911;
            text = "$STR_Admin_Debug";
            onButtonClick = "[] call life_fnc_adminDebugCon;";
            x = ADM_COL(3);
            y = ADM_ROW(3);
        };
        /* Row 5 */
        class BtnClose: Life_RscAdminButton {
            idc = -1;
            text = "$STR_Global_Close";
            onButtonClick = "closeDialog 0;";
            x = ADM_COL(0);
            y = ADM_ROW(4);
        };
        class BtnManage: Life_RscAdminButton {
            idc = 2920;
            text = "$STR_Admin_Manage";
            onButtonClick = "life_admin_target = [] call life_fnc_adminTarget; if (isNull life_admin_target) then {[localize 'STR_ANOTF_NoTarget',true,'fast'] call life_fnc_notification_system;} else {createDialog ""Life_Admin_Manage"";};";
            x = ADM_COL(1);
            y = ADM_ROW(4);
        };
        class BtnMoney: Life_RscAdminButton {
            idc = 2921;
            text = "$STR_Admin_Money";
            onButtonClick = "createDialog ""Life_Admin_Money"";";
            x = ADM_COL(2);
            y = ADM_ROW(4);
        };
    };
};
#undef ADM_COL
#undef ADM_ROW
