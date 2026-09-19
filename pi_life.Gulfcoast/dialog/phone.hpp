/*
    File: phone.hpp
    Description:
    Gemeinsame Basis fuer das Spielermenue (Z-Taste) im Smartphone-Layout und dessen "Apps"
    (Inventar, Lizenzen, Geld, Schluessel, Telefon, Gang, Fahndung, Einstellungen).

    Das Telefon ist 10.5 Rastereinheiten breit und 22 hoch und sitzt mittig im Bild.
    Alle Positionen werden relativ zur linken oberen Ecke des Telefons angegeben:
        PH_X(n) / PH_Y(n)  -> Bildschirmposition fuer die Telefon-Koordinate n
        PH_W(n) / PH_H(n)  -> Breite / Hoehe in Rastereinheiten
        PH_FONT(n)         -> Schriftgroesse (1.0 = Standardgroesse der Life-Dialoge)

    Innenbereich (Bildschirm): x 0.3 .. 10.2, y 0.45 .. 21.35
    Inhaltsbereich der Apps:   x 0.6 .. 9.9 (Breite 9.3), y ab 2.8 (unterhalb der App-Leiste)

    Feste IDCs in jedem Telefon-Dialog: 2097 = Fraktion (Statusleiste rechts), 2098 = Uhrzeit.
    Beides fuellt life_fnc_phoneStatus aus dem onLoad des jeweiligen Dialogs.
*/
//Lage des Telefons: mittig am unteren Bildrand, mit etwas Luft nach unten fuer die Statusleiste.
//Gerechnet wird ab der Mitte bzw. der Unterkante der Safezone, also am echten Bildrand.
//GUI_GRID_CENTER_X/Y beziehen sich dagegen auf eine zentrierte Box, die bei breiten Bildschirmen
//deutlich schmaler ist als das Bild - damit sass das Geraet vorher nicht dort, wo es sollte.
//Die Groesse bleibt an GUI_GRID_CENTER_W/H gekoppelt (10,5 x 22 Einheiten).
#define PH_X(n) (safezoneX + safezoneW / 2 - (5.25 - (n)) * GUI_GRID_CENTER_W)
#define PH_Y(n) (safezoneY + safezoneH - (23.2 - (n)) * GUI_GRID_CENTER_H)
#define PH_W(n) ((n) * GUI_GRID_CENTER_W)
#define PH_H(n) ((n) * GUI_GRID_CENTER_H)
#define PH_FONT(n) (GUI_GRID_CENTER_H * (n))

/* ---------- Rahmen ---------- */
class Life_RscPhoneBezel : Life_RscText {
    idc = -1;
    x = PH_X(0);
    y = PH_Y(0);
    w = PH_W(10.5);
    h = PH_H(22);
    colorBackground[] = {0.03, 0.03, 0.04, 1};
};
class Life_RscPhoneScreen : Life_RscText {
    idc = -1;
    x = PH_X(0.3);
    y = PH_Y(0.45);
    w = PH_W(9.9);
    h = PH_H(20.9);
    colorBackground[] = {0.10, 0.11, 0.14, 0.98};
};
class Life_RscPhoneStatusClock : Life_RscText {
    idc = 2098;
    text = "";
    x = PH_X(0.6);
    y = PH_Y(0.45);
    w = PH_W(4);
    h = PH_H(0.75);
    sizeEx = PH_FONT(0.7);
    colorText[] = {0.85, 0.86, 0.9, 1};
};
class Life_RscPhoneStatusName : Life_RscPhoneStatusClock {
    idc = 2097;
    style = 1;
    x = PH_X(4.6);
    w = PH_W(5.3);
};

/* ---------- App-Leiste ---------- */
class Life_RscPhoneAppBar : Life_RscText {
    idc = -1;
    x = PH_X(0.3);
    y = PH_Y(1.3);
    w = PH_W(9.9);
    h = PH_H(1.2);
    colorBackground[] = {0.16, 0.17, 0.21, 1};
};
class Life_RscPhoneAppTitle : Life_RscText {
    idc = -1;
    x = PH_X(0.6);
    y = PH_Y(1.3);
    w = PH_W(6.6);
    h = PH_H(1.2);
    sizeEx = PH_FONT(1.0);
    colorText[] = {0.97, 0.97, 0.97, 1};
};

