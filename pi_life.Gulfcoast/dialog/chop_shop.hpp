/*
    File: chop_shop.hpp
    Description:
    Schrottplatz im gemeinsamen Laden-Layout aus shop.hpp, als schmale Theke - es gibt nur eine
    Liste der Fahrzeuge in Reichweite und den Preis dazu.
    IDCs unveraendert: 39401 Preis, 39402 Liste.
*/
class Chop_Shop {
    idd = 39400;
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "[_this select 0] call life_fnc_shopStatus;";
    class controlsBackground {
        SHOP_FRAME_NARROW(-1,"$STR_ChopShop_Title")
    };
    class controls {
        class vehicleList : Life_RscShopList {
            idc = 39402;
            y = SH_Y(1.8);
            w = SH_W(11.8);
            h = SH_H(12.6);
            onLBSelChanged = "_this call life_fnc_chopShopSelection";
        };
        class priceInfo : Life_RscShopStructured {
            idc = 39401;
            y = SH_Y(14.7);
            w = SH_W(11.8);
            h = SH_H(2.2);
        };
        class BtnSell : Life_RscShopButtonSell {
            text = "$STR_Global_Sell";
            onButtonClick = "[] call life_fnc_chopShopSell;";
            x = SH_X(0.6);
        };
        SHOP_CLOSE_NARROW
    };
};
