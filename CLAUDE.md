# Kontext projektu pro Claude

Aplikace pro servis firemního vozového parku (cca 30 vozidel). Vznikla v konverzaci s Claude jako artefakt na claude.ai a pak byla převedena na samostatnou webovou aplikaci na Firebase. Uživatelé jsou Češi, celé UI je česky a hlavně se používá na telefonech s Androidem.

## Dvě verze

- **Kořen repa = verze pro vlastní web** (Firebase Auth + Firestore, PWA). Toto je hlavní verze, na ní se dál pracuje.
- **`claude-verze/servis-vozu.html`** = původní artefakt na claude.ai (běží přes `window.claude` capability `db`/`assets`/`user`). Jen pro referenci. Při změnách funkcí historicky upravujeme obě verze stejně.

Obě verze sdílejí stejný kód UI; liší se jen startem (`boot()`), datovou vrstvou a fotkami. Ve Firebase verzi je `db` tenký obal nad Firestore se stejným API (`collection().where().orderBy().limit().onSnapshot()`, `doc().set/update/delete`), takže zbytek kódu je společný.

## Role

- **Servis** – upravuje vše (vozy, servisní kniha, opravy, stav závad a dílů, uživatelé).
- **Řidič** – hlásí závady (s fotkou), zapisuje km, přidává díly k objednání.
- Firebase: přístup podle seznamu e-mailů v dokumentu `settings/access` (`service`, `drivers`); první přihlášený se stane správcem. Pravidla v `firestore.rules`.

## Datový model (kolekce)

- `vehicles` – SPZ, název, typ, VIN, řidič, `category` (`truck` nákladní / `machine` stavební stroj / `car` osobní), `km` + `kmSetAt` (ruční přepis km má přednost), STK, olej a servis (datum, km, intervaly), vlastní termíny `custom[]`, `photo`.
- `defects` – závada: `vehicleId`, `text`, `severity` (`krit`/`lehka`), `status` (`nova`/`resi`/`hotovo`/`odlozeno`), `km`, `photo`, `note`, `resolvedAt`.
- `log` – servisní záznam nebo oprava: `kind` (`service`/`repair`), `tasks[]` (checklist úkonů), `types[]`, `done`, `notDone`, `parts[]` (název, ks, cena), `labor`, `fixed[]` (id opravených závad).
- `orders` – rozpracovaný servis s checklistem, id = id vozidla: `checked[]`, `extra[]`, `removed[]`.
- `parts` – objednávky dílů: `status` (`objednat`/`objednano`/`dorazilo`), `defectId`, `qty`, `note`.
- `readings` – poslední stav km/mth, id = id vozidla.
- `photos` (jen Firebase) – fotky jako zmenšený JPEG v data URL.

## Hlavní obrazovky

Hlavní stránka: přepínač skupin (Vše / Nákladní vozy / Stavební stroje / Osobní auta), Všechny závady, Co se opravilo (celá historie servisů a oprav po měsících), Objednávky dílů, Co nás čeká (termíny do 30 dní nebo do 3 000 km / 50 mth), Rozpracované servisy, Kritické závady, seznam vozidel.

Karta vozu: termíny, záložky Závady / Servisní kniha / Opravy, checklist servisu (lze odebírat položky), tlačítka Zahájit servis, Zapsat opravu, Zapsat km, Upravit vůz.

Checklist základních úkonů (`TASKS`): motorový olej, vzduchový / palivový / naftový filtr na motoru / olejový filtr, odstředivka, olej v nápravě 1–5, převodovka, sestup.

## Dohodnutá pravidla a poučení

- Stavební stroje se počítají v motohodinách (mth), ne v km.
- Vyřešená závada se přesouvá ze Závad do Oprav; kritické závady jsou na hlavní stránce.
- Nepoužívat `window.confirm/alert` – v artefaktu na claude.ai jsou blokované; místo nich `askConfirm()`.
- V artefaktu na claude.ai má dotaz `limit()` maximum 1000 (vyšší hodnota rozbila načítání závad).
- Mobilní aplikace Claude na Androidu neotevře výběr souboru → fotky v artefaktu jen přes prohlížeč; Firebase verze tento problém nemá.
- Uživatel chce stručné, praktické změny; každou změnu dělat v obou verzích.