/* ---------- Buttons ---------- */
class Life_RscPhoneButton {
    type = 1;
    style = 2;
    idc = -1;
    default = 0;
    shadow = 0;
    x = PH_X(0.6);
    y = PH_Y(2.8);
    w = PH_W(9.3);
    h = PH_H(1.1);
    text = "";
    font = "RobotoCondensed";
    sizeEx = PH_FONT(0.9);
    colorText[] = {1, 1, 1, 1};
    colorDisabled[] = {0.55, 0.56, 0.6, 1};
    colorBackground[] = {0.24, 0.52, 0.88, 0.95};
    colorBackgroundActive[] = {0.33, 0.62, 0.98, 1};
    colorBackgroundDisabled[] = {0.19, 0.20, 0.24, 1};
    colorFocused[] = {0.24, 0.52, 0.88, 0.95};
    colorShadow[] = {0, 0, 0, 0};
    colorBorder[] = {0, 0, 0, 0};
    borderSize = 0;
    offsetX = 0;
    offsetY = 0;
    offsetPressedX = 0;
    offsetPressedY = 0;
    soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter", 0.09, 1};
    soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush", 0.09, 1};
    soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick", 0.09, 1};
    soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape", 0.09, 1};
    tooltipColorText[] = {1, 1, 1, 1};
    tooltipColorBox[] = {1, 1, 1, 1};
    tooltipColorShade[] = {0, 0, 0, 0.65};
};
class Life_RscPhoneButtonAlt : Life_RscPhoneButton {
    colorBackground[] = {0.30, 0.32, 0.38, 0.95};
    colorBackgroundActive[] = {0.40, 0.42, 0.50, 1};
    colorFocused[] = {0.30, 0.32, 0.38, 0.95};
};
class Life_RscPhoneButtonDanger : Life_RscPhoneButton {
    colorBackground[] = {0.70, 0.24, 0.26, 0.95};
    colorBackgroundActive[] = {0.84, 0.33, 0.35, 1};
    colorFocused[] = {0.70, 0.24, 0.26, 0.95};
};
class Life_RscPhoneBack : Life_RscPhoneButtonAlt {
    x = PH_X(7.4);
    y = PH_Y(1.45);
    w = PH_W(2.5);
    h = PH_H(0.9);
    text = "$STR_PM_Back";
    sizeEx = PH_FONT(0.8);
};

