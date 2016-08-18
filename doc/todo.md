# TODO List

## Allgemein
    1. Validierungen
        1. Mehr Validierungsregeln implementieren
    2. Tableprefix variabel gestalten
    3. Formbuilder
    4. getUserInformation zentral ablegen | Aktuell mehrfach identisch vorhanden ?
        * user informationen für den ajax JSON Rückweg vorbereiten
    5. Installationssystem
        * Datasources bei der Installation im cfAdmin eintragen
    6. Updatesystem
    7. Repairmodus ?
    8. Lizenzen von Assets und Plugins überprüfen
    9. Mehrsprachigkeit/Internationalisierung
        * i18n
        * i10n
    10. F5-Raids bei Formularen unterbinden
    11. FileUpload, etc in eine Extra-Component aus dem Model auslagern
    12. Pakete
        * Alles
        * Blog
        * Gallerie
        * Marketing/Produkt
    13. QueryBuilder zur Unterstützung verschiedener DB-Systeme
        * Idee und erste Doku unter QueryBuilder-idea-notes.md
    14. Zusätzliche Optionen
        * Berechtigungssystem auf Menüpunkte ausweiten
    15. Erweiterte Sicherheit in Modulen
        * Personen freischalten => Nur normales Editieren
    16. Eigenes Date objekt? Date auch als null möglich | date.format() möglich
    17. required approvals
    18. +Attribut zu Module => Uses permissions (if false hide in permission screens)
    19. Globale Tasklist (dashboard | com.IcedReaper.tileDashboard) variabel gestalten

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
        * CustomTag path im cfadmin eintragen
    4. Backup
        * https://www.postgresql.org/docs/9.3/static/app-pgdump.html
    5. Sidebar auf Icons reduzieren
    6. Assets weiter optimieren/reduzieren
    7. Dashboard pro User variabel gestaltbar machen
        * Anordnung
        * Module
    8. Alle (asset) js Files in der index.cfm laden
    9. Responsiveanpassungen
    10. Design schick machen

## Module (in eigenen Repos/Projekten)
    1. Gallery
        1. Weitere Möglichkeiten
            * Kommentarmöglichkeit
            * Release Date - Was machen wenn die Gallerie bis dahin noch nicht im Status online ist?
            * Bewertungen
                * Anonym per Option
                * Als eingeloggter User
        2. Statistiken pro Bild
            - Jegliche Idee zum Erfassen der Daten sind bisher crap
                * Für onSlideEnd von blueimp image gallery muss per jQuery der Filename ausgelesen werden
                * ColdFusion liefert nicht ohne weiteres Bilder aus - ich hab noch nix ergoogled - ggf Lucee-Forum anfunken
                * imageServer.cfm?i=imagePage.jpg (Wohl beste aber auch nicht so das wahrste) | übern nginx drehen
    2. Blog
        1. Mögliche Verbesserungen:
            * File resizing after upload is only applied by width and height attributes
        2. Kommentarmöglichkeit
            * Verschachtelte Kommentarmöglichkeit
        3. Adaptionen in der Übersicht
            * Kalenderübersicht hinzufügen => Klick auf Datum => zeigt alle Posts des Tages
    3. Review
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
    4. Preis/Leistung
    5. YouTube Videoliste
        * Designauswahl
    6. Facebookpostfeed
        * Facebook pageId
        * Anzahl der posts
        * Designauswahl
    7. Schnittstelle zu Twitter
        * Username
        * Anzahl der Tweets
        * Designauswahl
    8. Schnittstelle zu Last.fm
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
    9. Schnittstelle zu Flickr
        (ggf in das Modul com.IcedReaper.gallery inkludieren)
        * UserId
        * AlbumId oder -name
        * Designauswahl
        * Upload der Bilder direkt nach Flickr. Erstellt das Album auf beiden Plattformen (API checken)
    10. Schnittstelle zu DeviantArt
        (ggf in das Modul com.IcedReaper.gallery inkludieren)
        * UserId
        * AlbumId oder -name
        * Designauswahl
    11. Downloadmodul
        * Kategorien
        * Tags
        * Suche
        * Admintool
        * Übersicht
        * Anzeige der letzten 4 Suchbegriffe
    12. Adminchat
        * Globaler Channel
        * Private Chats/Channel
    13. Private Nachrichten
        * Infos zu neuen Nachrichten per Websockets melden
    14. Admintaskliste (Aufgabenverwaltung)
         * private / globale tasks
         * Status
             * Offen
             * in Bearbeitung
             * geschlossen
         * "PostIt"-Setup des Desktops
    15. com.IcedReaper.tileDashboard
        * Anzahl an offenen Tasks (Gute Idee fehlt zum Managen der Module, die, und wie, eine Taskliste haben)

## Optimierungen
    1. Datenbank optimieren
    2. (CFIDE/LuceeAdmin) Serversettings in Applikation verankern
    3. Check handling of not found results for twitch and youtube. Check if it's best to throw an error or set a status and check it
    4. Verwendung von nicht Klassenattributen (z.B. request.user) aus den Klassen entfernen und als Parameter erwarten
    5. ggf. setter der Objekte "neue" Werte aktualisieren und bei speichern in die originalen übertragen.
    6. Charts responsive mit maxHeight!?
    7. Checkout Lucee REST Servlet (web.xml)
    8. Client Side validation für Formulare
    9. Check: Komponenten umbauen: Load nur noch ausführen, wenn nur ID angegeben ist | Init mit allen parametern ausstatten / alle außer ID auf default => in variables umbauen | Ermöglicht Parent in Child object ohne Endlosschleife