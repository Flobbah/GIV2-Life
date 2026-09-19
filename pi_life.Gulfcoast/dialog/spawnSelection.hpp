/*
    File: spawnSelection.hpp
    Description:
    Auswahl des Aufwachpunktes im Layout aus shop.hpp (dieselbe Bildsprache wie Laeden und Telefon).
    IDCs unveraendert: 38501 aktueller Punkt, 38502 Karte, 38510 Liste.

    Der Dialog bringt seinen eigenen schwarzen Hintergrund ueber das ganze Bild mit. Frueher lag das
    allein an "cutText BLACK FADED" - seit der Beitritt ohne Lobby laeuft, blendet die Engine dazwischen
    wieder auf und man sah die Insel, auf der man gerade steht. Der Hintergrund gehoert zum Dialog und
    verschwindet mit ihm, da kann kein Ablauf mehr dazwischenkommen.
*/
class life_spawn_selection {
    idd = 38500;
    movingEnable = 0;
    enableSimulation = 1;
    class controlsBackground {
        class Blackout : Life_RscText {
            idc = -1;
            x = safezoneX;
            y = safezoneY;
            w = safezoneW;
            h = safezoneH;
            colorBackground[] = {0, 0, 0, 1};
        };
        class ShopCard : Life_RscShopCard {};
        class ShopTitleBar : Life_RscShopTitleBar {};
        class Title : Life_RscShopTitle {
            text = "$STR_Spawn_Title";
            w = SH_W(12);
        };
        //Aktueller Aufwachpunkt, rechts in der Titelleiste
        class SpawnPointTitle : Life_RscShopTitle {
            idc = 38501;
            style = 1;
            text = "";
            x = SH_X(13);
            w = SH_W(14.4);
            sizeEx = SH_FONT(0.85);
        };
        class MapView : Life_RscMapControl {
            idc = 38502;
            x = SH_X(11.2);
            y = SH_Y(1.8);
            w = SH_W(16.2);
            h = SH_H(14.8);
            maxSatelliteAlpha = 0.75;
            alphaFadeStartScale = 1.15;
            alphaFadeEndScale = 1.29;
        };
    };
    class controls {
        class SpawnPointList : Life_RscListNBox {
            idc = 38510;
            text = "";
            coloumns[] = {0, 0, 0.9};
            drawSideArrows = 0;
            idcLeft = -1;
            idcRight = -1;
            x = SH_X(0.6);
            y = SH_Y(1.8);
            w = SH_W(10.2);
            h = SH_H(14.8);
            sizeEx = SH_FONT(0.9);
            rowHeight = SH_H(1.2);
            colorBackground[] = {0.16, 0.17, 0.21, 1};
            colorSelectBackground[] = {0.24, 0.52, 0.88, 0.7};
            colorSelectBackground2[] = {0.24, 0.52, 0.88, 0.7};
            colorSelect[] = {1, 1, 1, 1};
            colorSelect2[] = {1, 1, 1, 1};
            onLBSelChanged = "_this call life_fnc_spawnPointSelected;";
        };
        class spawnButton : Life_RscShopButton {
            text = "$STR_Spawn_Spawn";
            onButtonClick = "[] call life_fnc_spawnConfirm";
            x = SH_X(0.6);
            w = SH_W(10.2);
        };
    };
};
