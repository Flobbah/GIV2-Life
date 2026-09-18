/*
    File: cell_phone.hpp
    Description:
    Nachrichten-App im Telefonrahmen (siehe phone.hpp). IDCs unveraendert (3001-3022).
*/
class Life_cell_phone {
    idd = 3000;
    name= "life_cell_phone";
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "[] spawn life_fnc_cellphone; [_this select 0] call life_fnc_phoneStatus;";
    class controlsBackground {
        PHONE_FRAME
    };
    class controls {

        PHONE_APPBAR(3001,"$STR_CELL_Title","closeDialog 0;")
        class TextToSend : Life_RscPhoneLabel {
            idc = 3002;
            text = "$STR_CELL_TextToSend";
            y = PH_Y(2.8);
        };
        class textEdit : Life_RscPhoneEdit {
            idc = 3003;
            text = "";
            x = PH_X(0.6);
            y = PH_Y(3.7);
            w = PH_W(9.3);
            h = PH_H(1.0);
        };
        class RecipientLabel : Life_RscPhoneLabel {
            text = "$STR_PM_Recipient";
            y = PH_Y(5.0);
        };
        class PlayerList : Life_RscPhoneCombo {
            idc = 3004;
            x = PH_X(0.6);
            y = PH_Y(5.9);
            w = PH_W(9.3);
        };
        class TextMsgButton : Life_RscPhoneButton {
            idc = 3015;
            text = "$STR_CELL_TextMSGBtn";
            y = PH_Y(7.3);
            onButtonClick = "[] call TON_fnc_cell_textmsg";
        };
        class TextCopButton : Life_RscPhoneButtonAlt {
            idc = 3016;
            text = "$STR_CELL_TextPolice";
            y = PH_Y(8.7);
            onButtonClick = "[] call TON_fnc_cell_textcop";
        };
        class EMSRequest : Life_RscPhoneButtonAlt {
            idc = 3022;
            text = "$STR_CELL_EMSRequest";
            y = PH_Y(10.1);
            onButtonClick = "[] call TON_fnc_cell_emsrequest";
        };
        class TextAdminButton : Life_RscPhoneButtonAlt {
            idc = 3017;
            text = "$STR_CELL_TextAdmins";
            y = PH_Y(11.5);
            onButtonClick = "[] call TON_fnc_cell_textadmin";
        };
        // Nur fuer Admins sichtbar (siehe fn_cellphone.sqf)
        class AdminMsgButton : Life_RscPhoneButtonDanger {
            idc = 3020;
            text = "$STR_CELL_AdminMsg";
            y = PH_Y(13.5);
            onButtonClick = "[] call TON_fnc_cell_adminmsg";
        };
        class AdminMsgAllButton : Life_RscPhoneButtonDanger {
            idc = 3021;
            text = "$STR_CELL_AdminMSGAll";
            y = PH_Y(14.9);
            onButtonClick = "[] call TON_fnc_cell_adminmsgall";
        };
        /* Leiste zuletzt, damit sie ueber den Inhalten liegt und Klicks bekommt */
        PHONE_NAVBAR
    };
};
