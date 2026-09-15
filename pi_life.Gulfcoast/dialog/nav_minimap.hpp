/*
    File: nav_minimap.hpp
    Description:
    Navi-Minikarte (RscTitles, Ebene "life_nav_minimap"). Rahmen 3200, Karte 3201, Akzentlinie 3202,
    Infozeile 3203. Positionen setzt core\navigation\fn_navMiniMap.sqf aus CfgNavigation.
    Die Karte selbst zeigt nichts: Gelaende, Strassen, Namen, Objekte und Marker sind unsichtbar
    geschaltet, nur der Hintergrund ist dunkel. Sie dient als Leinwand fuer die gedrehte Navi-Ansicht,
    die fn_navMiniMapDraw zeichnet. KEIN mapOrientation verwenden (Speicherueberlauf, siehe ROADMAP).
*/
#define NAV_HIDDEN {0, 0, 0, 0}
class Life_NavMiniMap {
    idd = -1;
    duration = 1e+011;
    fadein = 0.25;
    fadeout = 0.25;
    movingEnable = 0;
    name = "life_nav_minimap";
    onLoad = "uiNamespace setVariable ['life_nav_minimap', _this select 0]";
    objects[] = {};
    class controlsBackground {
        class NavMiniFrame : Life_RscText {
            idc = 3200;
            text = "";
            x = 0; y = 0; w = 0.1; h = 0.1;
            colorBackground[] = {0.08, 0.09, 0.11, 0.9};
        };
        class NavMiniAccent : Life_RscText {
            idc = 3202;
            text = "";
            x = 0; y = 0; w = 0.1; h = 0.003;
            colorBackground[] = {0.24, 0.52, 0.88, 1};
        };
    };
    class controls {
        class NavMiniMapControl : Life_RscMapControl {
            idc = 3201;
            x = 0; y = 0; w = 0.1; h = 0.1;
            moveOnEdges = 0;
            drawObjects = 0;
            drawLocations = 0;
            showMarkers = 0;
            maxSatelliteAlpha = 0;
            alphaFadeStartScale = 10;
            alphaFadeEndScale = 10;
            drawShaded = 0;
            shadedSea = 0;
            showCountourInterval = 0;
            scaleMin = 0.001;
            scaleMax = 1;
            scaleDefault = 0.05;
            colorBackground[] = {0.10, 0.11, 0.13, 1};
            colorOutside[] = {0.10, 0.11, 0.13, 1};
            colorSea[] = NAV_HIDDEN;
            colorForest[] = NAV_HIDDEN;
            colorForestTextured[] = NAV_HIDDEN;
            colorForestBorder[] = NAV_HIDDEN;
            colorRocks[] = NAV_HIDDEN;
            colorRocksBorder[] = NAV_HIDDEN;
            colorTown[] = NAV_HIDDEN;
            colorTownBorder[] = NAV_HIDDEN;
            colorCountlines[] = NAV_HIDDEN;
            colorCountlinesWater[] = NAV_HIDDEN;
            colorMainCountlines[] = NAV_HIDDEN;
            colorMainCountlinesWater[] = NAV_HIDDEN;
            colorPowerLines[] = NAV_HIDDEN;
            colorRailWay[] = NAV_HIDDEN;
            colorNames[] = NAV_HIDDEN;
            colorLevels[] = NAV_HIDDEN;
            colorTracks[] = NAV_HIDDEN;
            colorTracksFill[] = NAV_HIDDEN;
            colorRoads[] = NAV_HIDDEN;
            colorRoadsFill[] = NAV_HIDDEN;
            colorMainRoads[] = NAV_HIDDEN;
            colorMainRoadsFill[] = NAV_HIDDEN;
            colorTrails[] = NAV_HIDDEN;
            colorTrailsFill[] = NAV_HIDDEN;
            colorRiver[] = NAV_HIDDEN;
            colorGrid[] = NAV_HIDDEN;
            colorGridMap[] = NAV_HIDDEN;
            colorInactive[] = NAV_HIDDEN;
            colorLabelBackground[] = NAV_HIDDEN;
            colorText[] = NAV_HIDDEN;
            class Task : Task {
                colorCreated[] = NAV_HIDDEN;
                colorCanceled[] = NAV_HIDDEN;
                colorDone[] = NAV_HIDDEN;
                colorFailed[] = NAV_HIDDEN;
                color[] = NAV_HIDDEN;
            };
        };
        class NavMiniInfo : Life_RscStructuredText {
            idc = 3203;
            text = "";
            x = 0; y = 0; w = 0.1; h = 0.03;
            colorBackground[] = {0, 0, 0, 0};
        };
    };
};
#undef NAV_HIDDEN
