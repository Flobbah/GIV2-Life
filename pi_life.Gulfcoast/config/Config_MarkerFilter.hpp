/*
    Kategorien fuer den Karten-Marker-Filter (Telefon-App "Karte").
    markers[] enthaelt Marker-Namen aus der mission.sqm. Ein "*" am Ende steht fuer
    "beginnt mit" (Gross-/Kleinschreibung egal), damit neue Marker mit passendem Namen
    automatisch in die richtige Kategorie fallen. Marker, die in keiner Kategorie stehen,
    bleiben immer sichtbar. Die ersten acht Kategorien werden im Telefon angezeigt.
    Logik: core\pmenu\fn_markerFilterApply.sqf
*/
class CfgMarkerFilter {
    class shops {
        displayName = "STR_MF_Shops";
        markers[] = { "Gen", "Gen_*", "fish_market_*", "dive_shop*", "gun_store_*", "7News_*" };
    };
    class vehicles {
        displayName = "STR_MF_Vehicles";
        markers[] = { "Carshop", "car_*", "car1_*", "civ_truck_shop_*", "truck_*", "boat_*", "airshop_*", "air_serv_*", "civ_gar_*" };
    };
    class authorities {
        displayName = "STR_MF_Authorities";
        markers[] = { "license_shop*", "police_hq_*", "cop_spawn_*", "Correctional_Facility", "CG", "hospital_*" };
    };
    class banks {
        displayName = "STR_MF_Banks";
        markers[] = { "atm", "atm_*", "bank_*", "fed_reserve", "lbank" };
    };
    class resources {
        displayName = "STR_MF_Resources";
        markers[] = { "copper_mine", "diamond_mine", "iron_mine", "oil_field_*", "rock_quarry", "salt_mine", "sand_mine", "apple_*", "peaches_*", "hunting_marker", "hunting_zone" };
    };
    class processing {
        displayName = "STR_MF_Processing";
        markers[] = { "copper_processing*", "diamond_processing", "iron_processing", "oil_processing", "rock_processing", "salt_processing", "sand_processing", "diamond_trader", "glass_trader", "iron_copper_trader", "oil_trader_*", "salt_trader" };
    };
    class illegal {
        displayName = "STR_MF_Illegal";
        markers[] = { "cocaine_*", "cocaine processing", "coke_area", "weed_*", "heroin_*", "Dealer_*", "Rebelop*", "gang_area_*", "chop_shop_*", "turle_dealer*", "turtle_*", "gold_bar_dealer" };
    };
    class delivery {
        displayName = "STR_MF_Delivery";
        markers[] = { "dp_*" };
    };
};
