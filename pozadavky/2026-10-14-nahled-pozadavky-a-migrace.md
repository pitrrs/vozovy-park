---
id: 2026-10-14-nahled-pozadavky-a-migrace
nazev: Živý náhled, evidence požadavků a migrace do MySQL
typ: proces
autor: Broulick
datum: 2026-10-14
stav: v náhledu
---

## Co Broulick chtěl
Aby se Broulick mohl dívat živě, co si napromptoval: někde mají vznikat jeho požadavky a náhled. Finální aplikaci a infrastrukturu dělá Petr. Broulick má náhled s demo daty jako HTML a JS/CSS, a když tam zadá nějaká data, mají vznikat migrace na naplnění databáze MySQL 5.5.

## Jak to funguje v náhledu
- Požadavky jsou v repozitáři ve složce `pozadavky/` a v náhledu na stránce „Požadavky“.
- Náhled je ve složce `prototyp/` a publikuje se jako stránka na claude.ai s vlastními demo daty (odděleně od ostré aplikace).
- Data zadaná v náhledu převádí `nastroje/migrace.py` na SQL migrace v `db/migrace/`.

## Poznámky pro Petra
Schéma `db/migrace/V001__schema.sql` je návrh odvozený z prototypu – ke schválení a úpravě. Pojmenování migrací odpovídá konvenci Flyway (`V###__popis.sql`).
