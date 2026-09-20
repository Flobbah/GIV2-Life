-- =====================================================================
--  Migration 002 (2026-09-19): generic ownership (Phase 0.3 of docs/ROADMAP.md)
--
--  Run as root (or another user with CREATE rights) against your Life database, e.g.
--      mysql -u root -p altislife < 2026-09-19_002_asset_owners.sql
--  or select the database in phpMyAdmin and paste this into the SQL tab. Safe to run repeatedly.
--
--  WHY
--  Every asset table carries its own `pid` column today: vehicles.pid, houses.pid,
--  containers.pid. That shape can only ever express "exactly one player owns this". It cannot
--  express a gang-owned workshop, two players sharing a garage, a faction-owned building or an
--  employee who may use the till but not sell the shop - and all of Phase 2.3 and most of Phase 3
--  is built on exactly those cases.
--
--  WHAT
--  `asset_owners` is the one place that answers both questions: "who owns this?" and "what does
--  this owner have?". The asset keeps its own table (a vehicle still has fuel and a plate); only
--  the ownership moves out.
--
--  MIGRATION STRATEGY
--  Additive. The `pid` columns stay and keep being written, because the whole mission still reads
--  them. New code reads `asset_owners`, old code reads `pid`, and both are kept in sync until the
--  last reader is moved over. Only then do the columns go - in a later migration, with the data
--  already proven correct.
--
--  Without this migration the server keeps running exactly as before: the ownership functions log
--  "[OWNERSHIP] table asset_owners is missing" once and stay out of the way.
-- =====================================================================

