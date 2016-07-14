# TODO List

## Actual Task TODO - Reminder:
- required approvals
- User ext property keys mit typen versehen: date, etc (Geburtstag => date ==> datepicker)
- User ext properties mit sortierung versehen
- +Attribut zu Module => Uses permissions (if false hide in permission screens)
- Role zu Object umändern (permissionManager umbauen)
- Tasklist for user-module

## Allgemein
    1. Validierungen
        1. Mehr Validierungsregeln implementieren
    2. Tableprefix variabel gestalten
    3. Formbuilder
    4. getUserInformation zentral ablegen | Aktuell mehrfach identisch vorhanden ?
        * user informationen für den ajax JSON Rückweg vorbereiten
    5. Installationssystem
        * Datasources bei der Installation in einer JSON Datei ablegen und in den Applications auslesen
    6. Updatesystem
    7. Repairmodus ?
    8. Lizenzen von Assets und Plugins überprüfen
    9. Mehrsprachigkeit/Internationalisierung
        * i18n
        * i10n
    10. user => username überprüfen
    11. user => blacklist erstellen | Innerhalb des Username überprüfen
    12. F5-Raids bei Formularen unterbinden
    13. FileUpload, etc in eine Extra-Component aus dem Model auslagern
    14. Pakete
        * Alles
        * Blog
        * Gallerie
        * Marketing/Produkt
    15. QueryBuilder zur Unterstützung verschiedener DB-Systeme
        * Idee und erste Doku unter QueryBuilder-idea-notes.md
    16. Zusätzliche Optionen
        * Berechtigungssystem auf Menüpunkte ausweiten
    17. Erweiterte Sicherheit in Modulen
        * Personen freischalten => Nur normales Editieren
        *
    18. API-Statistics wie page.filter allen Modulen hinzufügen. - abwägen, und nach und nach
    19. Eigenes Date objekt? Date auch als null möglich | date.format() möglich

## Website
    1. Codeoptimierung
    2. Formvalidierung

## Adminbereich
    1. Modulverwaltung
        * Installation
            1. Fileupload von einer zip/rar-Datei (siehe theme installation)
            2. Installation per git-repository
            3. Module-Modul überarbeiten: Neues Modul => Installation
        * Bugs und benötigte Features
            * Berechtigungen
            * Untermodule (Children)
    2. Seitenmanagement
        1. Mehrsprachigkeit des Contents
        2. Autospeichern (Setzt Versionierung voraus | Problem: Bei normalem Vorgehen wird die Aktuelle Version überschrieben. Es sollte allerdings eine temporäre Version angelegt werden, die nach normalem Speichern wieder gelöscht wird.)
        3. Vorschau funktioniert aktuell nur für die Seite und nicht auch für Unterseiten
        4. Themeswitch in Vorschau
        5. Sitemap zum Zeitpunkt X releasen
    3. Thememanagement
        * Installation
            - Per git Repo
            - Per zip/rar
        * Update
            - Per git Repo mit Branch/tag
            - per zip
    4. Backup
        * https://www.postgresql.org/docs/9.3/static/app-pgdump.html
    5. Errorlog
    6. Sidebar auf Icons reduzieren
    7. Assets weiter optimieren/reduzieren
    8. Dashboard pro User variabel gestaltbar machen
        * Anordnung
        * Module
    9. Alle (asset) js Files in der index.cfm laden
    10. Responsive anpassungen
    11. Design schick machen

