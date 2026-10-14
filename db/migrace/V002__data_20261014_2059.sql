-- V002__data_20261014_2059.sql
-- Data z náhledu převedená nástrojem nastroje/migrace.py.
-- Výchozí demo data náhledu
-- vehicles: 8 nových/změněných, 0 smazaných
-- defects: 6 nových/změněných, 0 smazaných
-- log: 4 nových/změněných, 0 smazaných
-- parts: 3 nových/změněných, 0 smazaných
-- readings: 2 nových/změněných, 0 smazaných
-- orders: 1 nových/změněných, 0 smazaných

SET NAMES utf8mb4;
START TRANSACTION;

-- vehicles: 8 nových/změněných
INSERT INTO vehicles (id, category, spz, name, model, year_made, vin, driver, odometer, odometer_set_at, stk_until, oil_last_date, oil_last_odo, oil_every_odo, oil_every_months, svc_last_date, svc_last_odo, svc_every_odo, svc_every_months, notes, photo_ref, created_at) VALUES ('demo-v01', 'truck', '1AB 2345', 'Tatra 815', 'Sklápěč 8×8', 2015, 'TNU815S8F00012345', 'Jan Novák', 412000, NULL, '2026-10-29', '2025-11-10', 380000, 40000, 12, '2025-11-10', 380000, NULL, 12, NULL, NULL, '2026-09-01 07:00:00')
  ON DUPLICATE KEY UPDATE category = VALUES(category), spz = VALUES(spz), name = VALUES(name), model = VALUES(model), year_made = VALUES(year_made), vin = VALUES(vin), driver = VALUES(driver), odometer = VALUES(odometer), odometer_set_at = VALUES(odometer_set_at), stk_until = VALUES(stk_until), oil_last_date = VALUES(oil_last_date), oil_last_odo = VALUES(oil_last_odo), oil_every_odo = VALUES(oil_every_odo), oil_every_months = VALUES(oil_every_months), svc_last_date = VALUES(svc_last_date), svc_last_odo = VALUES(svc_last_odo), svc_every_odo = VALUES(svc_every_odo), svc_every_months = VALUES(svc_every_months), notes = VALUES(notes), photo_ref = VALUES(photo_ref), created_at = VALUES(created_at);
DELETE FROM vehicle_deadlines WHERE vehicle_id = 'demo-v01';
INSERT INTO vehicle_deadlines (vehicle_id, position, name, due_date) VALUES
  ('demo-v01', 0, 'Tachograf – kalibrace', '2027-03-01');
INSERT INTO vehicles (id, category, spz, name, model, year_made, vin, driver, odometer, odometer_set_at, stk_until, oil_last_date, oil_last_odo, oil_every_odo, oil_every_months, svc_last_date, svc_last_odo, svc_every_odo, svc_every_months, notes, photo_ref, created_at) VALUES ('demo-v02', 'truck', '2CD 6789', 'Scania R450', 'Tahač', 2019, 'YS2R4X20005123456', 'Petr Svoboda', 655000, NULL, '2027-04-15', '2026-06-02', 610000, 60000, 12, '2026-06-02', 610000, 120000, 12, NULL, NULL, '2026-09-01 07:01:00')
  ON DUPLICATE KEY UPDATE category = VALUES(category), spz = VALUES(spz), name = VALUES(name), model = VALUES(model), year_made = VALUES(year_made), vin = VALUES(vin), driver = VALUES(driver), odometer = VALUES(odometer), odometer_set_at = VALUES(odometer_set_at), stk_until = VALUES(stk_until), oil_last_date = VALUES(oil_last_date), oil_last_odo = VALUES(oil_last_odo), oil_every_odo = VALUES(oil_every_odo), oil_every_months = VALUES(oil_every_months), svc_last_date = VALUES(svc_last_date), svc_last_odo = VALUES(svc_last_odo), svc_every_odo = VALUES(svc_every_odo), svc_every_months = VALUES(svc_every_months), notes = VALUES(notes), photo_ref = VALUES(photo_ref), created_at = VALUES(created_at);
