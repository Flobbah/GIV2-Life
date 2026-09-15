/*
    File: key_chain.hpp
    Description:
    Schluesselbund-App im Telefonrahmen (siehe phone.hpp). IDCs unveraendert (2701-2703).
*/
class Life_key_management {
    idd = 2700;
    name= "life_key_chain";
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "[] spawn life_fnc_keyMenu; [_this select 0] call life_fnc_phoneStatus;";
    class controlsBackground {
        PHONE_FRAME
    };
    class controls {
        PHONE_APPBAR(-1,"$STR_PM_App_Keys","closeDialog 0;")
        class KeyChainList : Life_RscPhoneList {
            idc = 2701;
            text = "";
            y = PH_Y(2.8);
            h = PH_H(11.0);
        };
        class TargetLabel : Life_RscPhoneLabel {
            text = "$STR_PM_Recipient";
            y = PH_Y(14.1);
            w = PH_W(3.0);
        };
        class NearPlayers : Life_RscPhoneCombo {
            idc = 2702;
            y = PH_Y(14.1);
        };
        class GiveKey : Life_RscPhoneButton {
            idc = 2703;
            text = "$STR_Keys_GiveKey";
            x = PH_X(0.6);
            y = PH_Y(15.5);
            w = PH_W(4.5);
            onButtonClick = "[] call life_fnc_keyGive";
        };
        class DropKey : Life_RscPhoneButtonDanger {
            idc = -1;
            text = "$STR_Keys_DropKey";
            x = PH_X(5.4);
            y = PH_Y(15.5);
            w = PH_W(4.5);
            onButtonClick = "[] call life_fnc_keyDrop";
        };
    };
};
