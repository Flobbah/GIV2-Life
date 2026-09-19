/*
    File: shop.hpp
    Description:
    Gemeinsame Basis fuer alle Laden-Dialoge (Markt, Waffen, Kleidung, Fahrzeuge).
    Gleiche Bildsprache wie das Telefon in phone.hpp, nur als breite Theke statt als Geraet.

    Die Theke ist 28 Rastereinheiten breit und 19 hoch und sitzt mittig im Bild.
    Alle Positionen werden relativ zur linken oberen Ecke der Theke angegeben:
        SH_X(n) / SH_Y(n)  -> Bildschirmposition fuer die Laden-Koordinate n
        SH_W(n) / SH_H(n)  -> Breite / Hoehe in Rastereinheiten
        SH_FONT(n)         -> Schriftgroesse (1.0 = Standardgroesse der Life-Dialoge)

    Aufteilung:
        Titelleiste   y 0.0 .. 1.4   (Name des Ladens links, Geld rechts)
        Inhalt        y 1.8 .. 16.6
        Knopfleiste   y 17.1 .. 18.4
        Linke Spalte  x 0.6 .. 13.8, rechte Spalte x 14.2 .. 27.4

    Feste IDC in jedem Laden-Dialog: 9810 = Geldanzeige (life_fnc_shopStatus haelt sie aktuell).
*/
//Gerechnet wird ab der Mitte der Safezone, also ab dem echten Bild - GUI_GRID_CENTER_X/Y decken nur
//eine zentrierte Box ab, die auf breiten Bildschirmen deutlich schmaler ist (siehe phone.hpp).
#define SH_X(n) (safezoneX + safezoneW / 2 - (14 - (n)) * GUI_GRID_CENTER_W)
#define SH_Y(n) (safezoneY + safezoneH / 2 - (9.5 - (n)) * GUI_GRID_CENTER_H)
#define SH_W(n) ((n) * GUI_GRID_CENTER_W)
#define SH_H(n) ((n) * GUI_GRID_CENTER_H)
#define SH_FONT(n) (GUI_GRID_CENTER_H * (n))
//Fuer Laeden mit Vorschau in der Bildmitte (Fahrzeuge): Spalten an den Bildraendern statt mittig.
//SL_X haengt am linken Rand, SR_X am rechten; beide mit 0.6 Einheiten Abstand zum Rand.
#define SL_X(n) (safezoneX + (0.6 + (n)) * GUI_GRID_CENTER_W)
#define SR_X(n) (safezoneX + safezoneW - (13.6 - (n)) * GUI_GRID_CENTER_W)

/* ---------- Rahmen ---------- */
class Life_RscShopCard : Life_RscText {
    idc = -1;
    x = SH_X(0);
    y = SH_Y(0);
    w = SH_W(28);
    h = SH_H(19);
    colorBackground[] = {0.10, 0.11, 0.14, 0.98};
};
class Life_RscShopTitleBar : Life_RscText {
    idc = -1;
    x = SH_X(0);
    y = SH_Y(0);
    w = SH_W(28);
    h = SH_H(1.4);
    colorBackground[] = {0.16, 0.17, 0.21, 1};
};
class Life_RscShopTitle : Life_RscText {
    idc = -1;
    text = "";
    x = SH_X(0.6);
    y = SH_Y(0);
    w = SH_W(15);
    h = SH_H(1.4);
    sizeEx = SH_FONT(1.0);
    colorText[] = {0.97, 0.97, 0.97, 1};
};
//Konto und Bargeld rechts in der Titelleiste, mit denselben Symbolen wie im Telefon.
//life_fnc_shopStatus fuellt die Anzeige und haelt sie aktuell, solange der Laden offen ist.
class Life_RscShopMoney : Life_RscStructuredText {
    idc = 9810;
    text = "";
    x = SH_X(16);
    y = SH_Y(0.15);
    w = SH_W(11.4);
    h = SH_H(1.1);
    size = SH_FONT(0.9);
};

/* ---------- Inhalte ---------- */
class Life_RscShopLabel : Life_RscText {
    idc = -1;
    x = SH_X(0.6);
    w = SH_W(13.2);
    h = SH_H(0.9);
    sizeEx = SH_FONT(0.75);
    colorText[] = {0.78, 0.80, 0.85, 1};
};
class Life_RscShopPanel : Life_RscText {
    idc = -1;
    x = SH_X(0.6);
    w = SH_W(13.2);
    colorBackground[] = {0.16, 0.17, 0.21, 1};
};
class Life_RscShopList : Life_RscListBox {
    idc = -1;
    x = SH_X(0.6);
    w = SH_W(13.2);
    sizeEx = SH_FONT(0.85);
    rowHeight = SH_H(1);
    colorBackground[] = {0.16, 0.17, 0.21, 1};
    colorSelectBackground[] = {0.24, 0.52, 0.88, 0.7};
    colorSelectBackground2[] = {0.24, 0.52, 0.88, 0.7};
};
class Life_RscShopCombo : Life_RscCombo {
    idc = -1;
    x = SH_X(0.6);
    w = SH_W(13.2);
    h = SH_H(1);
    sizeEx = SH_FONT(0.85);
    colorBackground[] = {0.16, 0.17, 0.21, 1};
};
class Life_RscShopEdit : Life_RscEdit {
    idc = -1;
    x = SH_X(0.6);
    w = SH_W(13.2);
    h = SH_H(1);
    sizeEx = SH_FONT(0.85);
    colorBackground[] = {0.16, 0.17, 0.21, 1};
};
class Life_RscShopStructured : Life_RscStructuredText {
    idc = -1;
    x = SH_X(0.6);
    w = SH_W(13.2);
    size = SH_FONT(0.85);
};

