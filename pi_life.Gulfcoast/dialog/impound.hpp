/*
    File: impound.hpp
    Description:
    Garage und Beschlagnahmung im gemeinsamen Laden-Layout aus shop.hpp.
    IDCs unveraendert: 2801 Titel, 2802 Liste, 2803 Fahrzeugdaten, 2810/2811 Wartehinweis,
    2830 Kopfzeile der Fahrzeugdaten.
*/
class Life_impound_menu {
    idd = 2800;
    name = "life_vehicle_shop";
    movingEnable = 0;
    enableSimulation = 1;
    //Fahrzeugdaten bleiben leer, bis ein Fahrzeug gewaehlt ist (frueher stand hier 2330 - die
    //Kopfzeile des Fahrzeughandels, die es in diesem Dialog gar nicht gibt).
    onLoad = "ctrlShow [2803,false]; ctrlShow [2830,false]; [_this select 0] call life_fnc_shopStatus;";
    class controlsBackground {
        SHOP_FRAME(2801,"$STR_GUI_Garage")
        class StockLabel : Life_RscShopLabel {
            text = "$STR_GUI_YourVeh";
            y = SH_Y(1.8);
        };
        class VehicleInfoHeader : Life_RscShopLabel {
            idc = 2830;
            text = "$STR_GUI_VehInfo";
            x = SH_X(14.2);
            y = SH_Y(1.8);
        };
        class InfoPanel : Life_RscShopPanel {
            x = SH_X(14.2);
            y = SH_Y(2.8);
            w = SH_W(13.2);
            h = SH_H(13.8);
        };
    };
    class controls {
        class VehicleList : Life_RscShopList {
            idc = 2802;
            y = SH_Y(2.8);
            h = SH_H(13.8);
            onLBSelChanged = "_this call life_fnc_garageLBChange;";
        };
        class vehicleInfomationList : Life_RscShopStructured {
            idc = 2803;
            x = SH_X(14.6);
            y = SH_Y(3.1);
            w = SH_W(12.4);
            h = SH_H(13.2);
        };
        class RetrieveCar : Life_RscShopButton {
            text = "$STR_Global_Retrieve";
            onButtonClick = "[] call life_fnc_unimpound;";
            x = SH_X(0.6);
        };
        class SellCar : Life_RscShopButtonSell {
            text = "$STR_Global_Sell";
            onButtonClick = "[] call life_fnc_sellGarage; closeDialog 0;";
            x = SH_X(5.4);
        };
        SHOP_CLOSE
        //Wartehinweis, bis die Fahrzeuge aus der Datenbank da sind (fn_impoundMenu blendet ihn aus)
        class MainBackgroundHider : Life_RscShopPanel {
            idc = 2810;
            colorBackground[] = {0.10, 0.11, 0.14, 1};
            x = SH_X(0.6);
            y = SH_Y(1.8);
            w = SH_W(26.8);
            h = SH_H(14.8);
        };
        class MainHideText : Life_RscShopLabel {
            idc = 2811;
            style = 2;
            text = "$STR_ANOTF_QueryGarage";
            x = SH_X(0.6);
            y = SH_Y(8.6);
            w = SH_W(26.8);
            h = SH_H(1.2);
            sizeEx = SH_FONT(1.0);
        };
    };
};
