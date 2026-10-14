# Pravidla projektu pro Claude

Tento soubor čte Claude na začátku každého sezení. **Pravidla v sekci „Spolupráce“ mají přednost před vším ostatním.**

## Lidé v projektu

- **Broulick** – zadavatel, provozuje servis. Na IT je úplný začátečník a sám to o sobě říká. Píše své nápady a domněnky („chtěl bych, aby…“), ne technická zadání. Pracuje přes **Claude Code na notebooku nebo PC**, ne přes chat a ne přes mobil.
- **Petr** – zkušený programátor. Broulickovy nápady upřesňuje a vede celý projekt: architekturu, buildy, nasazení, Firebase a schvalování změn.

Na začátku sezení zjisti, s kým mluvíš. Když to nevyplývá z první zprávy, zeptej se jednou krátce: „Jsi Broulick, nebo Petr?“

### Jak mluvit s Broulickem
- Česky, jednoduše, bez žargonu. Když technický pojem použít musíš (větev, commit, pull request), vysvětli ho jednou větou.
- Veď ho krok za krokem: řekni, co uděláš, a na konci, co má udělat on (např. „otevři aplikaci a zkus přidat závadu“).
- Jeho zadání ber jako domněnku. Když je nejasné, polož jednu konkrétní otázku s možnostmi; neodbíhej do technických variant.
- Nikdy po něm nechtěj spouštět příkazy v terminálu. Všechno s gitem děláš ty.
- Když navrhuje něco, co by rozbilo data nebo bezpečnost, řekni mu to lidsky a navrhni, ať to probere s Petrem.

### Jak mluvit s Petrem
- Technicky a stručně. Petr rozhoduje o architektuře, závislostech, buildu a nasazení; jeho upřesnění má přednost před Broulickovým původním zadáním.

## Spolupráce a git (povinné)

### Na začátku každého sezení
1. `git fetch --all --prune` a aktualizuj `main` (`git pull --ff-only`).
2. Podívej se na ostatní větve a otevřené pull requesty. Stručně řekni, na čem kdo pracuje, ať nevznikají dvě verze téže změny.
3. Když navazuješ na existující větev, nejdřív ji stáhni a aktualizuj proti `main` (rebase).

### Každá změna musí skončit v repozitáři
- Na `main` se nikdy necommituje přímo. Každá změna má **vlastní větev** a **pull request** do `main`.
- Po každém dokončeném kroku: commit → push větve. Nic nesmí zůstat jen v sezení.
- Před koncem sezení zkontroluj, že je vše pushnuté (`git status` čistý, větev není napřed před `origin`).

### Slučování do `main`
- Merge jen po **výslovném odsouhlasení** v konverzaci („ano, sluč to“) od Broulicka nebo Petra.
- Změny datového modelu, `firestore.rules`, přihlašování, `firebase.json`, buildu nebo nasazení schvaluje **Petr**.
- Před merge: rebase na aktuální `main`, kontrola syntaxe JS (`node --check` na vytaženém skriptu), po merge smaž větev lokálně i na GitHubu.
- Preferovaný způsob: squash merge s pojmenovaným commitem podle pravidel níže.

### Práce z mobilu
Když někdo (typicky Broulick) začne něco řešit z mobilu:
- připomeň mu jednou vlídně, že projekt se má dělat z notebooku/PC,
- změnu udělej v nové větvi s prefixem `mobil/` (např. `mobil/fix-tlacitko-smazat`), pushni ji a otevři pull request,
- **nic neslučuj** – merge proběhne až později na straně Petra nebo Broulicka (z PC) po odsouhlasení.

### Pojmenování
- **Větve:** `typ/kratky-popis` malými písmeny bez diakritiky, slova pomlčkou. Typy: `feat/` nová funkce, `fix/` oprava chyby, `docs/` dokumentace, `refactor/` úprava kódu bez změny chování, `chore/` údržba, `mobil/` změna z mobilu. Příklad: `feat/objednavky-dilu`.
- **Commity a názvy PR:** `typ: popis česky v rozkazovacím způsobu`, max. ~70 znaků. Příklad: `fix: oprav mazání závady na kartě`. Do těla commitu napiš proč a co se změnilo pro uživatele.
- **Popis PR:** co se změnilo z pohledu uživatele aplikace, co je potřeba udělat po nasazení (např. „vložit nová firestore.rules“) a jak to otestovat.

### Údržba gitu
- Malé, logicky ucelené commity; jedna větev = jedna věc.
- Žádné soubory s daty, hesly, zálohami ani `node_modules` (viz `.gitignore`). `config.js` obsahuje jen veřejné klíče Firebase.
- Po sloučení mazat větve. Sezení Claude nemusí mít právo mazat větve na GitHubu – pak požádej toho, kdo slučoval, ať v pull requestu klikne na **Delete branch**. Staré nesloučené větve (starší než ~2 týdny) připomenout Petrovi.
- Nepřepisovat historii `main` (žádný force-push na `main`).
- Když změna vyžaduje krok mimo git (nové `firestore.rules`, nasazení, publikace artefaktu na claude.ai), napiš to do PR a řekni to uživateli.

---

# Kontext projektu

## Směr projektu: Flutter

- Aplikace se bude dál vyvíjet v **Dart / Flutter**, aby byla multiplatformní (Android, iOS, web).
- **Architekturu vede Petr.** Volbu správy stavu, backendu, struktury projektu, balíčků, buildů a nasazení nenavrhuj jako hotovou věc – připrav podklady a nech rozhodnutí na Petrovi.
- Současné HTML verze (kořen repa a `claude-verze/`) jsou **funkční prototyp a specifikace**: popisují, co aplikace umí a jak se chová. Nové funkce do nich přidávej jen na výslovné přání.
- Broulickovy nápady zapisuj tak, aby je Petr mohl převzít do Flutteru (co má uživatel vidět a dělat, ne jak to naprogramovat).

Aplikace pro servis firemního vozového parku (cca 30 vozidel). Vznikla v konverzaci s Claude jako artefakt na claude.ai a pak byla převedena na samostatnou webovou aplikaci na Firebase. Uživatelé jsou Češi, celé UI je česky a hlavně se používá na telefonech s Androidem.

## Dvě verze

- **Kořen repa = verze pro vlastní web** (Firebase Auth + Firestore, PWA). Do přechodu na Flutter je to hlavní funkční verze.
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
- Pokud se ještě mění HTML prototyp, dělat změny v obou verzích (kořen repa i `claude-verze/`). Artefakt na claude.ai se publikuje jen ze sezení Broulicka, který ho vlastní – v jiném sezení jen uprav soubor a upozorni na to.
