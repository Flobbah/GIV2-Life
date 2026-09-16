-- =====================================================================
--  Migration 001 (2026-09-16): transaction log for the server-authoritative economy
--  (CfgServer >> EconomyMode in description.ext)
--
--  Run as root (or another user with CREATE rights) against your Life database, e.g.
--      mysql -u root -p altislife < 2026-09-16_001_money_transactions.sql
--  or select the database in phpMyAdmin and paste this into the SQL tab. Safe to run repeatedly.
--
--  The server's database user needs no new rights: SELECT/INSERT on the database cover the table,
--  and old rows are removed through the procedure (EXECUTE), like deleteOldHouses and friends.
--  Without this migration the server still runs: it logs "[ECONOMY] table money_transactions
--  is missing" at start and keeps the shadow checks in the RPT only.
-- =====================================================================

CREATE TABLE IF NOT EXISTS `money_transactions` (
    `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `created_at`    TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `pid`           VARCHAR(17)     NOT NULL DEFAULT '',
    `gang_id`       INT             NOT NULL DEFAULT 0,
    `account`       ENUM('cash','bank','gang') NOT NULL,
    `delta`         BIGINT          NOT NULL,
    `balance_after` BIGINT          NOT NULL,
    `reason`        VARCHAR(48)     NOT NULL,
    `counterpart`   VARCHAR(32)     NOT NULL DEFAULT '',
    `meta`          VARCHAR(255)    NOT NULL DEFAULT '',
    PRIMARY KEY (`id`),
    KEY `idx_pid_time` (`pid`, `created_at`),
    KEY `idx_reason_time` (`reason`, `created_at`),
    KEY `idx_gang_time` (`gang_id`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP PROCEDURE IF EXISTS `deleteOldMoneyTransactions`;
-- Single-statement body without BEGIN/END, so it runs without changing the delimiter (phpMyAdmin)
CREATE DEFINER=CURRENT_USER PROCEDURE `deleteOldMoneyTransactions`(IN keepDays INT)
  DELETE FROM `money_transactions` WHERE `created_at` < (NOW() - INTERVAL keepDays DAY);
