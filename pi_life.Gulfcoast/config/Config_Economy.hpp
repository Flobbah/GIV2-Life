/*
    File: Config_Economy.hpp
    Description:
    Einstellungen fuer den Geld-Umbau (Server fuehrt alle Kontostaende), Konzept: docs/ECONOMY_AUTHORITY.md.
    Der Modus selbst steht in description.ext unter CfgServer >> EconomyMode.

    Schritt 1 (Schattenmodus): Der Server laedt die Kontostaende beim Login, vergleicht jede Speicherung
    des Clients damit und schreibt jede Aenderung ins Transaktionslog (Tabelle money_transactions,
    Migration sql/migrations/2026-09-16_001_money_transactions.sql). Grosse Spruenge und negative
    Kontostaende stehen als [ECONOMY] im Server-RPT.
*/
class CfgEconomy {
    shadowWarnCash = 100000;    // Warnung, wenn Bargeld mit einer Speicherung um mindestens diesen Betrag steigt
    shadowWarnBank = 250000;    // Warnung, wenn das Konto mit einer Speicherung um mindestens diesen Betrag steigt
    transactionRetentionDays = 90; // Aeltere Eintraege im Transaktionslog loescht der Server beim Start (0 = nie)
    adminViewLevel = 3;         // Adminlevel, ab dem das Transaktionslog im Spiel einsehbar ist (spaeterer Schritt)
    //Gehalt (Schritt 2): zahlt der Server. Polizei nach Rang 1-13, ohne Rang Life_Settings >> paycheck_cop
    paycheckCopByRank[] = {900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000, 2100};
    paycheckFedReserveBonus = 1500; // Zuschlag fuer Polizisten, die beim Gehalt naeher als 120 m an der Federal Reserve sind
    //Justiz (Schritt 2, Paket 2)
    ticketMax = 25000;          // hoechster Strafzettel
    ticketValidSeconds = 600;   // so lange kann ein ausgestellter Strafzettel bezahlt werden
    bountyCooldown = 900;       // Sekunden, in denen fuer denselben Gesuchten kein zweites Kopfgeld ausgezahlt wird
    robCooldown = 300;          // Sekunden, in denen dieselbe Person nicht erneut ausgeraubt werden kann
    //Raubueberfaelle (Schritt 2, Paket 4b). Tankstelle: Beute, Abstaende und Pause in Config_RobFuelStations.hpp
    gasRobDuration = 150;       // Sekunden, die ein Tankstellenraub dauert (Fortschrittsbalken 100 x 1,5 s)
    bankRobDuration = 1200;     // Sekunden, die ein Bankraub dauert (Fortschrittsbalken 100 x 12 s)
    bankRobCooldown = 1800;     // Sekunden, bis dieselbe Bank wieder ausgeraubt werden kann
    bankRobMinCops = 4;         // Polizisten, die mindestens im Dienst sein muessen
    bankRobFailChance = 50;     // Prozent Chance, dass der Hackversuch sofort scheitert
    bankLootMin = 60000;        // Beute: Grundbetrag
    bankLootRandom = 60000;     // Beute: zufaelliger Zuschlag bis zu diesem Betrag
};