DELETE FROM vehicle_deadlines WHERE vehicle_id = 'demo-v02';
INSERT INTO vehicles (id, category, spz, name, model, year_made, vin, driver, odometer, odometer_set_at, stk_until, oil_last_date, oil_last_odo, oil_every_odo, oil_every_months, svc_last_date, svc_last_odo, svc_every_odo, svc_every_months, notes, photo_ref, created_at) VALUES ('demo-v03', 'truck', '3EF 1122', 'MAN TGS 35.400', 'Sklápěč 8×4', 2017, 'WMA30WZZ7HM700123', 'Karel Dvořák', 498500, NULL, '2026-10-05', '2026-02-20', 470000, 30000, 12, '2026-02-20', 470000, NULL, 12, NULL, NULL, '2026-09-01 07:02:00')
  ON DUPLICATE KEY UPDATE category = VALUES(category), spz = VALUES(spz), name = VALUES(name), model = VALUES(model), year_made = VALUES(year_made), vin = VALUES(vin), driver = VALUES(driver), odometer = VALUES(odometer), odometer_set_at = VALUES(odometer_set_at), stk_until = VALUES(stk_until), oil_last_date = VALUES(oil_last_date), oil_last_odo = VALUES(oil_last_odo), oil_every_odo = VALUES(oil_every_odo), oil_every_months = VALUES(oil_every_months), svc_last_date = VALUES(svc_last_date), svc_last_odo = VALUES(svc_last_odo), svc_every_odo = VALUES(svc_every_odo), svc_every_months = VALUES(svc_every_months), notes = VALUES(notes), photo_ref = VALUES(photo_ref), created_at = VALUES(created_at);
DELETE FROM vehicle_deadlines WHERE vehicle_id = 'demo-v03';
INSERT INTO vehicles (id, category, spz, name, model, year_made, vin, driver, odometer, odometer_set_at, stk_until, oil_last_date, oil_last_odo, oil_every_odo, oil_every_months, svc_last_date, svc_last_odo, svc_every_odo, svc_every_months, notes, photo_ref, created_at) VALUES ('demo-v04', 'machine', 'EV-07', 'Caterpillar 320', 'Pásové rýpadlo', 2018, NULL, 'Tomáš Král', 8740, NULL, NULL, '2026-07-01', 8300, 500, 12, '2026-01-15', 7800, 1000, 12, NULL, NULL, '2026-09-01 07:03:00')
  ON DUPLICATE KEY UPDATE category = VALUES(category), spz = VALUES(spz), name = VALUES(name), model = VALUES(model), year_made = VALUES(year_made), vin = VALUES(vin), driver = VALUES(driver), odometer = VALUES(odometer), odometer_set_at = VALUES(odometer_set_at), stk_until = VALUES(stk_until), oil_last_date = VALUES(oil_last_date), oil_last_odo = VALUES(oil_last_odo), oil_every_odo = VALUES(oil_every_odo), oil_every_months = VALUES(oil_every_months), svc_last_date = VALUES(svc_last_date), svc_last_odo = VALUES(svc_last_odo), svc_every_odo = VALUES(svc_every_odo), svc_every_months = VALUES(svc_every_months), notes = VALUES(notes), photo_ref = VALUES(photo_ref), created_at = VALUES(created_at);
DELETE FROM vehicle_deadlines WHERE vehicle_id = 'demo-v04';
INSERT INTO vehicles (id, category, spz, name, model, year_made, vin, driver, odometer, odometer_set_at, stk_until, oil_last_date, oil_last_odo, oil_every_odo, oil_every_months, svc_last_date, svc_last_odo, svc_every_odo, svc_every_months, notes, photo_ref, created_at) VALUES ('demo-v05', 'machine', 'EV-11', 'JCB 3CX', 'Rýpadlo-nakladač', 2020, NULL, 'Lukáš Beneš', 4120, NULL, '2027-01-20', '2026-08-12', 3900, 500, 12, '2026-08-12', 3900, 1000, 12, NULL, NULL, '2026-09-01 07:04:00')
  ON DUPLICATE KEY UPDATE category = VALUES(category), spz = VALUES(spz), name = VALUES(name), model = VALUES(model), year_made = VALUES(year_made), vin = VALUES(vin), driver = VALUES(driver), odometer = VALUES(odometer), odometer_set_at = VALUES(odometer_set_at), stk_until = VALUES(stk_until), oil_last_date = VALUES(oil_last_date), oil_last_odo = VALUES(oil_last_odo), oil_every_odo = VALUES(oil_every_odo), oil_every_months = VALUES(oil_every_months), svc_last_date = VALUES(svc_last_date), svc_last_odo = VALUES(svc_last_odo), svc_every_odo = VALUES(svc_every_odo), svc_every_months = VALUES(svc_every_months), notes = VALUES(notes), photo_ref = VALUES(photo_ref), created_at = VALUES(created_at);
