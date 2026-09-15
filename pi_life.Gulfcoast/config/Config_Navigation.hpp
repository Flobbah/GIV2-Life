/*
    File: Config_Navigation.hpp
    Description:
    Einstellungen der Navi-Minikarte. Sie erscheint automatisch, sobald eine Route aktiv ist
    (auch ohne GPS-Gegenstand), und verschwindet mit dem Ende der Navigation.
    Fahrtrichtung oben: Die Karte wird NICHT von der Engine gedreht (mapOrientation fuehrte am
    2026-09-15 zu einem Speicherueberlauf mit Absturz). Stattdessen zeigt ein normales, nicht
    gedrehtes Kartensteuerelement auf eine leere Stelle der Welt, und das Skript zeichnet dort
    Strassen, Route, Ziel und Pfeil selbst, um den Spieler gedreht (drawTriangle + matrixMultiply).
    Logik: core\navigation\fn_navMiniMap*.sqf
*/
class CfgNavigation {
    class MiniMap {
        enabled = 1;          // 0 = keine Minikarte
        right = 0.995;        // rechte Kante als Anteil der Bildschirmbreite (0 = links, 1 = rechts)
        bottom = 0.725;       // untere Kante als Anteil der Bildschirmhoehe (ueber den Lebensbalken)
        size = 0.135;         // Breite als Anteil der Bildschirmbreite; die Karte ist quadratisch
        spanSlow = 260;       // sichtbare Breite in Metern im Stand und langsam
        spanFast = 750;       // sichtbare Breite in Metern ab speedFast
        speedFast = 120;      // km/h, ab denen voll herausgezoomt ist
        lookAhead = 0.25;     // Anteil der sichtbaren Breite, um den die Karte vorausschaut (Pfeil unterhalb der Mitte)
        // Farben (RGBA 0..1) und Mindestbreiten der Linien in Bildschirmpixeln
        colorBackground[] = {0.10, 0.11, 0.13, 1};
        colorTrack[] = {0.25, 0.27, 0.31, 1};
        colorRoad[] = {0.40, 0.43, 0.48, 1};
        colorMainRoad[] = {0.60, 0.62, 0.67, 1};
        colorRouteOutline[] = {0.02, 0.10, 0.30, 1};
        colorRoute[] = {0.20, 0.62, 1, 1};
        minPixelsTrack = 1.5;
        minPixelsRoad = 2.5;
        minPixelsMainRoad = 3.5;
        pixelsRoute = 5;
        pixelsRouteOutline = 8;
    };
};
