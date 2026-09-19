/*
    File: vehicleShop.hpp
    Description:
    Fahrzeughandel ohne 3D-Vorschau im gemeinsamen Laden-Layout aus shop.hpp. Wird nur genutzt,
    wenn Life_Settings >> vehicleShop_3D auf false steht - sonst kommt vehicleShop3D.hpp.
    IDCs unveraendert: 2301 Titel, 2302 Liste, 2303 Fahrzeugdaten, 2304 Farbe, 2309 Kaufen,
    2330 Kopfzeile der Fahrzeugdaten (wird beim Oeffnen ausgeblendet).
*/
class Life_Vehicle_Shop_v2 {
    idd = 2300;
    name = "life_vehicle_shop";
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "ctrlShow [2330,false]; [_this select 0] call life_fnc_shopStatus;";
    class controlsBackground {
        SHOP_FRAME(2301,"")
        class StockLabel : Life_RscShopLabel {
            text = "$STR_GUI_ShopStock";
            y = SH_Y(1.8);
        };
        class VehicleInfoHeader : Life_RscShopLabel {
            idc = 2330;
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
            idc = 2302;
            y = SH_Y(2.8);
            h = SH_H(12.4);
            onLBSelChanged = "_this call life_fnc_vehicleShopLBChange";
        };
        class ColorList : Life_RscShopCombo {
            idc = 2304;
            y = SH_Y(15.4);
        };
        class vehicleInfomationList : Life_RscShopStructured {
            idc = 2303;
            x = SH_X(14.6);
            y = SH_Y(3.1);
            w = SH_W(12.4);
            h = SH_H(13.2);
        };
        class BuyCar : Life_RscShopButton {
            idc = 2309;
            text = "$STR_Global_Buy";
            onButtonClick = "[true] spawn life_fnc_vehicleShopBuy;";
            x = SH_X(0.6);
        };
        class RentCar : Life_RscShopButtonAlt {
            text = "$STR_Global_RentVeh";
            onButtonClick = "[false] spawn life_fnc_vehicleShopBuy;";
            x = SH_X(5.4);
        };
        SHOP_CLOSE
    };
};
