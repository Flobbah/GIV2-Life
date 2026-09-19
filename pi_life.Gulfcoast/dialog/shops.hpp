/*
    File: shops.hpp
    Description:
    Waffen- und Ausruestungsladen im gemeinsamen Laden-Layout aus shop.hpp.
    IDCs unveraendert: 38401 Titel, 38402 Auswahl (Laden/eigene Sachen), 38403 Liste,
    38404 Beschreibung, 38405 Kaufen/Verkaufen, 38406 Magazine, 38407 Zubehoer.
*/
class life_weapon_shop {
    idd = 38400;
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "[_this select 0] call life_fnc_shopStatus;";
    class controlsBackground {
        SHOP_FRAME(38401,"")
        //Flaeche hinter der Beschreibung, damit die rechte Spalte nicht im Nichts steht
        class InfoPanel : Life_RscShopPanel {
            x = SH_X(14.2);
            y = SH_Y(1.8);
            w = SH_W(13.2);
            h = SH_H(14.8);
        };
    };
    class controls {
        class FilterList : Life_RscShopCombo {
            idc = 38402;
            y = SH_Y(1.8);
            onLBSelChanged = "_this call life_fnc_weaponShopFilter";
        };
        class itemList : Life_RscShopList {
            idc = 38403;
            y = SH_Y(3.1);
            h = SH_H(13.5);
            onLBSelChanged = "_this call life_fnc_weaponShopSelection";
        };
        class itemInfo : Life_RscShopStructured {
            idc = 38404;
            x = SH_X(14.6);
            y = SH_Y(2.1);
            w = SH_W(12.4);
            h = SH_H(14.2);
        };
        class ButtonBuySell : Life_RscShopButton {
            idc = 38405;
            text = "$STR_Global_Buy";
            onButtonClick = "[] spawn life_fnc_weaponShopBuySell; true";
            x = SH_X(0.6);
        };
        class ButtonMags : Life_RscShopButtonAlt {
            idc = 38406;
            text = "$STR_Global_Mags";
            onButtonClick = "_this call life_fnc_weaponShopMags; _this call life_fnc_weaponShopFilter";
            x = SH_X(5.4);
        };
        class ButtonAccs : ButtonMags {
            idc = 38407;
            text = "$STR_Global_Accs";
            onButtonClick = "_this call life_fnc_weaponShopAccs; _this call life_fnc_weaponShopFilter";
            x = SH_X(10.2);
        };
        SHOP_CLOSE
    };
};
