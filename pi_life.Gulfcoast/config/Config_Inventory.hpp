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
    syncInterval = 120;   // Sekunden zwischen zwei Vollabgleichen je Spieler (unter 10 = aus)
    warnSeconds = 300;    // fruehestens nach so vielen Sekunden wieder eine [INVENTORY]-Zeile je Spieler
};
