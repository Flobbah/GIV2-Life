/*
    File: shop_items.hpp
    Description:
    Markt (virtueller Laden) im gemeinsamen Laden-Layout aus shop.hpp.
    IDCs unveraendert (2401 Angebot, 2402 eigene Ware, 2403 Titel, 2404/2405 Menge,
    17999 Alles verkaufen); neu sind 2406/2410 (Vorschau), 2411/2412 (Spaltenkoepfe).
*/
class shops_menu {
    idd = 2400;
    name = "shops_menu";
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "[_this select 0] call life_fnc_shopStatus;";
    class controlsBackground {
        SHOP_FRAME(2403,"")
        class OfferLabel : Life_RscShopLabel {
            idc = 2412;
            text = "";
            y = SH_Y(1.8);
        };
        class OwnLabel : OfferLabel {
            idc = 2411;
            x = SH_X(14.2);
        };
    };
    class controls {
        class itemList : Life_RscShopList {
            idc = 2401;
            y = SH_Y(2.8);
            h = SH_H(11.4);
            onLBSelChanged = "[] call life_fnc_virt_preview;";
        };
        class pItemlist : itemList {
            idc = 2402;
            x = SH_X(14.2);
        };
        class BuyAmountLabel : Life_RscShopLabel {
            text = "$STR_PM_Amount";
            x = SH_X(0.6);
            y = SH_Y(14.4);
            w = SH_W(2.8);
            h = SH_H(1.1);
        };
        class buyEdit : Life_RscShopEdit {
            idc = 2404;
            text = "1";
            x = SH_X(3.4);
            y = SH_Y(14.4);
            w = SH_W(3.0);
            h = SH_H(1.1);
            onKeyUp = "[] call life_fnc_virt_preview;";
        };
        class SellAmountLabel : BuyAmountLabel {
            x = SH_X(14.2);
        };
        class sellEdit : buyEdit {
            idc = 2405;
            x = SH_X(17.0);
        };
        //Die drei Knoepfe stehen in der Fussleiste: "Alles verkaufen" passt in eine schmale Spalte
        //nicht hinein, abgeschnittene Beschriftungen sehen nach Bastelei aus.
        class ButtonAddG : Life_RscShopButton {
            text = "$STR_VS_BuyItem";
            onButtonClick = "[] call life_fnc_virt_buy;";
            x = SH_X(0.6);
            w = SH_W(6.6);
        };
        class ButtonRemoveG : Life_RscShopButtonSell {
            text = "$STR_VS_SellItem";
            onButtonClick = "[] call life_fnc_virt_sell;";
            x = SH_X(7.6);
            w = SH_W(6.6);
        };
        class ButtonRemoveAllG : ButtonRemoveG {
            idc = 17999;
            text = "$STR_VS_SellAll";
            onButtonClick = "[] call life_fnc_virt_sellAll;";
            x = SH_X(14.6);
            w = SH_W(7.8);
        };
        //Vorschau: was der Einkauf kostet und wiegt, was der Verkauf bringt
        class BuyPreview : Life_RscShopStructured {
            idc = 2406;
            x = SH_X(0.6);
            y = SH_Y(15.7);
            w = SH_W(13.2);
            h = SH_H(1.2);
        };
        class SellPreview : BuyPreview {
            idc = 2410;
            x = SH_X(14.2);
        };
        SHOP_CLOSE
    };
};