CREATE TABLE IF NOT EXISTS `asset_owners` (
    `id`         INT UNSIGNED NOT NULL AUTO_INCREMENT,
    -- Was gehoert: Typ und die id in der jeweiligen Tabelle (vehicles.id, houses.id, ...).
    -- VARCHAR statt ENUM, damit ein neuer Typ (shop, workshop, gas_station) keine Schemaaenderung
    -- braucht - genau dafuer ist die Tabelle da.
    `asset_type` VARCHAR(16)  NOT NULL,
    `asset_id`   INT UNSIGNED NOT NULL,
    -- Wem es gehoert: player (pid), gang (gangs.id), faction (west/civ/independent), spaeter company
    `owner_type` VARCHAR(16)  NOT NULL,
    `owner_id`   VARCHAR(32)  NOT NULL,
    -- owner darf alles, coowner alles ausser verkaufen, employee nur benutzen (Phase 2.3)
    `role`       VARCHAR(16)  NOT NULL DEFAULT 'owner',
    `since`      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    -- Besitz endet nicht durch Loeschen, sondern durch ein Datum hier: der Datenbank-Benutzer des
    -- Servers hat kein DELETE-Recht (wie ueberall in dieser Mission), und nebenbei bleibt sichtbar,
    -- wem etwas frueher gehoert hat. Aktueller Besitz heisst: until IS NULL.
    `until`      TIMESTAMP    NULL DEFAULT NULL,

    PRIMARY KEY (`id`),
    -- Derselbe Besitzer steht nie zweimal mit derselben Rolle an demselben Gegenstand
    UNIQUE KEY `uniq_owner` (`asset_type`, `asset_id`, `owner_type`, `owner_id`, `role`),
    -- "Wer besitzt das hier?"
    INDEX `idx_asset` (`asset_type`, `asset_id`),
    -- "Was besitzt dieser Spieler / diese Gang?"
    INDEX `idx_owner` (`owner_type`, `owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Keine Fremdschluessel: asset_id und owner_id zeigen je nach Typ in verschiedene Tabellen, das
-- kann eine relationale Datenbank nicht absichern. Dafuer traegt der Server beim Verkauf oder
-- Zerstoeren das Enddatum ein (TON_fnc_assetRelease), und die Abfragen unten finden Waisen.

-- ---------------------------------------------------------------------
--  Altbestand uebernehmen. INSERT IGNORE, damit die Migration wiederholbar bleibt.
-- ---------------------------------------------------------------------
INSERT IGNORE INTO `asset_owners` (`asset_type`, `asset_id`, `owner_type`, `owner_id`, `role`, `since`)
    SELECT 'vehicle', `id`, 'player', `pid`, 'owner', `insert_time`
    FROM `vehicles`
    WHERE `alive` = 1 AND `pid` <> '';

INSERT IGNORE INTO `asset_owners` (`asset_type`, `asset_id`, `owner_type`, `owner_id`, `role`, `since`)
    SELECT 'house', `id`, 'player', `pid`, 'owner', `insert_time`
    FROM `houses`
    WHERE `owned` = 1 AND `pid` <> '';

INSERT IGNORE INTO `asset_owners` (`asset_type`, `asset_id`, `owner_type`, `owner_id`, `role`, `since`)
    SELECT 'container', `id`, 'player', `pid`, 'owner', `insert_time`
    FROM `containers`
    WHERE `owned` = 1 AND `pid` <> '';

-- ---------------------------------------------------------------------
--  Hauseinrichtung: eine Zeile je Gegenstand, nicht ein Klumpen je Haus.
--
--  Die Entscheidung aus Phase 0.3 ("relational rows vs. serialized blob") faellt hier auf
--  relational, aus drei Gruenden: ein Gegenstand laesst sich einzeln entfernen, ohne den ganzen
--  Bestand neu zu schreiben; man kann zaehlen und begrenzen ("hoechstens 40 Stueck je Haus"), ohne
--  Text zu zerlegen; und das freie Abstellen (core/placement) liefert Position und Ausrichtung
--  ohnehin schon in genau dieser Form.
--
--  pos/vec_dir/vec_up stehen relativ zum Haus, damit ein Haus spaeter verschoben werden kann,
--  ohne jede Zeile anzufassen.
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `house_objects` (
    `id`        INT UNSIGNED NOT NULL AUTO_INCREMENT,
    -- Genau derselbe Typ wie houses.id (signed INT): ein Fremdschluessel mit UNSIGNED auf der
    -- einen und signed auf der anderen Seite lehnt MySQL mit Fehler 150 ab.
    `house_id`  INT          NOT NULL,
    `classname` VARCHAR(64)  NOT NULL,
    `pos`       VARCHAR(48)  NOT NULL DEFAULT '[0,0,0]',
    `vec_dir`   VARCHAR(48)  NOT NULL DEFAULT '[0,1,0]',
    `vec_up`    VARCHAR(48)  NOT NULL DEFAULT '[0,0,1]',
    `placed_by` VARCHAR(17)  NOT NULL DEFAULT '',
    `placed_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    INDEX `idx_house` (`house_id`),
    CONSTRAINT `FK_houses_objects` FOREIGN KEY (`house_id`)
        REFERENCES `houses` (`id`)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
--  Aufraeumen: beendete Eintraege nach einer Weile wegwerfen. Wie deleteOldHouses und die anderen
--  Prozeduren der Vorlage, damit der Server-Benutzer kein DELETE-Recht braucht (er ruft nur CALL).
-- ---------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `deleteEndedAssetOwners`;
-- Single-statement body without BEGIN/END, so it runs without changing the delimiter (phpMyAdmin)
CREATE DEFINER=CURRENT_USER PROCEDURE `deleteEndedAssetOwners`(IN keepDays INT)
  DELETE FROM `asset_owners` WHERE `until` IS NOT NULL AND `until` < (NOW() - INTERVAL keepDays DAY);

-- ---------------------------------------------------------------------
--  Kontrolle nach dem Lauf (nur lesen, aendert nichts):
--
--      SELECT asset_type, COUNT(*) FROM asset_owners WHERE until IS NULL GROUP BY asset_type;
--
--  Muss zu diesen drei Zahlen passen:
--      SELECT COUNT(*) FROM vehicles   WHERE alive = 1;
--      SELECT COUNT(*) FROM houses     WHERE owned = 1;
--      SELECT COUNT(*) FROM containers WHERE owned = 1;
--
--  Waisen finden (Besitz ohne Gegenstand) - sollte leer sein:
--      SELECT o.* FROM asset_owners o LEFT JOIN vehicles v ON v.id = o.asset_id
--      WHERE o.asset_type = 'vehicle' AND o.until IS NULL AND v.id IS NULL;
-- ---------------------------------------------------------------------
