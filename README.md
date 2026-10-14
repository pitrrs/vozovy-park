# Vozový park – servis

Webová aplikace pro evidenci servisu nákladních vozů, stavebních strojů a osobních aut: závady od řidičů, servisní kniha s checklistem úkonů, opravy, objednávky dílů a hlídání termínů (STK, olej, servis).

## Struktura

| Soubor | Co to je |
|---|---|
| `index.html` | Celá aplikace (HTML + CSS + JS v jednom souboru) |
| `config.js` | Přihlašovací údaje k Firebase projektu – **vyplnit** |
| `firestore.rules` | Bezpečnostní pravidla databáze – vložit do Firebase konzole |
| `firebase.json` | Nastavení pro `firebase deploy` |
| `manifest.webmanifest`, `sw.js`, `icon-*.png` | Instalace na plochu telefonu a offline režim |
| `NAVOD.md` | Návod ke spuštění krok za krokem |
| `claude-verze/` | Původní verze běžící na claude.ai (jen pro referenci, nenasazuje se) |

## Spuštění

Postup je v [NAVOD.md](NAVOD.md). Ve zkratce: založit Firebase projekt, zapnout přihlašování e-mailem a Firestore, vložit `firestore.rules`, vyplnit `config.js` a nasadit (Netlify nebo `firebase deploy`).

Lokálně stačí jakýkoli statický server, např. `npx serve .` – otevírat přes `http://localhost`, ne přímo jako soubor.

## Práce ve více lidech

Pravidla spolupráce (větve, pull requesty, pojmenování, práce z mobilu) jsou v [CLAUDE.md](CLAUDE.md). Ve zkratce: každá změna ve vlastní větvi, pull request do `main`, sloučení až po odsouhlasení.
