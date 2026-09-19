/*
    File: Config_Inventory.hpp
    Description:
    Einstellungen fuer den Inventar-Umbau (Server fuehrt die virtuellen Inventare), Konzept:
    docs/INVENTORY_AUTHORITY.md. Der Modus selbst steht in description.ext unter
    CfgServer >> InventoryMode.

    Paket 1 (Schattenmodus): Jede Aenderung ueber life_fnc_handleInv meldet der Client an den Server
    (TON_fnc_invTrack), zusaetzlich fragt der Server regelmaessig die vollstaendige Liste ab
    (TON_fnc_invSync -> life_fnc_invReport). Weicht sie ab, steht das als [INVENTORY] im Server-RPT.
    Nichts davon aendert das Spiel, es zeigt nur, was noch nicht meldet und wer schummelt.
*/
class CfgInventory {
    //Welches Objekt in der Welt welchen Gegenstand gibt (Angeln, Tiere ausnehmen). Der Server
    //loescht das Objekt selbst, damit niemand dasselbe Tier zweimal ausnimmt.
    harvest[] = {
        {"Salema_F","salema_raw"}, {"Ornate_random_F","ornate_raw"}, {"Mackerel_F","mackerel_raw"},
        {"Tuna_F","tuna_raw"}, {"Mullet_F","mullet_raw"}, {"CatShark_F","catshark_raw"},
        {"Turtle_F","turtle_raw"}, {"Hen_random_F","hen_raw"}, {"Cock_random_F","rooster_raw"},
        {"Goat_random_F","goat_raw"}, {"Sheep_random_F","sheep_raw"}, {"Rabbit_F","rabbit_raw"},
        {"Land_Razorwire_F","spikeStrip"}
    };
    //Erlaubte Umwandlungen eines Gegenstands in einen anderen (Benzinkanister voll <-> leer)
    convert[] = { {"fuelFull","fuelEmpty"}, {"fuelEmpty","fuelFull"} };
    syncInterval = 120;   // Sekunden zwischen zwei Vollabgleichen je Spieler (unter 10 = aus)
    warnSeconds = 300;    // fruehestens nach so vielen Sekunden wieder eine [INVENTORY]-Zeile je Spieler
    summaryCycles = 5;    // nach so vielen Abgleichen eine Zusammenfassung ins Log, auch wenn nichts
                          // abweicht (0 = aus). Ohne sie heisst Stille im Log nur "nichts geloggt" -
                          // nicht "geprueft und sauber", und genau das muss vor Modus 2 belegt sein.
};
