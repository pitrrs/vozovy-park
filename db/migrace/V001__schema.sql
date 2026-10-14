-- V001 – výchozí schéma databáze vozového parku
-- Cíl: MySQL 5.5.3+ (InnoDB, utf8mb4).
-- NÁVRH odvozený z HTML prototypu (prototyp/index.html) – ke schválení Petrem.
--
-- Omezení MySQL 5.5, se kterými schéma počítá:
--   * žádný typ JSON  -> pole z prototypu jsou v podřízených tabulkách
--   * DATETIME bez zlomků sekund a bez DEFAULT CURRENT_TIMESTAMP -> časy plní migrace
--   * index max. 767 B -> identifikátory jsou ASCII, textové klíče max. VARCHAR(150)
--   * utf8mb4 až od 5.5.3

SET NAMES utf8mb4;

-- Vozidla
CREATE TABLE vehicles (
  id               VARCHAR(64) CHARACTER SET ascii NOT NULL,
  category         ENUM('truck','machine','car') NOT NULL DEFAULT 'truck'
                   COMMENT 'truck = nákladní vůz, machine = stavební stroj (počítá se v mth), car = osobní auto',
  spz              VARCHAR(20)  NULL COMMENT 'SPZ nebo evidenční číslo stroje',
  name             VARCHAR(120) NOT NULL,
  model            VARCHAR(120) NULL COMMENT 'typ / nástavba',
  year_made        SMALLINT UNSIGNED NULL,
  vin              VARCHAR(17)  NULL,
  driver           VARCHAR(120) NULL,
  odometer         INT UNSIGNED NULL COMMENT 'ručně zadaný stav km / mth',
  odometer_set_at  DATETIME NULL COMMENT 'kdy byl stav ručně přepsán (má přednost před staršími hlášeními)',
  stk_until        DATE NULL,
  oil_last_date    DATE NULL,
  oil_last_odo     INT UNSIGNED NULL,
  oil_every_odo    INT UNSIGNED NULL,
  oil_every_months TINYINT UNSIGNED NULL,
  svc_last_date    DATE NULL,
  svc_last_odo     INT UNSIGNED NULL,
  svc_every_odo    INT UNSIGNED NULL,
  svc_every_months TINYINT UNSIGNED NULL,
  notes            TEXT NULL,
  photo_ref        VARCHAR(64) CHARACTER SET ascii NULL COMMENT 'odkaz na fotku v úložišti, ne fotka samotná',
  created_at       DATETIME NULL,
  PRIMARY KEY (id),
  KEY ix_vehicles_category (category),
  KEY ix_vehicles_spz (spz)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

-- Vlastní termíny vozidla (tachograf, hasicí přístroj…)
CREATE TABLE vehicle_deadlines (
  vehicle_id VARCHAR(64) CHARACTER SET ascii NOT NULL,
  position   SMALLINT UNSIGNED NOT NULL,
  name       VARCHAR(150) NOT NULL,
  due_date   DATE NULL,
  PRIMARY KEY (vehicle_id, position),
  CONSTRAINT fk_deadlines_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicles (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

-- Závady hlášené řidiči
CREATE TABLE defects (
  id            VARCHAR(64) CHARACTER SET ascii NOT NULL,
  vehicle_id    VARCHAR(64) CHARACTER SET ascii NOT NULL,
  description   TEXT NOT NULL,
  severity      ENUM('krit','lehka') NOT NULL DEFAULT 'lehka',
  status        ENUM('nova','resi','hotovo','odlozeno') NOT NULL DEFAULT 'nova'
                COMMENT 'nova = nová, resi = v řešení, hotovo = opraveno, odlozeno = odloženo',
  odometer      INT UNSIGNED NULL,
  reported_by   VARCHAR(64) CHARACTER SET ascii NULL COMMENT 'id uživatele',
  reporter_name VARCHAR(120) NULL,
  photo_ref     VARCHAR(64) CHARACTER SET ascii NULL,
  service_note  TEXT NULL,
  reported_on   DATE NULL,
  resolved_on   DATE NULL,
  created_at    DATETIME NULL,
  PRIMARY KEY (id),
  KEY ix_defects_vehicle (vehicle_id),
  KEY ix_defects_status (status, severity),
  CONSTRAINT fk_defects_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicles (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

-- Servisní kniha a opravy
CREATE TABLE service_records (
  id            VARCHAR(64) CHARACTER SET ascii NOT NULL,
  vehicle_id    VARCHAR(64) CHARACTER SET ascii NOT NULL,
  kind          ENUM('service','repair') NOT NULL DEFAULT 'service'
                COMMENT 'service = servisní kniha, repair = oprava mimo servis',
  done_on       DATE NULL,
  odometer      INT UNSIGNED NULL,
  done_text     TEXT NULL COMMENT 'co se udělalo',
  not_done_text TEXT NULL COMMENT 'co se neudělalo / zbývá',
  labor_czk     DECIMAL(10,2) NULL,
  created_by    VARCHAR(64) CHARACTER SET ascii NULL,
  created_at    DATETIME NULL,
  PRIMARY KEY (id),
  KEY ix_records_vehicle (vehicle_id, done_on),
  CONSTRAINT fk_records_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicles (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

-- Zaškrtnuté úkony checklistu u záznamu
CREATE TABLE service_record_tasks (
  record_id VARCHAR(64) CHARACTER SET ascii NOT NULL,
  task      VARCHAR(150) NOT NULL,
  PRIMARY KEY (record_id, task),
  CONSTRAINT fk_tasks_record FOREIGN KEY (record_id) REFERENCES service_records (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

-- Typ práce (STK, Pneu, Oprava…)
CREATE TABLE service_record_types (
  record_id VARCHAR(64) CHARACTER SET ascii NOT NULL,
  work_type VARCHAR(60) NOT NULL,
  PRIMARY KEY (record_id, work_type),
  CONSTRAINT fk_types_record FOREIGN KEY (record_id) REFERENCES service_records (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

-- Nakoupené díly a materiál u záznamu
CREATE TABLE service_record_parts (
  record_id VARCHAR(64) CHARACTER SET ascii NOT NULL,
  position  SMALLINT UNSIGNED NOT NULL,
  name      VARCHAR(200) NOT NULL,
  qty       DECIMAL(10,2) NULL,
  price_czk DECIMAL(10,2) NULL COMMENT 'cena celkem za položku',
  PRIMARY KEY (record_id, position),
  CONSTRAINT fk_parts_record FOREIGN KEY (record_id) REFERENCES service_records (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

-- Závady opravené tímto záznamem (bez FK na defects – historie zůstane i po smazání závady)
CREATE TABLE service_record_defects (
  record_id VARCHAR(64) CHARACTER SET ascii NOT NULL,
  defect_id VARCHAR(64) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (record_id, defect_id),
  KEY ix_record_defects_defect (defect_id),
  CONSTRAINT fk_rdefects_record FOREIGN KEY (record_id) REFERENCES service_records (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

-- Objednávky dílů
CREATE TABLE part_orders (
  id          VARCHAR(64) CHARACTER SET ascii NOT NULL,
  vehicle_id  VARCHAR(64) CHARACTER SET ascii NOT NULL,
  defect_id   VARCHAR(64) CHARACTER SET ascii NULL,
  name        VARCHAR(200) NOT NULL,
  qty         DECIMAL(10,2) NOT NULL DEFAULT 1,
  note        VARCHAR(255) NULL COMMENT 'dodavatel, kód dílu',
  status      ENUM('objednat','objednano','dorazilo') NOT NULL DEFAULT 'objednat',
  created_on  DATE NULL,
  ordered_on  DATE NULL,
  arrived_on  DATE NULL,
  created_by  VARCHAR(64) CHARACTER SET ascii NULL,
  created_at  DATETIME NULL,
  PRIMARY KEY (id),
  KEY ix_part_orders_vehicle (vehicle_id),
  KEY ix_part_orders_status (status),
  KEY ix_part_orders_defect (defect_id),
  CONSTRAINT fk_porders_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicles (id) ON DELETE CASCADE,
  CONSTRAINT fk_porders_defect FOREIGN KEY (defect_id) REFERENCES defects (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

-- Poslední hlášený stav tachometru / motohodin
CREATE TABLE odometer_readings (
  vehicle_id VARCHAR(64) CHARACTER SET ascii NOT NULL,
  odometer   INT UNSIGNED NOT NULL,
  read_on    DATE NULL,
  read_at    DATETIME NULL,
  read_by    VARCHAR(64) CHARACTER SET ascii NULL,
  PRIMARY KEY (vehicle_id),
  CONSTRAINT fk_readings_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicles (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

-- Rozpracovaný servis (checklist), nejvýš jeden na vozidlo
CREATE TABLE service_orders (
  vehicle_id VARCHAR(64) CHARACTER SET ascii NOT NULL,
  started_on DATE NULL,
  odometer   INT UNSIGNED NULL,
  started_by VARCHAR(64) CHARACTER SET ascii NULL,
  PRIMARY KEY (vehicle_id),
  CONSTRAINT fk_sorders_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicles (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;

CREATE TABLE service_order_items (
  vehicle_id VARCHAR(64) CHARACTER SET ascii NOT NULL,
  task       VARCHAR(150) NOT NULL,
  is_extra   TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'úkon přidaný ručně mimo standardní checklist',
  is_checked TINYINT(1) NOT NULL DEFAULT 0,
  is_removed TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'standardní úkon odebraný z tohoto servisu',
  PRIMARY KEY (vehicle_id, task),
  CONSTRAINT fk_sitems_order FOREIGN KEY (vehicle_id) REFERENCES service_orders (vehicle_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_czech_ci;