/* ---------- App-Kacheln (Startbildschirm) ---------- */
//Die vier Reihen fuellen den Bildschirm bis kurz ueber die Leiste - vorher blieb unten ein
//Drittel leer. Reihenabstand in player_inv.hpp: 4.8 / 8.55 / 12.3 / 16.05.
class Life_RscPhoneTile : Life_RscPhoneButton {
    w = PH_W(2.9);
    h = PH_H(3.4);
    sizeEx = PH_FONT(0.85);
};
class Life_RscPhoneTileTeal : Life_RscPhoneTile {
    colorBackground[] = {0.16, 0.55, 0.52, 0.95};
    colorBackgroundActive[] = {0.22, 0.68, 0.64, 1};
    colorFocused[] = {0.16, 0.55, 0.52, 0.95};
};
class Life_RscPhoneTileBlue : Life_RscPhoneTile {
    colorBackground[] = {0.25, 0.45, 0.80, 0.95};
    colorBackgroundActive[] = {0.33, 0.56, 0.92, 1};
    colorFocused[] = {0.25, 0.45, 0.80, 0.95};
};
class Life_RscPhoneTileGreen : Life_RscPhoneTile {
    colorBackground[] = {0.22, 0.60, 0.32, 0.95};
    colorBackgroundActive[] = {0.30, 0.72, 0.42, 1};
    colorFocused[] = {0.22, 0.60, 0.32, 0.95};
};
class Life_RscPhoneTileOrange : Life_RscPhoneTile {
    colorBackground[] = {0.85, 0.55, 0.15, 0.95};
    colorBackgroundActive[] = {0.95, 0.66, 0.25, 1};
    colorFocused[] = {0.85, 0.55, 0.15, 0.95};
};
class Life_RscPhoneTileCyan : Life_RscPhoneTile {
    colorBackground[] = {0.20, 0.62, 0.78, 0.95};
    colorBackgroundActive[] = {0.28, 0.74, 0.90, 1};
    colorFocused[] = {0.20, 0.62, 0.78, 0.95};
};
class Life_RscPhoneTileGrey : Life_RscPhoneTile {
    colorBackground[] = {0.42, 0.44, 0.50, 0.95};
    colorBackgroundActive[] = {0.52, 0.54, 0.60, 1};
    colorFocused[] = {0.42, 0.44, 0.50, 0.95};
};
class Life_RscPhoneTileRed : Life_RscPhoneTile {
    colorBackground[] = {0.72, 0.24, 0.26, 0.95};
    colorBackgroundActive[] = {0.84, 0.33, 0.35, 1};
    colorFocused[] = {0.72, 0.24, 0.26, 0.95};
};
class Life_RscPhoneTileIndigo : Life_RscPhoneTile {
    colorBackground[] = {0.28, 0.32, 0.72, 0.95};
    colorBackgroundActive[] = {0.38, 0.42, 0.84, 1};
    colorFocused[] = {0.28, 0.32, 0.72, 0.95};
};
class Life_RscPhoneTileMagenta : Life_RscPhoneTile {
    colorBackground[] = {0.72, 0.22, 0.55, 0.95};
    colorBackgroundActive[] = {0.84, 0.32, 0.66, 1};
    colorFocused[] = {0.72, 0.22, 0.55, 0.95};
};
class Life_RscPhoneTileGold : Life_RscPhoneTile {
    colorBackground[] = {0.78, 0.62, 0.12, 0.95};
    colorBackgroundActive[] = {0.90, 0.74, 0.20, 1};
    colorFocused[] = {0.78, 0.62, 0.12, 0.95};
};
class Life_RscPhoneTileNavy : Life_RscPhoneTile {
    colorBackground[] = {0.20, 0.36, 0.64, 0.95};
    colorBackgroundActive[] = {0.28, 0.46, 0.78, 1};
    colorFocused[] = {0.20, 0.36, 0.64, 0.95};
};
class Life_RscPhoneTileOlive : Life_RscPhoneTile {
    colorBackground[] = {0.45, 0.56, 0.24, 0.95};
    colorBackgroundActive[] = {0.55, 0.68, 0.32, 1};
    colorFocused[] = {0.45, 0.56, 0.24, 0.95};
};
class Life_RscPhoneTilePurple : Life_RscPhoneTile {
    colorBackground[] = {0.48, 0.36, 0.74, 0.95};
    colorBackgroundActive[] = {0.58, 0.46, 0.86, 1};
    colorFocused[] = {0.48, 0.36, 0.74, 0.95};
};

/* ---------- Inhalte ---------- */
class Life_RscPhoneTileSteel : Life_RscPhoneTile {
    colorBackground[] = {0.36, 0.44, 0.56, 0.95};
    colorBackgroundActive[] = {0.46, 0.55, 0.68, 1};
    colorFocused[] = {0.36, 0.44, 0.56, 0.95};
};
class Life_RscPhoneLabel : Life_RscText {
    idc = -1;
    x = PH_X(0.6);
    w = PH_W(9.3);
    h = PH_H(0.9);
    sizeEx = PH_FONT(0.8);
    colorText[] = {0.78, 0.80, 0.85, 1};
};
class Life_RscPhoneCard : Life_RscText {
    idc = -1;
    x = PH_X(0.6);
    w = PH_W(9.3);
    colorBackground[] = {0.16, 0.17, 0.21, 1};
};
class Life_RscPhoneList : Life_RscListBox {
    x = PH_X(0.6);
    w = PH_W(9.3);
    sizeEx = PH_FONT(0.85);
    rowHeight = PH_H(1);
    colorBackground[] = {0.16, 0.17, 0.21, 1};
    colorSelectBackground[] = {0.24, 0.52, 0.88, 0.7};
    colorSelectBackground2[] = {0.24, 0.52, 0.88, 0.7};
};
class Life_RscPhoneCombo : Life_RscCombo {
    x = PH_X(3.7);
    w = PH_W(6.2);
    h = PH_H(0.9);
    sizeEx = PH_FONT(0.85);
    colorBackground[] = {0.16, 0.17, 0.21, 1};
};
class Life_RscPhoneEdit : Life_RscEdit {
    x = PH_X(3.7);
    w = PH_W(6.2);
    h = PH_H(0.9);
    sizeEx = PH_FONT(0.85);
    colorBackground[] = {0.16, 0.17, 0.21, 1};
};
class Life_RscPhoneStructured : Life_RscStructuredText {
    idc = -1;
    x = PH_X(0.6);
    w = PH_W(9.3);
    size = PH_FONT(0.85);
};

