/*
    File: bank.hpp
    Description:
    Geldautomat im gemeinsamen Laden-Layout aus shop.hpp, als schmale Theke.
    IDCs unveraendert: 2701 Kontostand, 2702 Betrag, 2703 Empfaenger, 2705/2706 Gangkasse.
*/
class Life_atm_management {
    idd = 2700;
    name = "life_atm_menu";
    movingEnable = 0;
    enableSimulation = 1;
    class controlsBackground {
        SHOP_FRAME_NARROW(-1,"$STR_ATM_Title")
    };
    class controls {
        //Kontostand gross in der Mitte - der Automat ist der einzige Ort, wo man ihn braucht
        class CashTitle : Life_RscShopStructured {
            idc = 2701;
            y = SH_Y(2.0);
            w = SH_W(11.8);
            h = SH_H(2.8);
            size = SH_FONT(1.1);
        };
        class AmountLabel : Life_RscShopLabel {
            text = "$STR_PM_AmountMoney";
            y = SH_Y(5.2);
            w = SH_W(3.2);
            h = SH_H(1.0);
        };
        class moneyEdit : Life_RscShopEdit {
            idc = 2702;
            text = "1";
            x = SH_X(3.8);
            y = SH_Y(5.2);
            w = SH_W(8.6);
        };
        class WithdrawButton : Life_RscShopButton {
            text = "$STR_ATM_Withdraw";
            onButtonClick = "[] call life_fnc_bankWithdraw";
            x = SH_X(0.6);
            y = SH_Y(6.5);
            w = SH_W(5.7);
        };
        class DepositButton : WithdrawButton {
            text = "$STR_ATM_Deposit";
            onButtonClick = "[] call life_fnc_bankDeposit";
            x = SH_X(6.7);
        };
        class TransferLabel : Life_RscShopLabel {
            text = "$STR_ATM_Transfer";
            y = SH_Y(8.3);
            w = SH_W(11.8);
        };
        class PlayerList : Life_RscShopCombo {
            idc = 2703;
            y = SH_Y(9.3);
            w = SH_W(11.8);
        };
        class TransferButton : Life_RscShopButton {
            text = "$STR_ATM_Transfer";
            onButtonClick = "[] call life_fnc_bankTransfer";
            x = SH_X(0.6);
            y = SH_Y(10.6);
            w = SH_W(11.8);
        };
        class GangLabel : Life_RscShopLabel {
            text = "$STR_ATM_GangBank";
            y = SH_Y(12.4);
            w = SH_W(11.8);
        };
        class GangWithdraw : Life_RscShopButtonAlt {
            idc = 2705;
            text = "$STR_ATM_WithdrawGang";
            onButtonClick = "[false] call life_fnc_useGangBank";
            x = SH_X(0.6);
            y = SH_Y(13.4);
            w = SH_W(5.7);
        };
        class GangDeposit : GangWithdraw {
            idc = 2706;
            text = "$STR_ATM_DepositGang";
            onButtonClick = "[true] call life_fnc_useGangBank";
            x = SH_X(6.7);
        };
        SHOP_CLOSE_NARROW
    };
};
