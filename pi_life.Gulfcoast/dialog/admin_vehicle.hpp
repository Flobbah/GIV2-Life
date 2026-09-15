/*
    Admin vehicle spawn dialog (idd 2950)
    2951 vehicle list, 2952 colour combo, 2953 search / classname, 2954 persistent checkbox,
    2955 vehicle info, 2956 result counter
    Logic: core\admin\fn_adminVehicleMenu.sqf / fn_adminVehicleSelect.sqf / fn_adminVehicleSpawn.sqf
*/
class Life_Admin_VehicleSpawn {
    idd = 2950;
    name = "life_admin_vehicle_spawn";
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "[] spawn {waitUntil {!isNull (findDisplay 2950)}; [] call life_fnc_adminVehicleMenu;};";
    class controlsBackground {
        class Life_RscTitleBackground: Life_RscText {
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])"};
            idc = -1;
            x = 0.2;
            y = 0.2;
            w = 0.6;
            h = (1 / 25);
        };
        class MainBackground: Life_RscText {
            colorBackground[] = {0, 0, 0, 0.7};
            idc = -1;
            x = 0.2;
            y = 0.2 + (11 / 250);
            w = 0.6;
            h = 0.62 - (22 / 250);
        };
    };
    class controls {
        class Title: Life_RscTitle {
            colorBackground[] = {0, 0, 0, 0};
            idc = -1;
            text = "$STR_AdminVeh_Title";
            x = 0.2;
            y = 0.2;
            w = 0.6;
            h = (1 / 25);
        };
        class SearchLabel: Life_RscText {
            idc = -1;
            text = "$STR_AdminVeh_Search";
            sizeEx = 0.03;
            x = 0.21;
            y = 0.255;
            w = 0.28;
            h = 0.03;
        };
        class SearchEdit: Life_RscEdit {
            idc = 2953;
            text = "";
            sizeEx = 0.03;
            onKeyUp = "[] call life_fnc_adminVehicleMenu;";
            x = 0.21;
            y = 0.29;
            w = 0.28;
            h = 0.035;
        };
        class VehicleList: Life_RscListBox {
            idc = 2951;
            text = "";
            sizeEx = 0.03;
            colorBackground[] = {0.1,0.1,0.1,0.9};
            onLBSelChanged = "_this call life_fnc_adminVehicleSelect";
            x = 0.21;
            y = 0.335;
            w = 0.28;
            h = 0.35;
        };
        class CountText: Life_RscText {
            idc = 2956;
            text = "";
            sizeEx = 0.03;
            x = 0.21;
            y = 0.685;
            w = 0.28;
            h = 0.03;
        };
        class InfoText: Life_RscStructuredText {
            idc = 2955;
            text = "";
            size = 0.03;
            x = 0.5;
            y = 0.255;
            w = 0.29;
            h = 0.28;
        };
        class ColorLabel: Life_RscText {
            idc = -1;
            text = "$STR_AdminVeh_Color";
            sizeEx = 0.03;
            x = 0.5;
            y = 0.545;
            w = 0.29;
            h = 0.03;
        };
        class ColorList: Life_RscCombo {
            idc = 2952;
            x = 0.5;
            y = 0.58;
            w = 0.29;
            h = 0.035;
        };
        class PersistentCheck: Life_Checkbox {
            idc = 2954;
            tooltip = "$STR_AdminVeh_Persistent";
            x = 0.5;
            y = 0.63;
            w = 0.03;
            h = 0.03;
        };
        class PersistentLabel: Life_RscText {
            idc = -1;
            text = "$STR_AdminVeh_Persistent";
            sizeEx = 0.03;
            x = 0.535;
            y = 0.625;
            w = 0.255;
            h = 0.04;
        };
        class CloseBtn: Life_RscButtonMenu {
            idc = -1;
            text = "$STR_Global_Close";
            onButtonClick = "closeDialog 0;";
            x = 0.21;
            y = 0.72;
            w = (6.25 / 40);
            h = (1 / 25);
        };
        class SpawnBtn: Life_RscButtonMenu {
            idc = -1;
            text = "$STR_AdminVeh_Spawn";
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            onButtonClick = "[] call life_fnc_adminVehicleSpawn;";
            x = 0.79 - (6.25 / 40);
            y = 0.72;
            w = (6.25 / 40);
            h = (1 / 25);
        };
    };
};
