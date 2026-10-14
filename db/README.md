# Databáze (MySQL 5.5)

- `migrace/V001__schema.sql` – schéma, **návrh** odvozený z prototypu, schvaluje Petr.
- `migrace/V###__data_*.sql` – data zadaná v náhledu, generuje `nastroje/migrace.py`. Každá migrace obsahuje jen rozdíl proti předchozí (upsert přes `INSERT … ON DUPLICATE KEY UPDATE`, mazání přes `DELETE`), je v transakci a dá se spustit nad databází, kde proběhly všechny předchozí migrace.
- `stav-dat.json` – data ve stavu po poslední migraci; podle něj se počítá rozdíl. Upravuje ho jen `migrace.py`.

Pojmenování odpovídá Flyway (`V###__popis.sql`), migrace jdou spustit i ručně v pořadí čísel:

```bash
for f in db/migrace/V*.sql; do mysql -u UZIVATEL -p DATABAZE < "$f"; done
```

Fotky se do databáze nepřenáší, `photo_ref` je jen odkaz na soubor v úložišti náhledu.

Migrace zatím nebyly spuštěné proti skutečné instanci MySQL 5.5 (v prostředí Claude není k dispozici) – první spuštění prosím ověřit.
