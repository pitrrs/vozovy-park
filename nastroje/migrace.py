#!/usr/bin/env python3
"""Z dat zadaných v náhledu udělá SQL migraci pro MySQL 5.5.

Porovná aktuální data s posledním převedeným stavem (db/stav-dat.json)
a zapíše jen rozdíl jako novou migraci db/migrace/V###__data_RRRRMMDD_HHMM.sql:
nové a změněné záznamy jako INSERT … ON DUPLICATE KEY UPDATE, smazané jako DELETE.
Podřízené tabulky (úkony, díly, termíny…) se u změněného záznamu přepíší celé.

Použití (z kořene repozitáře):
    python3 nastroje/migrace.py ZDROJ [--popis "text"] [--nanecisto]

ZDROJ je buď
  * JSON soubor ve tvaru {"vehicles": {"id": {...}}, "defects": {...}, ...}
    (např. prototyp/demo-data.json), nebo
  * složka se stažením databáze náhledu: ZDROJ/<kolekce>/<id>.json
    (výstup ArtifactData list s out_dir).

--nanecisto  jen vypíše, co by se změnilo; nic nezapíše.
"""
import argparse, datetime, glob, json, os, re, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MIG_DIR = os.path.join(ROOT, "db", "migrace")
STATE = os.path.join(ROOT, "db", "stav-dat.json")
COLLS = ["vehicles", "defects", "log", "parts", "readings", "orders"]


# ---------- načtení dat ----------
def unwrap(obj):
    """Soubor ze stažení může obsahovat buď data, nebo obálku {id, data, version}."""
    if isinstance(obj, dict) and isinstance(obj.get("data"), dict) and ("version" in obj or "id" in obj):
        return obj["data"]
    return obj


def load(src):
    out = {c: {} for c in COLLS}
    if os.path.isfile(src):
        raw = json.load(open(src, encoding="utf-8"))
        for c in COLLS:
            out[c] = {k: unwrap(v) for k, v in (raw.get(c) or {}).items()}
    elif os.path.isdir(src):
        for c in COLLS:
            for f in sorted(glob.glob(os.path.join(src, c, "*.json"))):
                out[c][os.path.splitext(os.path.basename(f))[0]] = unwrap(json.load(open(f, encoding="utf-8")))
    else:
        sys.exit(f"Zdroj {src} neexistuje.")
    return out


# ---------- převod hodnot ----------
def q(v):
    if v is None:
        return "NULL"
    if isinstance(v, bool):
        return "1" if v else "0"
    if isinstance(v, (int, float)):
        return repr(v) if isinstance(v, float) else str(v)
    s = str(v).replace("\\", "\\\\").replace("'", "''").replace("\n", "\\n").replace("\r", "\\r").replace("\x00", "\\0").replace("\x1a", "\\Z")
    return "'" + s + "'"


def d(v):
    return v if isinstance(v, str) and re.match(r"^\d{4}-\d{2}-\d{2}$", v) else None


def dt(v):
    if not isinstance(v, str):
        return None
    m = re.match(r"^(\d{4}-\d{2}-\d{2})T(\d{2}:\d{2}:\d{2})", v)
    return f"{m.group(1)} {m.group(2)}" if m else None


def i(v):
    try:
        return None if v in (None, "") else int(float(v))
    except (TypeError, ValueError):
        return None


def n(v):
    try:
        return None if v in (None, "") else round(float(v), 2)
    except (TypeError, ValueError):
        return None


def s(v, maxlen=None):
    if v in (None, ""):
        return None
    v = str(v)
    return v[:maxlen] if maxlen else v


def upsert(table, row, key=("id",)):
    cols = list(row)
    upd = ", ".join(f"{c} = VALUES({c})" for c in cols if c not in key) or f"{key[0]} = {key[0]}"
    return f"INSERT INTO {table} ({', '.join(cols)}) VALUES ({', '.join(q(row[c]) for c in cols)})\n  ON DUPLICATE KEY UPDATE {upd};"


def insert_many(table, rows):
    if not rows:
        return []
    cols = list(rows[0])
    vals = ",\n  ".join("(" + ", ".join(q(r[c]) for c in cols) + ")" for r in rows)
    return [f"INSERT INTO {table} ({', '.join(cols)}) VALUES\n  {vals};"]


