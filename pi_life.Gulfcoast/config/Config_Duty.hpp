/*
    File: Config_Duty.hpp
    Description:
    Einstellungen fuer "In den Dienst gehen" ohne Lobby (Telefon-App "Dienst").
    Ein Spieler wechselt im Spiel zwischen Zivilist, Polizei (west) und Rettungsdienst (independent).
    Die Fraktion wird intern als life_side gefuehrt, Ausruestung, Lizenzen und Fahrzeugschluessel
    kommen je Fraktion aus der Datenbank, Geld ist ohnehin pro Spieler gespeichert.
    Dienststellen sind die Spawnpunkte der jeweiligen Seite aus CfgSpawnPoints (Polizeiwachen,
    Krankenhaeuser); zusaetzliche Marker koennen je Seite eingetragen werden.
*/
class CfgDuty {
    radius = 75;      // Abstand in Metern zur Dienststelle, innerhalb dessen ein Wechsel moeglich ist
    cooldown = 60;    // Sekunden Wartezeit zwischen zwei Wechseln (gibt der Datenbank Zeit zum Speichern)
    allowAdmin = 1;   // 1 = Adminlevel >= 1 darf wie in der Lobby auch ohne Rang in den Dienst
    class west {
        extraMarkers[] = {};    // weitere Marker, an denen man in den Polizeidienst gehen kann
    };
    class independent {
        extraMarkers[] = {};    // weitere Marker fuer den Rettungsdienst
    };
};
