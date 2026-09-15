/*
    Erfahrungs- und Skill-System (Telefon-App "Skills").
    xpLevels[]     - kumulative Erfahrungspunkte fuer Stufe 1..5 (5 Eintraege = 5 Stufen)
    saveInterval   - Sekunden zwischen Speicherungen in der Datenbank (Spalte players.skills)
    Je Skill:
        displayName / description - Stringtable-Schluessel (description bekommt %1 = Bonus, %2 = Bonus2)
        xpPerAction     - Erfahrung je Aktion (Abbauvorgang, Reparatur, Schloss)
        xpPerItem       - Erfahrung je verarbeitetem Stueck (Verarbeitung)
        xpPerWeight     - Erfahrung je verkaufter Gewichtseinheit (Tragkraft)
        bonusPerLevel   - Bonus je Stufe (Prozent bzw. Gewichtseinheiten, siehe Beschreibung)
        bonus2PerLevel  - zweiter Bonus je Stufe (nur Dietrich: Prozentpunkte Erfolgschance)
    Richtwert Casual: ~13 s je Abbauvorgang -> Stufe 5 Abbau nach rund 3,5 Stunden reinem Abbauen.
    Logik: core\skills\fn_skill*.sqf, Hooks in gather/mine/processAction/lockpick/repairTruck/virt_sell.
*/
class CfgSkills {
    xpLevels[] = { 40, 120, 280, 550, 950 };
    saveInterval = 30;
    class gather {
        displayName = "STR_SK_Gather";
        description = "STR_SK_GatherDesc";
        xpPerAction = 1;
        bonusPerLevel = 10;   // % mehr Ertrag je Abbau-/Erntevorgang
        bonus2PerLevel = 0;
    };
    class carry {
        displayName = "STR_SK_Carry";
        description = "STR_SK_CarryDesc";
        xpPerAction = 0;      // nicht je Vorgang (waere durch Einzelverkauf ausnutzbar), sondern:
        xpPerWeight = 0.1;    // XP je verkaufter Gewichtseinheit (Zil-Ladung Kupfer = 150 Gewicht = 15 XP)
        bonusPerLevel = 3;    // zusaetzliche Tragkraft (Gewichtseinheiten)
        bonus2PerLevel = 0;
    };
    class process {
        displayName = "STR_SK_Process";
        description = "STR_SK_ProcessDesc";
        xpPerAction = 0;      // nicht je Vorgang (waere durch Einzelverarbeitung ausnutzbar), sondern:
        xpPerItem = 0.3;      // XP je verarbeitetem Stueck (Zil-Ladung 50 Stueck = 15 XP)
        bonusPerLevel = 8;    // % kuerzere Verarbeitungszeit
        bonus2PerLevel = 0;
    };
    class lockpick {
        displayName = "STR_SK_Lockpick";
        description = "STR_SK_LockpickDesc";
        xpPerAction = 3;      // erfolgreicher Versuch (Fehlschlag gibt 1)
        bonusPerLevel = 8;    // % kuerzere Knackzeit
        bonus2PerLevel = 4;   // Prozentpunkte mehr Erfolgschance (Basis 30 %)
    };
    class repair {
        displayName = "STR_SK_Repair";
        description = "STR_SK_RepairDesc";
        xpPerAction = 3;
        bonusPerLevel = 10;   // % kuerzere Reparaturzeit
        bonus2PerLevel = 0;
    };
};