DELETE FROM vehicle_deadlines WHERE vehicle_id = 'demo-v05';
INSERT INTO vehicles (id, category, spz, name, model, year_made, vin, driver, odometer, odometer_set_at, stk_until, oil_last_date, oil_last_odo, oil_every_odo, oil_every_months, svc_last_date, svc_last_odo, svc_every_odo, svc_every_months, notes, photo_ref, created_at) VALUES ('demo-v06', 'machine', 'EV-14', 'Bobcat S650', 'Smykový nakladač', 2021, NULL, NULL, 2210, NULL, NULL, '2026-03-03', 1800, 500, 12, NULL, NULL, NULL, 12, NULL, NULL, '2026-09-01 07:05:00')
  ON DUPLICATE KEY UPDATE category = VALUES(category), spz = VALUES(spz), name = VALUES(name), model = VALUES(model), year_made = VALUES(year_made), vin = VALUES(vin), driver = VALUES(driver), odometer = VALUES(odometer), odometer_set_at = VALUES(odometer_set_at), stk_until = VALUES(stk_until), oil_last_date = VALUES(oil_last_date), oil_last_odo = VALUES(oil_last_odo), oil_every_odo = VALUES(oil_every_odo), oil_every_months = VALUES(oil_every_months), svc_last_date = VALUES(svc_last_date), svc_last_odo = VALUES(svc_last_odo), svc_every_odo = VALUES(svc_every_odo), svc_every_months = VALUES(svc_every_months), notes = VALUES(notes), photo_ref = VALUES(photo_ref), created_at = VALUES(created_at);
DELETE FROM vehicle_deadlines WHERE vehicle_id = 'demo-v06';
INSERT INTO vehicles (id, category, spz, name, model, year_made, vin, driver, odometer, odometer_set_at, stk_until, oil_last_date, oil_last_odo, oil_every_odo, oil_every_months, svc_last_date, svc_last_odo, svc_every_odo, svc_every_months, notes, photo_ref, created_at) VALUES ('demo-v07', 'car', '4GH 3344', 'Škoda Octavia Combi', '2.0 TDI', 2022, 'TMBJG7NX5N0123456', 'Vedoucí servisu', 86400, NULL, '2026-11-08', '2025-12-01', 71000, 30000, 24, '2025-12-01', 71000, 30000, 24, NULL, NULL, '2026-09-01 07:06:00')
  ON DUPLICATE KEY UPDATE category = VALUES(category), spz = VALUES(spz), name = VALUES(name), model = VALUES(model), year_made = VALUES(year_made), vin = VALUES(vin), driver = VALUES(driver), odometer = VALUES(odometer), odometer_set_at = VALUES(odometer_set_at), stk_until = VALUES(stk_until), oil_last_date = VALUES(oil_last_date), oil_last_odo = VALUES(oil_last_odo), oil_every_odo = VALUES(oil_every_odo), oil_every_months = VALUES(oil_every_months), svc_last_date = VALUES(svc_last_date), svc_last_odo = VALUES(svc_last_odo), svc_every_odo = VALUES(svc_every_odo), svc_every_months = VALUES(svc_every_months), notes = VALUES(notes), photo_ref = VALUES(photo_ref), created_at = VALUES(created_at);
