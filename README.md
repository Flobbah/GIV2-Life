# Gulfcoast Island V2 Life (GIV2 Life):
  - Mapswap to Gulfcoast Island V2
  - Modded server/client is required
  - Mission is modified:
   - like Spyglass was removed
   - taser bug fixed
   - welcomenotification removed
   - textures and sounds outsourced to mod to minimize mission size
   - removed public cop slots
   - implemented CH_BrightNights
   - Added take all/store all from trunk script by "Basti | John Collins" aka DevB
   - Added New Hud by "Kureo & Zalac"
   - Added Rob Gas Stations script by "Moeck" edited by Deathman and me. Added Strings so it's in english and german.
   - DE100 Notification System added
   - Added Bankrobbery script by "cmdFlow" edited by "DevB" and me.
   - Added Bandages as vItems by "ToxicRageTv" edited by me.
   - Added Sell All button by "Basti | John Collins" edited by me.
   - Barrier System by "Blackfisch" (Native Servers) - Open Menu "Ö/;" | Place Barrier "Spacebar" | Abort Placing Barrier "ESC" | Delete placeable in front of player "DEL"
   - Smartphone-style player menu (Z) with app tiles; every app is sized to the phone
   - Economy rebalanced for casual play (license, vehicle and weapon prices, item payouts, paychecks)
   - Paychecks and broadcasts shown via the notification system
   - Map marker filter app with 8 categories (saved in the player profile)
   - Navigation: road routes with a line on the map and GPS, automatic route for delivery missions, navi app with search, heading-up minimap
   - Skill system: gathering, carrying, processing, lockpicking and repairing, 5 levels each (XP scales with quantity)
   - Go on/off duty as police or EMS in-game without the lobby; money is shared, gear, licenses and keys are kept per faction
   - Free vehicle placement for garages, vehicle shops and admin spawn (green/red ghost preview instead of spawn markers)
   - Admin menu: manage players (licenses, cop/medic rank) and a vehicle spawn menu
  - Mod collection on steam: https://steamcommunity.com/sharedfiles/filedetails/?id=3426226140

[![|Solid](https://i.imgur.com/5PFRHRN.png)](https://steamcommunity.com/sharedfiles/filedetails/?id=3426226140)

# Setup
  - Database: import `altislife.sql`. The extDB3 section in `extdb3-conf.ini` must be named `[altislife]`
    (`DatabaseName` in `description.ext`); the section can point to any database name.
  - Updating an existing database from an older GIV2 version: add the skills column once
    ```sql
    ALTER TABLE `players` ADD COLUMN `skills` VARCHAR(512) NOT NULL DEFAULT '"[]"';
    ```
  - Community name: change it once in `pi_life.Gulfcoast/config/Config_Community.hpp`
    (lobby, server list and loading screen; scripts use `COMMUNITY_NAME_TEXT`).
  - New garage without spawn markers, in the object's init field:
    `[this, "Car", west] call life_fnc_garageInit;` (`"Car"`, `"Air"` or `"Ship"`; side is optional).
  - Feature settings: `config/Config_Skills.hpp`, `Config_Duty.hpp`, `Config_Placement.hpp`,
    `Config_Navigation.hpp`, `Config_MarkerFilter.hpp`.

# Fixed some minor issues
  - Fixed Cop/Medic Spawn/Init
  - Fixed Cop access for Police buildings

# Pictures
  - HUD

![HUD](https://i.imgur.com/GLtyaUG.png)

  - Trunk Dialog

![TrunkDialog](https://i.imgur.com/olKkPry.png)

  - View at night (CH_BrightNights)
![BrightNights](https://i.imgur.com/XgM1kTk.jpeg)

# Altis Life Framework 5.X.X
[![|Solid](http://i.imgur.com/pL3heId.png)](https://github.com/AsYetUntitled/Framework/)

AsYetUntitled, formerly <b>Altis Life RPG</b> and <b>ARMARPGLIFE</b> is a roleplay framework for ArmA III originally made by <b>TAW_Tonic</b>.

This Github is not currently associated with any forums.

![Validation](https://github.com/AsYetUntitled/Framework/workflows/Validation/badge.svg?branch=v5.X.X)

# Features:

  - Police, Civ and Medic roles
  - Banking System
  - Virtual Item system
  - Vitem shops, vehicle shops, weapon shops, clothing stores etc.
  - Housing System
  - Persistent wanted system
  - Many more.

# License:
Altis Life RPG by AsYetUntitled is licensed under a [Creative Commons Attribution-NonCommercial-NoDerivs 4.0 International License](http://creativecommons.org/licenses/by-nc-nd/4.0/deed.en_US)

# Links:
  - Discord: https://discord.gg/ajGUDSH
  - Forums: TBD
  - Wiki: https://github.com/AsYetUntitled/Framework/wiki
  - Releases (Stable Builds): https://github.com/AsYetUntitled/Framework/releases

<p align="center">
    <a href="https://discord.gg/ajGUDSH">
        <img src="https://img.shields.io/badge/Discord-Join%20chat%20→-738bd7.svg" alt="Join the chat at https://discord.gg/ajGUDSH">
    </a>
</p>
