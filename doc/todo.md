# TODO List

## Actual Task TODO - Reminder:
- required approvals
- Hardcoded /user & /search Links fixen... => move to system settings... but what when the page isn't part of the sitemap?
- setting in config umbenennen?

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
    13. Beim Anlegen von neuen Datensätzen werden die UserIds und die Datumfelder im variables scope nicht aktualisiert
    14. FileUpload, etc in eine Extra-Component aus dem Model auslagern
    15. Pakete
        * Alles
        * Blog
        * Gallerie
        * Marketing/Produkt
    16. QueryBuilder zur Unterstützung verschiedener DB-Systeme
        * Idee und erste Doku unter QueryBuilder-idea-notes.md
    17. Zusätzliche Optionen
        * Berechtigungssystem auf Menüpunkte ausweiten
    18. Erweiterte Sicherheit in Modulen
        * Personen freischalten => Nur normales Editieren
        *
    19. API-Statistics wie page.filter allen Modulen hinzufügen. - abwägen, und nach und nach

## Website
    1. Codeoptimierung
    2. Userverwaltung ?
        * User darf nur sich selber bearbeiten können
    3. Was passiert, wenn eine View in einem Theme für ein Modul nicht vorhanden ist?
        * Check im Admin einbauen
            * Weitere Views (für neue Themes) nachinstallieren?
        * Check im WWW einbauen => Wenn nicht gefunden im Default Theme anzeigen
            * Was passiert, wenn es auch da nicht vorhanden ist? Auslassen und Fehlerloggen? Fehler schmeißen?

## Adminbereich
    1. Modulinstallation
        1. Fileupload von einer zip/rar-Datei (siehe theme installation)
            * Entpacken dieser in die 4 nötigen Ordner Frontend/Backend Admin/Website
        2. Installation per git-repository
        3. Module-Modul überarbeiten: Neues Modul => Installation
    2. Seitenmanagement
        1. Mehrsprachigkeit des Contents
        2. Autospeichern (Setzt Versionierung voraus)
        3. Vorschau
            * Template in ADMIN, welches ein Template in WWW inkludiert, wo dann die richtigen Sachen angezeigt werden; dann halt nur auch schon nicht veröffentlichte Sachen.
    3. Thememanagement
        1. Themeinstallation per git repository
            * Check ob alle Module in dem Theme vorhanden sind. Sonst Warnung
    4. Modul-Theme-Management
        1. Was tun, wenn das Modul in einem Theme nicht vorhanden ist.
    5. DB Dump anbieten
    6. Errorlog - WORK ON HOLD
    7. Sidebar auf Icons reduzieren
    8. Assets weiter optimieren/reduzieren
    9. Dashboard pro User variabel gestaltbar machen
        * Anordnung
        * Module
    10. Alle (asset) js Files in der index.cfm laden
    11. Eigene Tabs gegen AngularUI Tabs ersetzen
    12. Scss - CSS Editor
    13. Template Editor?
    14. Responsive anpassungen
    15. Design schick machen
    16. Bei gewissen Modulen easy/expert Mode?

## Module (in eigenen Repos/Projekten)
    1. Gallery
        1. Weitere Möglichkeiten
            * Suche
            * Auslesen der EXIF Daten zum Initialen setzen der Bildinformationen
            * Kommentarmöglichkeit
            * teilen einer Gallerie oder eines Bilder per Soziale Medien
                * Per Option ein oder ausschaltbar (jeweils)
            * Release Date
            * Bewertungen
                * Anonym per Option
                * Als eingeloggter User
        2. Statistiken mit dem Datepicker aufbereiten
        3. Workflow der Seiten adaptieren?
        4. Alles prüfen
    2. Blog
        1. Mögliche Verbesserungen:
            * File resizing after upload is only applied by width and height attributes
            * F5-Raiding beim Abschicken des Kommentars möglich (Siehe Allgemein 17)
        2. Kommentarmöglichkeit
            * Verschachtelte Kommentarmöglichkeit
        3. Adaptionen in der Übersicht
            * Kalenderübersicht hinzufügen => Klick auf Datum => zeigt alle Posts des Tages
        4. Statistiken mit dem Datepicker aufbereiten
        5. Workflow der Seiten adaptieren?
        6. Alles prüfen
        7. Statistiken pro Bild
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
    
    16. Berechtigungsrequestor
        (Tool um eine Anfrage an den/die Admins zu stellen, mit der Bitte eine gewisse Berechtigung zu erhalten - nur für eingeloggte User - Untermodul des Usermodul)
        * Gruppe
        * Rolle
        * Begründung/Kommentar
        * Auflistung und Status aktueller (letzte 10 Tage) Anfragen
        * Admintool
            * Setzen des Status
                * Genehmigt
                * Abgelehnt 
            * Kommentar
    
    17. Usermodul
        * Registrierung
    

## Optimierungen
    1. Datenbank optimieren
    2. Aktuell gibt es sowohl creationDate als auch createdDate => gleichziehen!!!
    3. Tabellenprefix in Application verankern. Aus Datei auslesen.
    4. Datasources aus Datei auslesen.
    5. (CFIDE/LuceeAdmin) Serversettings in Applikation verankern
    6. Check handling of not found results for twitch and youtube. Check if it's best to throw an error or set a status and check it
    7. Verwendung von nicht Klassenattributen (z.B. request.user) aus den Klassen entfernen und als Parameter erwarten
    8. Berechtigungen (Admin, Editor, User) in Module einbauen
    9. CreateObject gegen import und new ersetzen, außer bei den dynamischen
    10. Controller zum Erstellen von Links (z.B. User) erstellen
    11. Creator und lastEditor direkt als Objekte in Objekten erstellen
    12. ggf. setter der Objekte "neue" Werte aktualisieren und bei speichern in die originalen übertragen.
    13. Charts responsive mit maxHeight!?
    14. Checken, ob man Loading Bar und Error Message Box irgendwie Global verankern kann



NULL checks

return type date => return null
set array == null

method caching of object