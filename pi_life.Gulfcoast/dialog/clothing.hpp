/*
    File: clothing.hpp
    Description:
    Kleiderladen im Layout aus shop.hpp, als schmale Theke am linken Bildrand (SL_X): die Kamera
    stellt die Spielfigur in die Bildmitte, die muss beim Anprobieren frei bleiben.
    IDCs unveraendert: 3101 Liste, 3102 Preis, 3103 Titel, 3105 Auswahl, 3106 Summe,
    3107 Blickwinkel.
*/
class Life_Clothing {
    idd = 3100;
    name = "Life_Clothing";
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "[_this select 0] call life_fnc_shopStatus;";
    class controlsBackground {
        class ShopCard : Life_RscShopCard {
            x = SL_X(0);
            w = SH_W(13);
        };
        class ShopTitleBar : Life_RscShopTitleBar {
            x = SL_X(0);
            w = SH_W(13);
        };
        class ShopTitle : Life_RscShopTitle {
            idc = 3103;
            text = "";
            x = SL_X(0.6);
            w = SH_W(6);
        };
        class ShopMoney : Life_RscShopMoney {
            x = SL_X(6.4);
            w = SH_W(6);
        };
    };
    class controls {
        class FilterList : Life_RscShopCombo {
            idc = 3105;
            x = SL_X(0.6);
            y = SH_Y(1.8);
            w = SH_W(11.8);
            onLBSelChanged = "_this call life_fnc_clothingFilter";
        };
        class ClothingList : Life_RscShopList {
            idc = 3101;
            x = SL_X(0.6);
            y = SH_Y(3.1);
            w = SH_W(11.8);
            h = SH_H(10.6);
            onLBSelChanged = "[_this] call life_fnc_changeClothes;";
        };
        //Drehen der Spielfigur - frueher lag der Regler quer ueber dem unteren Bildrand
        class TurnLabel : Life_RscShopLabel {
            text = "$STR_Shop_Turn";
            x = SL_X(0.6);
            y = SH_Y(14.0);
            w = SH_W(3.2);
            h = SH_H(0.9);
        };
        class viewAngle : life_RscXSliderH {
            idc = 3107;
            text = "";
            color[] = {1, 1, 1, 0.45};
            colorActive[] = {1, 1, 1, 0.65};
            onSliderPosChanged = "[4,_this select 1] call life_fnc_s_onSliderChange;";
            tooltip = "";
            x = SL_X(3.8);
            y = SH_Y(14.0);
            w = SH_W(8.6);
            h = SH_H(0.9);
        };
        class PriceTag : Life_RscShopStructured {
            idc = 3102;
            x = SL_X(0.6);
            y = SH_Y(15.2);
            w = SH_W(5.8);
            h = SH_H(1.1);
        };
        class TotalPrice : PriceTag {
            idc = 3106;
            x = SL_X(6.6);
        };
        class BuyButtonKey : Life_RscShopButton {
            text = "$STR_Global_Buy";
            onButtonClick = "[] spawn life_fnc_buyClothes;";
            x = SL_X(0.6);
            w = SH_W(5.7);
        };
        //Schliessen setzt die Figur zurueck auf das, was sie wirklich traegt
        class ShopClose : Life_RscShopClose {
            onButtonClick = "closeDialog 0; [] call life_fnc_playerSkins;";
            x = SL_X(6.7);
            w = SH_W(5.7);
        };
    };
};