# ---------- mapování kolekcí na tabulky ----------
def sql_vehicle(id_, x, _all):
    cat = x.get("category") if x.get("category") in ("truck", "machine", "car") else "truck"
    row = dict(id=id_, category=cat, spz=s(x.get("spz"), 20), name=s(x.get("name"), 120) or "(bez názvu)",
               model=s(x.get("model"), 120), year_made=i(x.get("year")), vin=s(x.get("vin"), 17),
               driver=s(x.get("driver"), 120), odometer=i(x.get("km")), odometer_set_at=dt(x.get("kmSetAt")),
               stk_until=d(x.get("stkDate")),
               oil_last_date=d(x.get("oilDate")), oil_last_odo=i(x.get("oilKm")),
               oil_every_odo=i(x.get("oilEveryKm")), oil_every_months=i(x.get("oilEveryMonths")),
               svc_last_date=d(x.get("svcDate")), svc_last_odo=i(x.get("svcKm")),
               svc_every_odo=i(x.get("svcEveryKm")), svc_every_months=i(x.get("svcEveryMonths")),
               notes=s(x.get("notes")), photo_ref=s(x.get("photo"), 64), created_at=dt(x.get("createdAt")))
    out = [upsert("vehicles", row), f"DELETE FROM vehicle_deadlines WHERE vehicle_id = {q(id_)};"]
    dl = [dict(vehicle_id=id_, position=k, name=s(c.get("name"), 150), due_date=d(c.get("date")))
          for k, c in enumerate(x.get("custom") or []) if c.get("name")]
    return out + insert_many("vehicle_deadlines", dl)


def sql_defect(id_, x, _all):
    row = dict(id=id_, vehicle_id=x.get("vehicleId"), description=s(x.get("text")) or "",
               severity="krit" if x.get("severity") == "krit" else "lehka",
               status=x.get("status") if x.get("status") in ("nova", "resi", "hotovo", "odlozeno") else "nova",
               odometer=i(x.get("km")), reported_by=s(x.get("by"), 64), reporter_name=s(x.get("byLabel"), 120),
               photo_ref=s(x.get("photo"), 64), service_note=s(x.get("note")), reported_on=d(x.get("date")),
               resolved_on=d(x.get("resolvedAt")), created_at=dt(x.get("createdAt")))
    return [upsert("defects", row)]


def sql_log(id_, x, _all):
    row = dict(id=id_, vehicle_id=x.get("vehicleId"), kind="repair" if x.get("kind") == "repair" else "service",
               done_on=d(x.get("date")), odometer=i(x.get("km")), done_text=s(x.get("done")),
               not_done_text=s(x.get("notDone")), labor_czk=n(x.get("labor")), created_by=s(x.get("by"), 64),
               created_at=dt(x.get("createdAt")))
    out = [upsert("service_records", row)]
    for t in ("service_record_tasks", "service_record_types", "service_record_parts", "service_record_defects"):
        out.append(f"DELETE FROM {t} WHERE record_id = {q(id_)};")
    out += insert_many("service_record_tasks", [dict(record_id=id_, task=s(t, 150)) for t in dict.fromkeys(x.get("tasks") or []) if t])
    out += insert_many("service_record_types", [dict(record_id=id_, work_type=s(t, 60)) for t in dict.fromkeys(x.get("types") or []) if t])
    out += insert_many("service_record_parts", [dict(record_id=id_, position=k, name=s(p.get("name"), 200), qty=n(p.get("qty")), price_czk=n(p.get("price")))
                                               for k, p in enumerate(x.get("parts") or []) if p.get("name")])
    out += insert_many("service_record_defects", [dict(record_id=id_, defect_id=f) for f in dict.fromkeys(x.get("fixed") or []) if f])
    return out


def sql_part(id_, x, all_):
    defect = x.get("defectId") if x.get("defectId") in all_["defects"] else None
    row = dict(id=id_, vehicle_id=x.get("vehicleId"), defect_id=defect, name=s(x.get("name"), 200) or "(díl)",
               qty=n(x.get("qty")) or 1, note=s(x.get("note"), 255),
               status=x.get("status") if x.get("status") in ("objednat", "objednano", "dorazilo") else "objednat",
               created_on=d(x.get("date")), ordered_on=d(x.get("orderedAt")), arrived_on=d(x.get("arrivedAt")),
               created_by=s(x.get("by"), 64), created_at=dt(x.get("createdAt")))
    return [upsert("part_orders", row)]


def sql_reading(id_, x, _all):
    if i(x.get("km")) is None:
        return []
    row = dict(vehicle_id=id_, odometer=i(x.get("km")), read_on=d(x.get("date")), read_at=dt(x.get("at")), read_by=s(x.get("by"), 64))
    return [upsert("odometer_readings", row, key=("vehicle_id",))]


