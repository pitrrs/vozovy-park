#!/usr/bin/env python3
"""Přegeneruje přehled požadavků.

Čte pozadavky/*.md (front matter + sekce) a zapíše:
  - pozadavky/README.md   – tabulka pro GitHub
  - prototyp/pozadavky.js – data pro stránku „Požadavky“ v náhledu

Spuštění z kořene repozitáře:  python3 nastroje/pozadavky.py
"""
import json, os, re, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, "pozadavky")
STAVY = ["nový", "upřesňuje Petr", "v náhledu", "schváleno Petrem", "hotovo ve Flutteru", "zamítnuto"]


def parse(path):
    text = open(path, encoding="utf-8").read()
    m = re.match(r"^---\n(.*?)\n---\n(.*)$", text, re.S)
    if not m:
        sys.exit(f"Chybí hlavička (---) v {path}")
    meta = {}
    for line in m.group(1).splitlines():
        if ":" in line:
            k, v = line.split(":", 1)
            meta[k.strip()] = v.strip()
    for k in ("id", "nazev", "stav", "datum"):
        if k not in meta:
            sys.exit(f"Chybí pole '{k}' v {path}")
    if meta["stav"] not in STAVY:
        sys.exit(f"Neznámý stav '{meta['stav']}' v {path} (povolené: {', '.join(STAVY)})")
    sekce = {}
    for part in re.split(r"^## ", m.group(2), flags=re.M)[1:]:
        title, _, body = part.partition("\n")
        sekce[title.strip()] = body.strip()
    meta["soubor"] = os.path.basename(path)
    meta["chtel"] = sekce.get("Co Broulick chtěl", "")
    meta["nahled"] = sekce.get("Jak to funguje v náhledu", "")
    meta["petr"] = sekce.get("Poznámky pro Petra", "")
    return meta


def main():
    items = [parse(os.path.join(SRC, f)) for f in sorted(os.listdir(SRC))
             if f.endswith(".md") and f != "README.md"]
    items.sort(key=lambda x: (x["datum"], x["id"]), reverse=True)

    js = "// Generováno nástrojem nastroje/pozadavky.py – neupravovat ručně.\n"
    js += "window.POZADAVKY = " + json.dumps(items, ensure_ascii=False, indent=1) + ";\n"
    open(os.path.join(ROOT, "prototyp", "pozadavky.js"), "w", encoding="utf-8").write(js)

    rows = ["| Datum | Požadavek | Typ | Stav |", "|---|---|---|---|"]
    for x in items:
        rows.append(f"| {x['datum']} | [{x['nazev']}]({x['soubor']}) | {x.get('typ','')} | {x['stav']} |")
    readme = f"""# Požadavky

Každý požadavek je jeden soubor. Nové soubory pojmenovávej `RRRR-MM-DD-kratky-popis.md`
(datum zabrání kolizím mezi větvemi). Soubory `H01…H23` jsou zpětně doplněná historie.

Stavy: {' → '.join(STAVY[:5])}, případně {STAVY[5]}.

Tento přehled se generuje: `python3 nastroje/pozadavky.py` (neupravovat ručně).

{chr(10).join(rows)}
"""
    open(os.path.join(SRC, "README.md"), "w", encoding="utf-8").write(readme)
    print(f"{len(items)} požadavků → pozadavky/README.md, prototyp/pozadavky.js")


if __name__ == "__main__":
    main()
