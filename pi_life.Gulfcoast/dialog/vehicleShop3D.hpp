/*
    File: vehicleShop3D.hpp
    Description:
    Fahrzeughandel mit Vorschau im gemeinsamen Laden-Layout aus shop.hpp. Das Fahrzeug steht in
    der Bildmitte, deshalb haengen die beiden Spalten an den Bildraendern (SL_X links, SR_X rechts)
    statt mittig wie in den anderen Laeden.
    IDCs unveraendert: 2301 Titel, 2302 Liste, 2303 Fahrzeugdaten, 2304 Farbe, 2309 Kaufen,
    2330 Kopfzeile der Fahrzeugdaten (wird beim Oeffnen ausgeblendet).
*/
class Life_Vehicle_Shop_v2_3D {
    idd = 2300;
    name = "life_vehicle_shop";
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "call life_fnc_3dPreviewInit; ctrlShow [2330,false]; [_this select 0] call life_fnc_shopStatus;";
    onUnLoad = "call life_fnc_3dPreviewExit;";
    class controlsBackground {
        class ShopCard : Life_RscShopCard {
            x = SL_X(0);
            w = SH_W(13);
        };
        class ShopTitleBar : Life_RscShopTitleBar {
            x = SL_X(0);
            w = SH_W(13);
        };
        class Title : Life_RscShopTitle {
            idc = 2301;
            x = SL_X(0.6);
            w = SH_W(6);
        };
        class ShopMoney : Life_RscShopMoney {
            x = SL_X(6.4);
            w = SH_W(6);
        };
        //Rechte Spalte: Daten zum ausgewaehlten Fahrzeug
        class InfoCard : Life_RscShopCard {
            x = SR_X(0);
            w = SH_W(13);
            h = SH_H(12);
        };
        class VehicleInfoHeader : Life_RscShopTitleBar {
            idc = 2330;
            text = "$STR_GUI_VehInfo";
            x = SR_X(0);
            w = SH_W(13);
        };
    };
    class controls {
        class VehicleList : Life_RscShopList {
            idc = 2302;
            x = SL_X(0.6);
            y = SH_Y(1.8);
            w = SH_W(11.8);
            h = SH_H(12.6);
            onLBSelChanged = "_this call life_fnc_vehicleShopLBChange";
        };
        //Farbauswahl blendet life_fnc_vehicleShopLBChange ein und aus, deshalb ohne eigene Beschriftung
        class ColorList : Life_RscShopCombo {
            idc = 2304;
            x = SL_X(0.6);
            y = SH_Y(14.6);
            w = SH_W(11.8);
            onLBSelChanged = "call life_fnc_vehicleColor3DRefresh;";
        };
        class vehicleInfomationList : Life_RscShopStructured {
            idc = 2303;
            x = SR_X(0.6);
            y = SH_Y(1.8);
            w = SH_W(11.8);
            h = SH_H(9.8);
        };
        class BuyCar : Life_RscShopButton {
            idc = 2309;
            text = "$STR_Global_Buy";
            onButtonClick = "[true] spawn life_fnc_vehicleShopBuy;";
            x = SL_X(0.6);
            y = SH_Y(16.0);
            w = SH_W(5.7);
            h = SH_H(1.3);
        };
        class RentCar : Life_RscShopButtonAlt {
            text = "$STR_Global_RentVeh";
            onButtonClick = "[false] spawn life_fnc_vehicleShopBuy;";
            x = SL_X(6.7);
            y = SH_Y(16.0);
            w = SH_W(5.7);
            h = SH_H(1.3);
        };
        class CloseBtn : Life_RscShopClose {
            x = SL_X(0.6);
            y = SH_Y(17.4);
            w = SH_W(11.8);
        };
    };
};