## Module (in eigenen Repos/Projekten)
    1. Gallery
        1. Weitere Möglichkeiten
            * Kommentarmöglichkeit
            * Release Date - Was machen wenn die Gallerie bis dahin noch nicht im Status online ist?
            * Bewertungen
                * Anonym per Option
                * Als eingeloggter User
            * Bilderupload umbauen, sodass alle Bilder (5/10, wie auch immer) zusammen hochgeladen werden
                * Aktuell werden alle parallel hochgeladen, was dazu führt, dass ab einer gewissen Menge der JavaHeap vollläuft und es elendig langsam ist.
        3. Statistiken pro Bild
            - Jegliche Idee bisher ist crap
                * Für onSlideEnd von blueimp image gallery muss per jQuery der Filename ausgelesen werden
                * ColdFusion liefert nicht ohne weiteres Bilder aus - ich hab noch nix ergoogled - ggf Lucee-Forum anfunken
                * imageServer.cfm?i=imagePage.jpg (Wohl beste aber auch nicht so das wahrste) | übern nginx drehen
        4. Einstellungen wie im Blog-Modul
    2. Blog
        1. Mögliche Verbesserungen:
            * File resizing after upload is only applied by width and height attributes
            * F5-Raiding beim Abschicken des Kommentars möglich (Siehe Allgemein 12)
        2. Kommentarmöglichkeit
            * Verschachtelte Kommentarmöglichkeit
        3. Adaptionen in der Übersicht
            * Kalenderübersicht hinzufügen => Klick auf Datum => zeigt alle Posts des Tages
        4. "Gallerie" am Ende hinzufügbar machen
    3. Reviewsystem
        => genre in tags umbenennen
        => Type in Kategorie umbennen
        * review edit
            * Fileupload im Text
        * Publish by state and/or date
        * ? Unterbewertungen (Spätere Version)
        * Optionen
            * Maximale Punkte
            * Punkteanzeige
                * Sterne
                * Ausgeschrieben
        * Statistiken
        * Admin schön machen
    4. Referenzen
    5. Preis/Leistung
    6. YouTube Videoliste
        * Designauswahl

    7. Facebookpostfeed
        * Facebook pageId
        * Anzahl der posts
        * Designauswahl

    8. Schnittstelle zu Twitter
        * Username
        * Anzahl der Tweets
        * Designauswahl
    
    9. Schnittstelle zu Last.fm
        * Username
        * Anzahl der Scrobbles
        * Last Scrobbles
        * Top Artists
            * Total
            * Zeitraum
        * Top Alben
            * Total
            * Zeitraum
        * Top Songs
            * Total
            * Zeitraum
        * Ggf Authentifizierung
        * Designauswahl
    
    10. Schnittstelle zu Flickr
        (ggf in das Modul com.IcedReaper.gallery inkludieren)
        * UserId
        * AlbumId oder -name
        * Designauswahl
        * Upload der Bilder direkt nach Flickr. Erstellt das Album auf beiden Plattformen (API checken)
    
    11. Schnittstelle zu DeviantArt
        (ggf in das Modul com.IcedReaper.gallery inkludieren)
        * UserId
        * AlbumId oder -name
        * Designauswahl
    
    12. Downloadmodul
        * Kategorien
        * Tags
        * Suche
        * Admintool
        * Übersicht
        * Anzeige der letzten 4 Suchbegriffe
    
    13. Adminchat
        * Globaler Channel
        * Private Chats/Channel
    
    14. Private Nachrichten
        * Infos zu neuen Nachrichten per Websockets melden
    
    15. Admintaskliste (Aufgabenverwaltung)
         * private / globale tasks
         * Status
             * Offen
             * in Bearbeitung
             * geschlossen
        * "PostIt"-Setup des Desktops
    
    16. com.IcedReaper.tileDashboard
        * Anzahl an offenen Tasks (Gute Idee fehlt zum Managen der Module, die, und wie, eine Taskliste haben)

## Optimierungen
    1. Datenbank optimieren
    2. Aktuell gibt es sowohl creationDate als auch createdDate => gleichziehen!!!
    3. Tabellenprefix in Application verankern. Aus Datei auslesen.
    4. Datasources aus Datei auslesen.
    5. (CFIDE/LuceeAdmin) Serversettings in Applikation verankern
    6. Check handling of not found results for twitch and youtube. Check if it's best to throw an error or set a status and check it
    7. Verwendung von nicht Klassenattributen (z.B. request.user) aus den Klassen entfernen und als Parameter erwarten
    8. Berechtigungen (Admin, Editor, User) in Module einbauen
    9. Creator und lastEditor direkt als Objekte in Objekten erstellen
    10. ggf. setter der Objekte "neue" Werte aktualisieren und bei speichern in die originalen übertragen.
    11. Charts responsive mit maxHeight!?
    12. Checken, ob man Loading Bar und Error Message Box irgendwie Global verankern kann
    13. Checkout Lucee REST Servlet (web.xml)
    14. Client Side validation für Formulare