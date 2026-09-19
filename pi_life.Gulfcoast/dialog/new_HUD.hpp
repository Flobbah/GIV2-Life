/*
    File: new_HUD.hpp
    Description:
    Dauerhafte Anzeige am unteren rechten Bildrand: Zustand (Leben, Hunger, Durst), Geld und die
    Zahl der Spieler je Fraktion. Dazu die Navigationszeile unten in der Mitte (IDC 30).

    Gefuellt wird sie von life_fnc_hudUpdate; die IDCs sind unveraendert:
        1/4 Leben, 2/5 Hunger, 3/6 Durst (Balken/Text), 7 Konto, 8 Bargeld,
        9 Polizei, 10 Rettungsdienst, 11 Zivilisten, 30 Navigationszeile.

    Die Kachel ist 7.3 x 5.9 Rastereinheiten gross, mal HUD_SCALE (1.5) - also knapp ein Drittel der
    Bildbreite - und haengt
    mit einer halben Einheit Abstand in der unteren rechten Ecke. Gerechnet wird ab
    safezoneX/Y + Breite/Hoehe, also ab dem echten Bildrand (siehe phone.hpp).
    Urspruenglich von Kureo & Zalac, Credit: Danny - das Layout ist neu, die Aufteilung dieselbe.

    Die Datei wird zweimal eingebunden (einmal ueber MasterHandler.hpp, einmal in RscTitles),
    deshalb stehen die Makros hinter einer Abfrage.
*/
#ifndef HUD_X
//Groesse der ganzen Kachel an einer Stelle: 1.0 waere das Raster von Telefon und Laeden, 1.5 ist
//eineinhalbmal so gross. Positionen, Abstaende und Schriftgroessen haengen alle daran, die Kachel
//bleibt also in sich stimmig und in der unteren rechten Ecke verankert.
#define HUD_SCALE 1.5
#define HUD_X(n) (safezoneX + safezoneW - (7.8 - (n)) * HUD_SCALE * GUI_GRID_CENTER_W)
#define HUD_Y(n) (safezoneY + safezoneH - (6.4 - (n)) * HUD_SCALE * GUI_GRID_CENTER_H)
#define HUD_W(n) ((n) * HUD_SCALE * GUI_GRID_CENTER_W)
#define HUD_H(n) ((n) * HUD_SCALE * GUI_GRID_CENTER_H)
#define HUD_FONT(n) (GUI_GRID_CENTER_H * HUD_SCALE * (n))
#endif

