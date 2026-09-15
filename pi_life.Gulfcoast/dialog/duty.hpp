/*
    File: duty.hpp
    Description:
    Telefon-App "Dienst" (idd 3020): Status (3021 Fraktion, 3022 Freigaben), naechste Dienststellen
    (3023 Polizei, 3024 Rettungsdienst), Buttons Polizeidienst (3025), Rettungsdienst (3026),
    Dienst beenden (3027) und Hinweistext (3028).
    Logik: core\duty\fn_dutyMenu.sqf (Aufbau, Abfrage), fn_dutyUpdate.sqf (Anzeige), fn_dutySwitch.sqf (Wechsel)
*/
class Life_Duty {
    idd = 3020;
    name = "life_duty";
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "[_this select 0] call life_fnc_phoneStatus; [] spawn life_fnc_dutyMenu;";
    class controlsBackground {
        PHONE_FRAME
    };
    class controls {
        PHONE_APPBAR(-1,"$STR_DUTY_Title","closeDialog 0;")
        class DutyCardStatus : Life_RscPhoneCard { y = PH_Y(2.8); h = PH_H(3.1); };
        class DutyStatusLabel : Life_RscPhoneLabel { text = "$STR_DUTY_StatusLabel"; x = PH_X(0.9); y = PH_Y(2.95); w = PH_W(8.7); h = PH_H(0.8); sizeEx = PH_FONT(0.72); };
        class DutyStatus : Life_RscText { idc = 3021; text = ""; x = PH_X(0.9); y = PH_Y(3.75); w = PH_W(8.7); h = PH_H(1.0); sizeEx = PH_FONT(1.0); };
        class DutyRank : Life_RscPhoneLabel { idc = 3022; text = ""; x = PH_X(0.9); y = PH_Y(4.8); w = PH_W(8.7); h = PH_H(0.8); sizeEx = PH_FONT(0.72); };
        class DutyCardStations : Life_RscPhoneCard { y = PH_Y(6.2); h = PH_H(3.1); };
        class DutyStationLabel : Life_RscPhoneLabel { text = "$STR_DUTY_StationLabel"; x = PH_X(0.9); y = PH_Y(6.35); w = PH_W(8.7); h = PH_H(0.8); sizeEx = PH_FONT(0.72); };
        class DutyStationCop : Life_RscText { idc = 3023; text = ""; x = PH_X(0.9); y = PH_Y(7.15); w = PH_W(8.7); h = PH_H(0.9); sizeEx = PH_FONT(0.8); };
        class DutyStationMed : Life_RscText { idc = 3024; text = ""; x = PH_X(0.9); y = PH_Y(8.05); w = PH_W(8.7); h = PH_H(0.9); sizeEx = PH_FONT(0.8); };
        class DutyBtnCop : Life_RscPhoneButton { idc = 3025; text = "$STR_DUTY_BtnCop"; y = PH_Y(9.9); h = PH_H(1.5); onButtonClick = "[west] spawn life_fnc_dutySwitch;"; };
        class DutyBtnMed : Life_RscPhoneButton { idc = 3026; text = "$STR_DUTY_BtnMed"; y = PH_Y(11.7); h = PH_H(1.5); onButtonClick = "[independent] spawn life_fnc_dutySwitch;"; };
        class DutyBtnOff : Life_RscPhoneButtonDanger { idc = 3027; text = "$STR_DUTY_BtnOff"; y = PH_Y(13.5); h = PH_H(1.5); onButtonClick = "[civilian] spawn life_fnc_dutySwitch;"; };
        class DutyHint : Life_RscPhoneStructured { idc = 3028; text = ""; y = PH_Y(15.5); h = PH_H(6.0); size = PH_FONT(0.7); };
    };
};