/*
    PHONE_FRAME       -> in "class controlsBackground" einfuegen (Gehaeuse, Bildschirm, Statusleiste)
    PHONE_APPBAR(...) -> in "class controls" einfuegen (Titelleiste mit Zurueck-Button)
                         Argumente: IDC des Titels, Titeltext, Code des Zurueck-Buttons.
                         Achtung: Argumente duerfen keine Kommas enthalten.
*/
#define PHONE_FRAME \
    class PhoneBezel : Life_RscPhoneBezel {}; \
    class PhoneScreen : Life_RscPhoneScreen {}; \
    class PhoneStatusClock : Life_RscPhoneStatusClock {}; \
    class PhoneStatusName : Life_RscPhoneStatusName {};
/* Feste Leiste unten: Speichern links, Zurueck rechts - beide nur mit Symbol, wie die
   Navigationsleiste eines Telefons.

   Einen eigenen Home-Knopf gibt es nicht mehr: Zurueck geht eine Ebene hoch, und wenn nichts mehr
   da ist, macht es life_fnc_p_back selbst wie Home - auf der Startseite also schliessen. Zwei
   Knoepfe fuer denselben Weg waren doppelt.

   Die Symbole liegen im Spiel selbst (ui_f_data.pbo), es braucht also keine neuen Dateien im
   Addon. Sie liegen als Bildfelder ueber den Knoepfen; ein Bildfeld faengt keine Klicks ab,
   der Knopf darunter bekommt sie. */
#define PHONE_ICON_SAVE "\a3\ui_f\data\gui\rsc\rscdisplayarcademap\icon_save_ca.paa"
#define PHONE_ICON_BACK "\a3\ui_f\data\gui\rsccommon\rschtml\arrow_left_ca.paa"
class Life_RscPhoneNavSave : Life_RscPhoneButtonAlt {
    x = PH_X(0.6);
    y = PH_Y(20.05);
    w = PH_W(4.25);
    h = PH_H(1.2);
    text = "";
    tooltip = "$STR_PM_App_Sync";
    onButtonClick = "[] call SOCK_fnc_syncData;";
};
class Life_RscPhoneNavBack : Life_RscPhoneNavSave {
    x = PH_X(5.65);
    tooltip = "$STR_PM_Nav_Back";
    onButtonClick = "[] call life_fnc_p_back;";
};
class Life_RscPhoneNavIcon : Life_RscPicture {
    idc = -1;
    y = PH_Y(20.25);
    w = PH_W(0.8);
    h = PH_H(0.8);
};
#define PHONE_NAVBAR \
    class PhoneNavSave : Life_RscPhoneNavSave {}; \
    class PhoneNavBack : Life_RscPhoneNavBack {}; \
    class PhoneNavSaveIcon : Life_RscPhoneNavIcon { x = PH_X(2.325); text = PHONE_ICON_SAVE; }; \
    class PhoneNavBackIcon : Life_RscPhoneNavIcon { x = PH_X(7.375); text = PHONE_ICON_BACK; };
//BACKCODE bleibt als Parameter erhalten, damit die Dialoge unveraendert bleiben; zurueck geht
//es seit der festen Leiste unten ueber life_fnc_p_back.
#define PHONE_APPBAR(TITLEIDC,TITLETEXT,BACKCODE) \
    class PhoneAppBar : Life_RscPhoneAppBar {}; \
    class PhoneAppTitle : Life_RscPhoneAppTitle { idc = TITLEIDC; text = TITLETEXT; };
