/*
    File: Config_Placement.hpp
    Description:
    Einstellungen fuer das freie Abstellen von Fahrzeugen (Garage und Fahrzeughaendler).
    Statt fester Spawnmarker stellt der Spieler das Fahrzeug selbst ab: Eine lokale Vorschau folgt
    seinem Blick, ist gruen (Platz frei) oder rot (blockiert) und wird erst beim Bestaetigen echt.
    Logik: core\placement\fn_placement*.sqf
*/
class CfgVehiclePlacement {
    maxDistanceCar = 20;      // Meter vom Spieler bis zur Fahrzeugmitte (Autos, Motorraeder, LKW)
    maxDistanceAir = 35;      // Hubschrauber und Flugzeuge
    maxDistanceShip = 40;     // Boote
    maxDistanceStart = 50;    // so weit darf man sich waehrend des Abstellens vom Startpunkt entfernen
    maxHeightDiff = 6;        // Hoehenunterschied Spieler / Abstellflaeche (verhindert Daecher und Bruecken von unten)
    maxSlope = 20;            // groesste Neigung in Grad fuer Land- und Wasserfahrzeuge
    maxSlopeAir = 12;         // groesste Neigung in Grad fuer Luftfahrzeuge
    minWaterDepth = 1.2;      // Mindest-Wassertiefe in Metern unter der Bootsmitte (an den Ecken die Haelfte)
    clearance = 0.25;         // Sicherheitsabstand in Metern rund um das Fahrzeug
    rotateStep = 5;           // Grad je Tastendruck (Q/E) bzw. Mausrad-Raste
    rotateStepFine = 1;       // Grad je Tastendruck mit gedrueckter Umschalttaste
    ghostAlpha = 0.45;        // Deckkraft der Einfaerbung der Vorschau (0 = unsichtbar, 1 = deckend)
    colorFree[] = {0.30, 0.85, 0.45};     // Farbe fuer "Platz frei" (RGB 0..1)
    colorBlocked[] = {0.95, 0.30, 0.25};  // Farbe fuer "blockiert"
    timeout = 180;            // Sekunden, nach denen das Abstellen automatisch abgebrochen wird
};
