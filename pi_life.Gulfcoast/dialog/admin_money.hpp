/*
    Admin-Dialog "Transaktionen" (idd 9940) im Layout aus shop.hpp.
    9941 Liste, 9942 Filter/Stunden, 9943 Info
    Logik: core\admin\fn_adminMoneyLog.sqf und core\admin\fn_adminEconReport.sqf (Client),
           life_server\Functions\Systems\fn_adminMoneyQuery.sqf und
           life_server\Functions\Economy\fn_econReport.sqf (Server)
*/
class Life_Admin_Money {
    idd = 9940;
    name = "life_admin_money";
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "[] spawn {waitUntil {!isNull (findDisplay 9940)}; [-1] call life_fnc_adminMoneyLog;};";
    class controlsBackground {
        class ShopCard : Life_RscShopCard {};
        class ShopTitleBar : Life_RscShopTitleBar {};
        class ShopTitle : Life_RscShopTitle {
            text = "$STR_Admin_Money";
            w = SH_W(14);
        };
    };
    class controls {
        class FilterEdit : Life_RscShopEdit {
            idc = 9942;
            text = "";
            x = SH_X(0.6);
            y = SH_Y(1.8);
            w = SH_W(9.4);
        };
        class FilterBtn : Life_RscShopButton {
            text = "$STR_Admin_MoneyFilter";
            onButtonClick = "[0] call life_fnc_adminMoneyLog;";
            x = SH_X(10.4);
            y = SH_Y(1.8);
            w = SH_W(4.2);
            h = SH_H(1.0);
        };
        class ReportBtn : Life_RscShopButtonAlt {
            text = "$STR_Admin_MoneyReport";
            onButtonClick = "[] call life_fnc_adminEconReport;";
            x = SH_X(14.8);
            y = SH_Y(1.8);
            w = SH_W(4.2);
            h = SH_H(1.0);
        };
        class InfoText : Life_RscShopStructured {
            idc = 9943;
            x = SH_X(19.4);
            y = SH_Y(1.8);
            w = SH_W(8.0);
            h = SH_H(1.0);
        };
        class MoneyList : Life_RscShopList {
            idc = 9941;
            y = SH_Y(3.1);
            w = SH_W(26.8);
            h = SH_H(13.5);
            sizeEx = SH_FONT(0.8);
        };
        SHOP_CLOSE
    };
};
