# Servis vozového parku – návod ke spuštění

Aplikace běží na **Firebase** od Googlu (databáze, přihlašování) a funguje na telefonech jako normální aplikace na ploše. Pro vaši velikost (30 vozů, desítky lidí) stačí bezplatný tarif. Nastavení zabere zhruba 20 minut a nic se nemusí instalovat do počítače.

## 1. Založte projekt ve Firebase

1. Otevřete **https://console.firebase.google.com** a přihlaste se Google účtem firmy.
2. Klikněte **Vytvořit projekt** (Create project), pojmenujte ho např. `servis-vozu`. Google Analytics můžete vypnout.

## 2. Zapněte přihlašování

1. V levém menu **Build › Authentication › Začínáme** (Get started).
2. Záložka **Sign-in method** › **E-mail/heslo** › zapnout › Uložit.

## 3. Vytvořte databázi

1. **Build › Firestore Database › Vytvořit databázi**.
2. Umístění: **europe-west3 (Frankfurt)**. Režim: **produkční** (production mode).
3. Po vytvoření otevřete záložku **Pravidla** (Rules), smažte vše, vložte celý obsah souboru `firestore.rules` a klikněte **Publikovat**.

## 4. Propojte aplikaci s projektem

1. Ozubené kolečko vlevo nahoře › **Nastavení projektu** › dole **Vaše aplikace** › ikona **`</>`** (Web).
2. Zadejte název (např. `servis`), hosting nezaškrtávejte, klikněte **Zaregistrovat**.
3. Zobrazí se `firebaseConfig = { apiKey: ..., ... }`. Otevřete soubor **`config.js`** (Poznámkovým blokem) a nahraďte hodnoty svými. Uložte.

## 5. Dejte aplikaci na internet

Nejjednodušší je **Netlify Drop** (zdarma):

1. Otevřete **https://app.netlify.com/drop** a zaregistrujte se.
2. Přetáhněte do okna **celou složku** s aplikací.
3. Dostanete adresu typu `https://nejake-jmeno.netlify.app`. V nastavení webu (Site configuration › Change site name) ji můžete přejmenovat, např. `servis-firma.netlify.app`.

Poslední krok ve Firebase: **Authentication › Settings › Authorized domains › Add domain** a vložte adresu z Netlify bez `https://` (např. `servis-firma.netlify.app`).

> Změny aplikace později nahrajete stejně – přetáhnete složku znovu v Netlify (Deploys › Drag and drop).
>
> Kdo umí s příkazovou řádkou, může místo Netlify použít Firebase Hosting: `npm i -g firebase-tools`, `firebase login`, `firebase init` (vybrat existující projekt, nic nepřepisovat), `firebase deploy`. Soubor `firebase.json` je připravený.

## 6. První spuštění

1. Otevřete adresu aplikace, klikněte **Nemám účet – registrovat** a vytvořte si účet.
2. Aplikace nabídne **Stát se správcem** – potvrďte. Tím jste servis s plnými právy.
3. Vpravo nahoře **Uživatelé** – zapište e-maily:
   - **Servis**: kdo zapisuje servisy, upravuje vozy a řeší závady.
   - **Řidiči**: kdo hlásí závady, fotí je a zapisuje km.
4. Pošlete lidem adresu. Každý se zaregistruje **přesně tím e-mailem**, který jste zapsali.

## 7. Aplikace na plochu telefonu

- **iPhone (Safari):** otevřít adresu › tlačítko Sdílet › **Přidat na plochu**.
- **Android (Chrome):** otevřít adresu › menu ⋮ › **Instalovat aplikaci** / Přidat na plochu.

Pak se otevírá jako samostatná aplikace s ikonou náklaďáku. Funguje i při slabém signálu – změny se odešlou, jakmile bude připojení.

## Dobré vědět

- **Fotky** se zmenšují a ukládají přímo do databáze, takže není potřeba placené úložiště. Nově je mohou nahrávat i řidiči.
- **Bezplatný tarif** Firebase (Spark) dává 1 GB dat a 50 000 čtení denně – na 30 vozů bohatě stačí. Pokud byste ho někdy překročili, aplikace do půlnoci jen přestane načítat; nic se neztratí ani nezaplatí.
- **Zapomenuté heslo** si každý obnoví sám na přihlašovací obrazovce.
- **Odebrání člověka**: smažte jeho e-mail v **Uživatelé** – přístup ztratí okamžitě.
- **Data z verze v Claude** se nepřenášejí – vozy zadejte znovu.