DELETE FROM vehicle_deadlines WHERE vehicle_id = 'demo-v07';
INSERT INTO vehicles (id, category, spz, name, model, year_made, vin, driver, odometer, odometer_set_at, stk_until, oil_last_date, oil_last_odo, oil_every_odo, oil_every_months, svc_last_date, svc_last_odo, svc_every_odo, svc_every_months, notes, photo_ref, created_at) VALUES ('demo-v08', 'car', '5IJ 5566', 'VW Transporter', 'T6.1 dodávka', 2021, 'WV1ZZZ7HZMH012345', 'Dílna', 142300, NULL, '2027-06-30', '2026-04-18', 128000, 30000, 12, '2026-04-18', 128000, 30000, 24, NULL, NULL, '2026-09-01 07:07:00')
  ON DUPLICATE KEY UPDATE category = VALUES(category), spz = VALUES(spz), name = VALUES(name), model = VALUES(model), year_made = VALUES(year_made), vin = VALUES(vin), driver = VALUES(driver), odometer = VALUES(odometer), odometer_set_at = VALUES(odometer_set_at), stk_until = VALUES(stk_until), oil_last_date = VALUES(oil_last_date), oil_last_odo = VALUES(oil_last_odo), oil_every_odo = VALUES(oil_every_odo), oil_every_months = VALUES(oil_every_months), svc_last_date = VALUES(svc_last_date), svc_last_odo = VALUES(svc_last_odo), svc_every_odo = VALUES(svc_every_odo), svc_every_months = VALUES(svc_every_months), notes = VALUES(notes), photo_ref = VALUES(photo_ref), created_at = VALUES(created_at);
DELETE FROM vehicle_deadlines WHERE vehicle_id = 'demo-v08';

-- defects: 6 nových/změněných
INSERT INTO defects (id, vehicle_id, description, severity, status, odometer, reported_by, reporter_name, photo_ref, service_note, reported_on, resolved_on, created_at) VALUES ('demo-d01', 'demo-v01', 'Při brzdění tahá doleva, pískají přední brzdy.', 'krit', 'nova', 411800, NULL, 'Demo řidič', NULL, NULL, '2026-10-13', NULL, '2026-10-13 10:00:00')
  ON DUPLICATE KEY UPDATE vehicle_id = VALUES(vehicle_id), description = VALUES(description), severity = VALUES(severity), status = VALUES(status), odometer = VALUES(odometer), reported_by = VALUES(reported_by), reporter_name = VALUES(reporter_name), photo_ref = VALUES(photo_ref), service_note = VALUES(service_note), reported_on = VALUES(reported_on), resolved_on = VALUES(resolved_on), created_at = VALUES(created_at);
INSERT INTO defects (id, vehicle_id, description, severity, status, odometer, reported_by, reporter_name, photo_ref, service_note, reported_on, resolved_on, created_at) VALUES ('demo-d02', 'demo-v01', 'Nesvítí pravé zadní obrysové světlo.', 'lehka', 'nova', 411800, NULL, 'Demo řidič', NULL, NULL, '2026-10-13', NULL, '2026-10-13 10:01:00')
  ON DUPLICATE KEY UPDATE vehicle_id = VALUES(vehicle_id), description = VALUES(description), severity = VALUES(severity), status = VALUES(status), odometer = VALUES(odometer), reported_by = VALUES(reported_by), reporter_name = VALUES(reporter_name), photo_ref = VALUES(photo_ref), service_note = VALUES(service_note), reported_on = VALUES(reported_on), resolved_on = VALUES(resolved_on), created_at = VALUES(created_at);
INSERT INTO defects (id, vehicle_id, description, severity, status, odometer, reported_by, reporter_name, photo_ref, service_note, reported_on, resolved_on, created_at) VALUES ('demo-d03', 'demo-v03', 'Uniká vzduch u návěsové spojky, kompresor často dofukuje.', 'krit', 'resi', 498400, NULL, 'Demo řidič', NULL, 'Objednaná nová spojka, dorazí ve čtvrtek.', '2026-10-10', NULL, '2026-10-10 10:02:00')
  ON DUPLICATE KEY UPDATE vehicle_id = VALUES(vehicle_id), description = VALUES(description), severity = VALUES(severity), status = VALUES(status), odometer = VALUES(odometer), reported_by = VALUES(reported_by), reporter_name = VALUES(reporter_name), photo_ref = VALUES(photo_ref), service_note = VALUES(service_note), reported_on = VALUES(reported_on), resolved_on = VALUES(resolved_on), created_at = VALUES(created_at);
