/*
    File: FuelStat.hpp
    Description:
    Tankstelle im gemeinsamen Laden-Layout aus shop.hpp: links die Fahrzeuge in Reichweite,
    rechts Tankinhalt, Regler fuer die Menge und der Preis.
    IDCs unveraendert: 20301 Titel, 20302 Liste, 20303 Fahrzeugdaten, 20309 Tanken,
    20322 Preis je Liter, 20323 Summe, 20324 Menge, 20330 Kopfzeile, 20901 Regler.
*/
class Life_FuelStat {
    idd = 20300;
    name = "life_fuelStat";
    movingEnable = 0;
    enableSimulation = 1;
    //Die rechte Spalte bleibt leer, bis ein Fahrzeug gewaehlt ist (frueher wurde hier 2330
    //ausgeblendet - eine IDC aus dem Fahrzeughandel, die es in diesem Dialog nicht gibt).
    onLoad = "ctrlShow [20330,false]; [_this select 0] call life_fnc_shopStatus;";
    onUnload = "life_action_inUse = false;";
    class controlsBackground {
        SHOP_FRAME(20301,"")
        class StockLabel : Life_RscShopLabel {
            text = "$STR_Fuel_Vehicles";
            y = SH_Y(1.8);
        };
        class VehicleInfoHeader : Life_RscShopLabel {
            idc = 20330;
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
            idc = 20302;
            y = SH_Y(2.8);
            h = SH_H(13.8);
            onLBSelChanged = "_this call life_fnc_fuelLBChange";
        };
        class vehicleInfomationList : Life_RscShopStructured {
            idc = 20303;
            x = SH_X(14.6);
            y = SH_Y(3.1);
            w = SH_W(12.4);
            h = SH_H(4.0);
        };
        class FuelPrice : Life_RscShopLabel {
            idc = 20322;
            text = "";
            x = SH_X(14.6);
            y = SH_Y(7.4);
            w = SH_W(12.4);
        };
        class fuelTank : life_RscXSliderH {
            idc = 20901;
            text = "";
            color[] = {1, 1, 1, 0.45};
            colorActive[] = {1, 1, 1, 0.65};
            onSliderPosChanged = "[3,_this select 1] call life_fnc_s_onSliderChange;";
            tooltip = "";
            x = SH_X(14.6);
            y = SH_Y(8.6);
            w = SH_W(12.4);
            h = SH_H(1.0);
        };
        class literfuel : Life_RscShopLabel {
            idc = 20324;
            text = "";
            x = SH_X(14.6);
            y = SH_Y(9.9);
            w = SH_W(12.4);
        };
        class Totalfuel : Life_RscShopLabel {
            idc = 20323;
            text = "";
            x = SH_X(14.6);
            y = SH_Y(11.0);
            w = SH_W(12.4);
            h = SH_H(1.2);
            sizeEx = SH_FONT(1.0);
            colorText[] = {0.62, 0.84, 0.64, 1};
        };
        class refuelCar : Life_RscShopButton {
            idc = 20309;
            text = "$STR_Fuel_Refuel";
            onButtonClick = "[] spawn life_fnc_fuelRefuelCar;";
            x = SH_X(0.6);
        };
        class ShopClose : Life_RscShopClose {
            onButtonClick = "closeDialog 0; life_action_inUse = false;";
        };
    };
};