/* ---------- Knoepfe ---------- */
class Life_RscShopButton {
    type = 1;
    style = 2;
    idc = -1;
    default = 0;
    shadow = 0;
    x = SH_X(0.6);
    y = SH_Y(17.1);
    w = SH_W(4.4);
    h = SH_H(1.3);
    text = "";
    font = "RobotoCondensed";
    sizeEx = SH_FONT(0.9);
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
//Verkaufen: gruen, damit Kaufen und Verkaufen nicht zu verwechseln sind.
class Life_RscShopButtonSell : Life_RscShopButton {
    colorBackground[] = {0.22, 0.60, 0.32, 0.95};
    colorBackgroundActive[] = {0.30, 0.72, 0.42, 1};
    colorFocused[] = {0.22, 0.60, 0.32, 0.95};
};
class Life_RscShopButtonAlt : Life_RscShopButton {
    colorBackground[] = {0.30, 0.32, 0.38, 0.95};
    colorBackgroundActive[] = {0.40, 0.42, 0.50, 1};
    colorFocused[] = {0.30, 0.32, 0.38, 0.95};
};
class Life_RscShopButtonDanger : Life_RscShopButton {
    colorBackground[] = {0.70, 0.24, 0.26, 0.95};
    colorBackgroundActive[] = {0.84, 0.33, 0.35, 1};
    colorFocused[] = {0.70, 0.24, 0.26, 0.95};
};
//Schliessen sitzt in jedem Laden an derselben Stelle: ganz rechts in der Knopfleiste.
class Life_RscShopClose : Life_RscShopButtonAlt {
    x = SH_X(23);
    text = "$STR_Global_Close";
    onButtonClick = "closeDialog 0;";
};

/* ---------- Schmale Theke ---------- */
//Im Kleiderladen steht die Spielfigur in der Bildmitte und muss sichtbar bleiben. Die schmale
//Theke ist deshalb nur 13 Einheiten breit und belegt die linke Haelfte des Laden-Bereichs
//(Koordinate 0 .. 13); die Figur rechts davon bleibt frei.
class Life_RscShopCardNarrow : Life_RscShopCard {
    w = SH_W(13);
};
class Life_RscShopTitleBarNarrow : Life_RscShopTitleBar {
    w = SH_W(13);
};
class Life_RscShopTitleNarrow : Life_RscShopTitle {
    w = SH_W(6);
};
class Life_RscShopMoneyNarrow : Life_RscShopMoney {
    x = SH_X(6.4);
    w = SH_W(6);
};
class Life_RscShopCloseNarrow : Life_RscShopClose {
    x = SH_X(8);
};

/*
    SHOP_FRAME(...)  -> in "class controlsBackground" einfuegen (Theke, Titelleiste, Geldanzeige)
                        Argumente: IDC des Titels, Titeltext.
                        Achtung: Argumente duerfen keine Kommas enthalten.
    SHOP_CLOSE       -> in "class controls" einfuegen, moeglichst als letzten Eintrag
                        (spaeter erklaerte Steuerelemente liegen oben und bekommen die Klicks).
    Dazu gehoert im Dialog: onLoad = "[_this select 0] call life_fnc_shopStatus;";
*/
#define SHOP_FRAME(TITLEIDC,TITLETEXT) \
    class ShopCard : Life_RscShopCard {}; \
    class ShopTitleBar : Life_RscShopTitleBar {}; \
    class ShopTitle : Life_RscShopTitle { idc = TITLEIDC; text = TITLETEXT; }; \
    class ShopMoney : Life_RscShopMoney {};
#define SHOP_CLOSE \
    class ShopClose : Life_RscShopClose {};
//Schmale Theke: gleiche Bedienung, halbe Breite (Kleiderladen)
#define SHOP_FRAME_NARROW(TITLEIDC,TITLETEXT) \
    class ShopCard : Life_RscShopCardNarrow {}; \
    class ShopTitleBar : Life_RscShopTitleBarNarrow {}; \
    class ShopTitle : Life_RscShopTitleNarrow { idc = TITLEIDC; text = TITLETEXT; }; \
    class ShopMoney : Life_RscShopMoneyNarrow {};
#define SHOP_CLOSE_NARROW \
    class ShopClose : Life_RscShopCloseNarrow {};