INSERT INTO defects (id, vehicle_id, description, severity, status, odometer, reported_by, reporter_name, photo_ref, service_note, reported_on, resolved_on, created_at) VALUES ('demo-d04', 'demo-v04', 'Prasklé sklo dveří kabiny.', 'lehka', 'odlozeno', 8720, NULL, 'Demo řidič', NULL, 'Vyměníme při zimním servisu.', '2026-09-28', NULL, '2026-09-28 10:03:00')
  ON DUPLICATE KEY UPDATE vehicle_id = VALUES(vehicle_id), description = VALUES(description), severity = VALUES(severity), status = VALUES(status), odometer = VALUES(odometer), reported_by = VALUES(reported_by), reporter_name = VALUES(reporter_name), photo_ref = VALUES(photo_ref), service_note = VALUES(service_note), reported_on = VALUES(reported_on), resolved_on = VALUES(resolved_on), created_at = VALUES(created_at);
INSERT INTO defects (id, vehicle_id, description, severity, status, odometer, reported_by, reporter_name, photo_ref, service_note, reported_on, resolved_on, created_at) VALUES ('demo-d05', 'demo-v07', 'Kontrolka tlaku v pneumatikách.', 'lehka', 'hotovo', 86100, NULL, 'Demo řidič', NULL, 'Dohuštěno, kalibrace TPMS.', '2026-10-02', '2026-10-03', '2026-10-02 10:04:00')
  ON DUPLICATE KEY UPDATE vehicle_id = VALUES(vehicle_id), description = VALUES(description), severity = VALUES(severity), status = VALUES(status), odometer = VALUES(odometer), reported_by = VALUES(reported_by), reporter_name = VALUES(reporter_name), photo_ref = VALUES(photo_ref), service_note = VALUES(service_note), reported_on = VALUES(reported_on), resolved_on = VALUES(resolved_on), created_at = VALUES(created_at);
INSERT INTO defects (id, vehicle_id, description, severity, status, odometer, reported_by, reporter_name, photo_ref, service_note, reported_on, resolved_on, created_at) VALUES ('demo-d06', 'demo-v05', 'Teče hydraulický olej z hadice na lžíci.', 'krit', 'hotovo', 4100, NULL, 'Demo řidič', NULL, NULL, '2026-10-06', '2026-10-07', '2026-10-06 10:05:00')
  ON DUPLICATE KEY UPDATE vehicle_id = VALUES(vehicle_id), description = VALUES(description), severity = VALUES(severity), status = VALUES(status), odometer = VALUES(odometer), reported_by = VALUES(reported_by), reporter_name = VALUES(reporter_name), photo_ref = VALUES(photo_ref), service_note = VALUES(service_note), reported_on = VALUES(reported_on), resolved_on = VALUES(resolved_on), created_at = VALUES(created_at);

-- log: 4 nových/změněných
INSERT INTO service_records (id, vehicle_id, kind, done_on, odometer, done_text, not_done_text, labor_czk, created_by, created_at) VALUES ('demo-l01', 'demo-v02', 'service', '2026-06-02', 610000, 'Velký servis podle plánu.', NULL, 3500.0, NULL, '2026-06-02 14:00:00')
  ON DUPLICATE KEY UPDATE vehicle_id = VALUES(vehicle_id), kind = VALUES(kind), done_on = VALUES(done_on), odometer = VALUES(odometer), done_text = VALUES(done_text), not_done_text = VALUES(not_done_text), labor_czk = VALUES(labor_czk), created_by = VALUES(created_by), created_at = VALUES(created_at);
DELETE FROM service_record_tasks WHERE record_id = 'demo-l01';
DELETE FROM service_record_types WHERE record_id = 'demo-l01';
DELETE FROM service_record_parts WHERE record_id = 'demo-l01';
DELETE FROM service_record_defects WHERE record_id = 'demo-l01';
INSERT INTO service_record_tasks (record_id, task) VALUES
  ('demo-l01', 'Výměna motorového oleje'),
  ('demo-l01', 'Výměna olejového filtru'),
  ('demo-l01', 'Výměna palivového filtru'),
  ('demo-l01', 'Výměna vzduchového filtru'),
  ('demo-l01', 'Olej převodovka');
INSERT INTO service_record_types (record_id, work_type) VALUES
  ('demo-l01', 'Pravidelný servis');
INSERT INTO service_record_parts (record_id, position, name, qty, price_czk) VALUES
  ('demo-l01', 0, 'Motorový olej 10W-40', 38.0, 7600.0),
  ('demo-l01', 1, 'Sada filtrů', 1.0, 4850.0);
