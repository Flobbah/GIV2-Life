/*
    File: placement_hud.hpp
    Description:
    Hinweisleiste unten mittig beim freien Abstellen eines Fahrzeugs (RscTitles, Ebene "life_placement").
    Text (idc 3101) wird von core\placement\fn_placementFrame.sqf gesetzt.
*/
class Life_PlacementHud {
    idd = -1;
    duration = 1e+011;
    fadein = 0.15;
    fadeout = 0.15;
    movingEnable = 0;
    name = "life_placement_hud";
    onLoad = "uiNamespace setVariable ['life_placement_hud', _this select 0]";
    objects[] = {};
    class controls {
        class PlacementBackground : Life_RscText {
            idc = -1;
            text = "";
            x = 0.32 * safezoneW + safezoneX;
            y = 0.795 * safezoneH + safezoneY;
            w = 0.36 * safezoneW;
            h = 0.09 * safezoneH;
            colorBackground[] = {0.08, 0.09, 0.11, 0.78};
        };
        class PlacementAccent : Life_RscText {
            idc = -1;
            text = "";
            x = 0.32 * safezoneW + safezoneX;
            y = 0.795 * safezoneH + safezoneY;
            w = 0.36 * safezoneW;
            h = 0.003 * safezoneH;
            colorBackground[] = {0.24, 0.52, 0.88, 1};
        };
        class PlacementText : Life_RscStructuredText {
            idc = 3101;
            text = "";
            x = 0.32 * safezoneW + safezoneX;
            y = 0.803 * safezoneH + safezoneY;
            w = 0.36 * safezoneW;
            h = 0.08 * safezoneH;
            colorBackground[] = {0, 0, 0, 0};
        };
    };
};
