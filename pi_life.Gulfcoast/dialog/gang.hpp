/*
    File: gang.hpp
    Description:
    Gang-App (Uebersicht und Gang gruenden) im Telefonrahmen (siehe phone.hpp).
    IDCs unveraendert (601, 2621-2632, 2522-2523).
*/
class Life_My_Gang_Diag {
    idd = 2620;
    name= "life_my_gang_menu";
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "[_this select 0] call life_fnc_phoneStatus;";
    class controlsBackground {
        PHONE_FRAME
    };
    class controls {

        // Titel (2629) wird von fn_gangMenu auf den Gangnamen gesetzt
        PHONE_APPBAR(2629,"$STR_Gang_Title","closeDialog 0;[] call life_fnc_p_updateMenu;")
        class GangBank : Life_RscPhoneLabel {
            idc = 601;
            text = "";
            y = PH_Y(2.6);
            colorText[] = {1, 0.85, 0.4, 1};
        };
        class GangMemberList : Life_RscPhoneList {
            idc = 2621;
            text = "";
            y = PH_Y(3.5);
            h = PH_H(7.0);
        };
        class InviteMember : Life_RscPhoneButton {
            idc = 2630;
            text = "$STR_Gang_Invite_Player";
            y = PH_Y(10.8);
            h = PH_H(1.05);
            onButtonClick = "[] spawn life_fnc_gangInvitePlayer";
        };
        class GangKick : Life_RscPhoneButtonAlt {
            idc = 2624;
            text = "$STR_Gang_Kick";
            y = PH_Y(12.0);
            h = PH_H(1.05);
            onButtonClick = "[] call life_fnc_gangKick";
        };
        class GangLeader : Life_RscPhoneButtonAlt {
            idc = 2625;
            text = "$STR_Gang_SetLeader";
            y = PH_Y(13.2);
            h = PH_H(1.05);
            onButtonClick = "[] spawn life_fnc_gangNewLeader";
        };
        class GangLock : Life_RscPhoneButtonAlt {
            idc = 2622;
            text = "$STR_Gang_UpgradeSlots";
            y = PH_Y(14.4);
            h = PH_H(1.05);
            onButtonClick = "[] spawn life_fnc_gangUpgrade";
        };
        class GangLeave : Life_RscPhoneButtonDanger {
            idc = -1;
            text = "$STR_Gang_Leave";
            y = PH_Y(15.6);
            h = PH_H(1.05);
            onButtonClick = "[] call life_fnc_gangLeave";
        };
        class DisbandGang : Life_RscPhoneButtonDanger {
            idc = 2631;
            text = "$STR_Gang_Disband_Gang";
            y = PH_Y(16.8);
            h = PH_H(1.05);
            onButtonClick = "[] spawn life_fnc_gangDisband";
        };
        class InviteLabel : Life_RscPhoneLabel {
            text = "$STR_PM_InviteTarget";
            y = PH_Y(18.0);
            h = PH_H(0.8);
        };
        class ColorList : Life_RscPhoneCombo {
            idc = 2632;
            x = PH_X(0.6);
            y = PH_Y(18.8);
            w = PH_W(9.3);
        };
        /* Leiste zuletzt, damit sie ueber den Inhalten liegt und Klicks bekommt */
        PHONE_NAVBAR
    };
};
class Life_Create_Gang_Diag {
    idd = 2520;
    name= "life_my_gang_menu_create";
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "[_this select 0] call life_fnc_phoneStatus; [] spawn {waitUntil {!isNull (findDisplay 2520)}; ((findDisplay 2520) displayCtrl 2523) ctrlSetText format [localize ""STR_Gang_PriceTxt"",[(getNumber(missionConfigFile >> 'Life_Settings' >> 'gang_price'))] call life_fnc_numberText]};";
    class controlsBackground {
        PHONE_FRAME
    };
    class controls {
        PHONE_APPBAR(-1,"$STR_Gang_Title","closeDialog 0;[] call life_fnc_p_updateMenu;")
        class InfoMsg : Life_RscPhoneStructured {
            idc = 2523;
            text = "";
            y = PH_Y(2.8);
            h = PH_H(2.6);
        };
        // Platzhaltertext wie bisher, fn_createGang prueft keinen leeren Namen
        class CreateGangText : Life_RscPhoneEdit {
            idc = 2522;
            text = "$STR_Gang_YGN";
            x = PH_X(0.6);
            y = PH_Y(5.8);
            w = PH_W(9.3);
            h = PH_H(1.0);
        };
        class GangCreateField : Life_RscPhoneButton {
            idc = -1;
            text = "$STR_Gang_Create";
            y = PH_Y(7.2);
            onButtonClick = "[] call life_fnc_createGang";
        };
        /* Leiste zuletzt, damit sie ueber den Inhalten liegt und Klicks bekommt */
        PHONE_NAVBAR
    };
};