INSERT INTO service_records (id, vehicle_id, kind, done_on, odometer, done_text, not_done_text, labor_czk, created_by, created_at) VALUES ('demo-l02', 'demo-v03', 'service', '2026-02-20', 470000, NULL, 'Olej v nápravách 3 a 4 příště.', 2400.0, NULL, '2026-02-20 14:01:00')
  ON DUPLICATE KEY UPDATE vehicle_id = VALUES(vehicle_id), kind = VALUES(kind), done_on = VALUES(done_on), odometer = VALUES(odometer), done_text = VALUES(done_text), not_done_text = VALUES(not_done_text), labor_czk = VALUES(labor_czk), created_by = VALUES(created_by), created_at = VALUES(created_at);
DELETE FROM service_record_tasks WHERE record_id = 'demo-l02';
DELETE FROM service_record_types WHERE record_id = 'demo-l02';
DELETE FROM service_record_parts WHERE record_id = 'demo-l02';
DELETE FROM service_record_defects WHERE record_id = 'demo-l02';
INSERT INTO service_record_tasks (record_id, task) VALUES
  ('demo-l02', 'Výměna motorového oleje'),
  ('demo-l02', 'Výměna olejového filtru'),
  ('demo-l02', 'Olej v nápravě 1'),
  ('demo-l02', 'Olej v nápravě 2');
INSERT INTO service_record_parts (record_id, position, name, qty, price_czk) VALUES
  ('demo-l02', 0, 'Motorový olej 10W-40', 34.0, 6800.0);
INSERT INTO service_records (id, vehicle_id, kind, done_on, odometer, done_text, not_done_text, labor_czk, created_by, created_at) VALUES ('demo-l03', 'demo-v05', 'repair', '2026-10-07', 4100, 'Výměna hydraulické hadice na lžíci, doplnění oleje.', NULL, 900.0, NULL, '2026-10-07 14:02:00')
  ON DUPLICATE KEY UPDATE vehicle_id = VALUES(vehicle_id), kind = VALUES(kind), done_on = VALUES(done_on), odometer = VALUES(odometer), done_text = VALUES(done_text), not_done_text = VALUES(not_done_text), labor_czk = VALUES(labor_czk), created_by = VALUES(created_by), created_at = VALUES(created_at);
DELETE FROM service_record_tasks WHERE record_id = 'demo-l03';
DELETE FROM service_record_types WHERE record_id = 'demo-l03';
DELETE FROM service_record_parts WHERE record_id = 'demo-l03';
DELETE FROM service_record_defects WHERE record_id = 'demo-l03';
INSERT INTO service_record_parts (record_id, position, name, qty, price_czk) VALUES
  ('demo-l03', 0, 'Hydraulická hadice 1/2"', 1.0, 1290.0),
  ('demo-l03', 1, 'Hydraulický olej HV46', 5.0, 650.0);
INSERT INTO service_record_defects (record_id, defect_id) VALUES
  ('demo-l03', 'demo-d06');
INSERT INTO service_records (id, vehicle_id, kind, done_on, odometer, done_text, not_done_text, labor_czk, created_by, created_at) VALUES ('demo-l04', 'demo-v04', 'service', '2026-07-01', 8300, NULL, NULL, 1800.0, NULL, '2026-07-01 14:03:00')
  ON DUPLICATE KEY UPDATE vehicle_id = VALUES(vehicle_id), kind = VALUES(kind), done_on = VALUES(done_on), odometer = VALUES(odometer), done_text = VALUES(done_text), not_done_text = VALUES(not_done_text), labor_czk = VALUES(labor_czk), created_by = VALUES(created_by), created_at = VALUES(created_at);
DELETE FROM service_record_tasks WHERE record_id = 'demo-l04';
DELETE FROM service_record_types WHERE record_id = 'demo-l04';
DELETE FROM service_record_parts WHERE record_id = 'demo-l04';
DELETE FROM service_record_defects WHERE record_id = 'demo-l04';
INSERT INTO service_record_tasks (record_id, task) VALUES
  ('demo-l04', 'Výměna motorového oleje'),
  ('demo-l04', 'Výměna olejového filtru'),
  ('demo-l04', 'Výměna naftového filtru na motoru');
INSERT INTO service_record_parts (record_id, position, name, qty, price_czk) VALUES
  ('demo-l04', 0, 'Motorový olej 15W-40', 28.0, 4200.0);