def sql_order(id_, x, _all):
    row = dict(vehicle_id=id_, started_on=d(x.get("date")), odometer=i(x.get("km")), started_by=s(x.get("by"), 64))
    extra, checked, removed = (set(x.get(k) or []) for k in ("extra", "checked", "removed"))
    items = [dict(vehicle_id=id_, task=s(t, 150), is_extra=int(t in extra), is_checked=int(t in checked), is_removed=int(t in removed))
             for t in sorted(extra | checked | removed) if t]
    return [upsert("service_orders", row, key=("vehicle_id",)),
            f"DELETE FROM service_order_items WHERE vehicle_id = {q(id_)};"] + insert_many("service_order_items", items)


MAP = {  # kolekce: (tabulka, sloupec klíče, funkce)
    "vehicles": ("vehicles", "id", sql_vehicle),
    "defects": ("defects", "id", sql_defect),
    "log": ("service_records", "id", sql_log),
    "parts": ("part_orders", "id", sql_part),
    "readings": ("odometer_readings", "vehicle_id", sql_reading),
    "orders": ("service_orders", "vehicle_id", sql_order),
}
NEEDS_VEHICLE = {"defects": "vehicleId", "log": "vehicleId", "parts": "vehicleId", "readings": None, "orders": None}


def canon(x):
    return json.dumps(x, sort_keys=True, ensure_ascii=False)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("zdroj")
    ap.add_argument("--popis", default="")
    ap.add_argument("--nanecisto", action="store_true")
    a = ap.parse_args()

    cur = load(a.zdroj)
    old = json.load(open(STATE, encoding="utf-8")) if os.path.exists(STATE) else {c: {} for c in COLLS}
    up, down, summary, warn, skipped = [], [], [], [], []

    for c in COLLS:
        table, key, fn = MAP[c]
        new, prev = cur.get(c, {}), old.get(c, {})
        changed = [k for k in sorted(new) if canon(new[k]) != canon(prev.get(k))]
        removed = [k for k in sorted(prev) if k not in new]
        stmts = []
        for k in changed:
            vid = new[k].get(NEEDS_VEHICLE[c]) if NEEDS_VEHICLE.get(c) else (k if c in ("readings", "orders") else None)
            if vid is not None and vid not in cur["vehicles"]:
                warn.append(f"{c}/{k}: vozidlo {vid} neexistuje – přeskočeno")
                skipped.append((c, k))
                continue
            stmts += fn(k, new[k], cur)
        if stmts:
            up.append(f"-- {c}: {len(changed) - sum(1 for cc, _ in skipped if cc == c)} nových/změněných\n" + "\n".join(stmts))
        if removed:
            down.append(f"-- {c}: {len(removed)} smazaných\nDELETE FROM {table} WHERE {key} IN ({', '.join(q(k) for k in removed)});")
        ok = len(changed) - sum(1 for cc, _ in skipped if cc == c)
        if ok or removed:
            summary.append(f"{c}: {ok} nových/změněných, {len(removed)} smazaných")

    for w in warn:
        print("Varování:", w, file=sys.stderr)
    if not summary:
        print("Žádné změny dat – migrace není potřeba.")
        return
    print("\n".join(summary))
    if a.nanecisto:
        return

    nums = [int(m.group(1)) for f in os.listdir(MIG_DIR) for m in [re.match(r"^V(\d+)__", f)] if m]
    num = max(nums, default=0) + 1
    stamp = datetime.datetime.now().strftime("%Y%m%d_%H%M")
    name = f"V{num:03d}__data_{stamp}.sql"
    head = (f"-- {name}\n-- Data z náhledu převedená nástrojem nastroje/migrace.py.\n"
            + (f"-- {a.popis}\n" if a.popis else "")
            + "-- " + "\n-- ".join(summary) + "\n\nSET NAMES utf8mb4;\nSTART TRANSACTION;\n\n")
    body = "\n\n".join(up + list(reversed(down)))
    open(os.path.join(MIG_DIR, name), "w", encoding="utf-8").write(head + body + "\n\nCOMMIT;\n")
    for c, k in skipped:  # přeskočené zkusit znovu příště
        if k in old.get(c, {}):
            cur[c][k] = old[c][k]
        else:
            cur[c].pop(k, None)
    json.dump(cur, open(STATE, "w", encoding="utf-8"), ensure_ascii=False, indent=1, sort_keys=True)
    print(f"Zapsáno: db/migrace/{name}, aktualizován db/stav-dat.json")


if __name__ == "__main__":
    main()