class new_HUD {
    idd = 20099;
    duration = 1e+1000;
    movingEnable = 0;
    fadein = 0;
    fadeout = 0;
    name = "playerHUD";
    onLoad = "uiNamespace setVariable ['playerHUD',_this select 0]";
    objects[] = {};
    class controlsBackground {
        //Eine gemeinsame Flaeche statt sechs einzelner Kaesten - durchscheinend, damit sie die
        //Sicht nicht zumauert.
        class HudCard : Life_RscText {
            idc = -1;
            x = HUD_X(0);
            y = HUD_Y(0);
            w = HUD_W(7.3);
            h = HUD_H(5.9);
            colorBackground[] = {0.10, 0.11, 0.14, 0.55};
        };
        class HealthIcon : Life_RscPicture {
            idc = -1;
            text = "pi_data\hud\health.paa";
            x = HUD_X(0.25);
            y = HUD_Y(0.3);
            w = HUD_W(0.65);
            h = HUD_H(0.65);
        };
        class FoodIcon : HealthIcon {
            text = "pi_data\hud\food.paa";
            y = HUD_Y(1.2);
        };
        class WaterIcon : HealthIcon {
            text = "pi_data\hud\water.paa";
            y = HUD_Y(2.1);
        };
        class HealthBar : Life_RscProgress {
            idc = 1;
            x = HUD_X(1.05);
            y = HUD_Y(0.48);
            w = HUD_W(4.0);
            h = HUD_H(0.32);
            colorFrame[] = {0, 0, 0, 0};
            colorBackground[] = {0.16, 0.17, 0.21, 0.9};
            colorBar[] = {0.78, 0.25, 0.25, 1};
        };
        class FoodBar : HealthBar {
            idc = 2;
            y = HUD_Y(1.38);
            colorBar[] = {0.85, 0.55, 0.15, 1};
        };
        class WaterBar : HealthBar {
            idc = 3;
            y = HUD_Y(2.28);
            colorBar[] = {0.25, 0.55, 0.85, 1};
        };
    };
    class controls {
        class Nav_Hud : Life_RscStructuredText {
            idc = 30;
            text = "";
            x = 0.34 * safezoneW + safezoneX;
            y = 0.955 * safezoneH + safezoneY;
            w = 0.32 * safezoneW;
            h = 0.035 * safezoneH;
            colorBackground[] = {0, 0, 0, 0};
        };
        //Prozentwerte rechts neben den Balken; die Farbe setzt life_fnc_hudUpdate ab 30 bzw. 15 Prozent
        class HealthText : Life_RscText {
            idc = 4;
            style = 1;
            text = "100%";
            x = HUD_X(5.1);
            y = HUD_Y(0.25);
            w = HUD_W(2.0);
            h = HUD_H(0.75);
            sizeEx = HUD_FONT(0.62);
            colorText[] = {0.88, 0.90, 0.94, 1};
            colorBackground[] = {0, 0, 0, 0};
        };
        class FoodText : HealthText {
            idc = 5;
            y = HUD_Y(1.15);
        };
        class WaterText : HealthText {
            idc = 6;
            y = HUD_Y(2.05);
        };
        //Konto und Bargeld je in einer eigenen Zeile - siebenstellige Betraege passen sonst nicht
        class BankIcon : Life_RscPicture {
            idc = -1;
            text = "pi_data\hud\bank.paa";
            x = HUD_X(0.25);
            y = HUD_Y(3.1);
            w = HUD_W(0.6);
            h = HUD_H(0.6);
        };
        class BankText : Life_RscText {
            idc = 7;
            text = "";
            x = HUD_X(1.05);
            y = HUD_Y(3.05);
            w = HUD_W(6.1);
            h = HUD_H(0.7);
            sizeEx = HUD_FONT(0.65);
            colorText[] = {0.62, 0.84, 0.64, 1};
            colorBackground[] = {0, 0, 0, 0};
        };
        class CashIcon : BankIcon {
            text = "pi_data\hud\cash.paa";
            y = HUD_Y(3.95);
        };
        class CashText : BankText {
            idc = 8;
            y = HUD_Y(3.9);
        };
        //Spieler je Fraktion
        class CopIcon : Life_RscPicture {
            idc = -1;
            text = "pi_data\hud\cop.paa";
            x = HUD_X(0.25);
            y = HUD_Y(4.95);
            w = HUD_W(0.55);
            h = HUD_H(0.55);
        };
        class CopText : Life_RscText {
            idc = 9;
            text = "";
            x = HUD_X(0.95);
            y = HUD_Y(4.9);
            w = HUD_W(1.5);
            h = HUD_H(0.7);
            sizeEx = HUD_FONT(0.62);
            colorText[] = {0.88, 0.90, 0.94, 1};
            colorBackground[] = {0, 0, 0, 0};
        };
        class MedIcon : CopIcon {
            text = "pi_data\hud\med.paa";
            x = HUD_X(2.5);
        };
        class MedText : CopText {
            idc = 10;
            x = HUD_X(3.2);
        };
        class CivIcon : CopIcon {
            text = "pi_data\hud\civ.paa";
            x = HUD_X(4.8);
        };
        class CivText : CopText {
            idc = 11;
            x = HUD_X(5.5);
            w = HUD_W(1.8);
        };
    };
};