-- parts: 3 nových/změněných
INSERT INTO part_orders (id, vehicle_id, defect_id, name, qty, note, status, created_on, ordered_on, arrived_on, created_by, created_at) VALUES ('demo-p01', 'demo-v01', 'demo-d01', 'Brzdové destičky přední', 1.0, 'Sada na nápravu', 'objednat', '2026-10-13', NULL, NULL, NULL, '2026-10-13 11:00:00')
  ON DUPLICATE KEY UPDATE vehicle_id = VALUES(vehicle_id), defect_id = VALUES(defect_id), name = VALUES(name), qty = VALUES(qty), note = VALUES(note), status = VALUES(status), created_on = VALUES(created_on), ordered_on = VALUES(ordered_on), arrived_on = VALUES(arrived_on), created_by = VALUES(created_by), created_at = VALUES(created_at);
INSERT INTO part_orders (id, vehicle_id, defect_id, name, qty, note, status, created_on, ordered_on, arrived_on, created_by, created_at) VALUES ('demo-p02', 'demo-v03', 'demo-d03', 'Návěsová spojka vzduchu', 1.0, 'Wabco', 'objednano', '2026-10-10', '2026-10-11', NULL, NULL, '2026-10-10 11:01:00')
  ON DUPLICATE KEY UPDATE vehicle_id = VALUES(vehicle_id), defect_id = VALUES(defect_id), name = VALUES(name), qty = VALUES(qty), note = VALUES(note), status = VALUES(status), created_on = VALUES(created_on), ordered_on = VALUES(ordered_on), arrived_on = VALUES(arrived_on), created_by = VALUES(created_by), created_at = VALUES(created_at);
INSERT INTO part_orders (id, vehicle_id, defect_id, name, qty, note, status, created_on, ordered_on, arrived_on, created_by, created_at) VALUES ('demo-p03', 'demo-v07', NULL, 'Stírátka přední', 2.0, NULL, 'dorazilo', '2026-09-30', '2026-09-30', '2026-10-02', NULL, '2026-09-30 11:02:00')
  ON DUPLICATE KEY UPDATE vehicle_id = VALUES(vehicle_id), defect_id = VALUES(defect_id), name = VALUES(name), qty = VALUES(qty), note = VALUES(note), status = VALUES(status), created_on = VALUES(created_on), ordered_on = VALUES(ordered_on), arrived_on = VALUES(arrived_on), created_by = VALUES(created_by), created_at = VALUES(created_at);

-- readings: 2 nových/změněných
INSERT INTO odometer_readings (vehicle_id, odometer, read_on, read_at, read_by) VALUES ('demo-v01', 412000, '2026-10-13', '2026-10-13 15:00:00', NULL)
  ON DUPLICATE KEY UPDATE odometer = VALUES(odometer), read_on = VALUES(read_on), read_at = VALUES(read_at), read_by = VALUES(read_by);
INSERT INTO odometer_readings (vehicle_id, odometer, read_on, read_at, read_by) VALUES ('demo-v04', 8740, '2026-10-12', '2026-10-12 15:00:00', NULL)
  ON DUPLICATE KEY UPDATE odometer = VALUES(odometer), read_on = VALUES(read_on), read_at = VALUES(read_at), read_by = VALUES(read_by);

-- orders: 1 nových/změněných
INSERT INTO service_orders (vehicle_id, started_on, odometer, started_by) VALUES ('demo-v08', '2026-10-14', 142300, NULL)
  ON DUPLICATE KEY UPDATE started_on = VALUES(started_on), odometer = VALUES(odometer), started_by = VALUES(started_by);
DELETE FROM service_order_items WHERE vehicle_id = 'demo-v08';
INSERT INTO service_order_items (vehicle_id, task, is_extra, is_checked, is_removed) VALUES
  ('demo-v08', 'Kontrola brzd', 1, 0, 0),
  ('demo-v08', 'Olej sestup', 0, 0, 1),
  ('demo-v08', 'Olej v nápravě 3', 0, 0, 1),
  ('demo-v08', 'Olej v nápravě 4', 0, 0, 1),
  ('demo-v08', 'Olej v nápravě 5', 0, 0, 1),
  ('demo-v08', 'Výměna motorového oleje', 0, 1, 0),
  ('demo-v08', 'Výměna olejového filtru', 0, 1, 0);

COMMIT;
