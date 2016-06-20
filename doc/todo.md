# TODO List

## Actual Task TODO - Reminder:
- required approvals
- Hardcoded /user & /search Links fixen... => move to system settings... but what when the page isn't part of the sitemap?

## Allgemein
    1. Validierungen
        1. Mehr Validierungsregeln implementieren
    2. Tableprefix variabel gestalten
    3. Styling des Errortemplates
    4. Formbuilder
    5. getUserInformation zentral ablegen | Aktuell mehrfach identisch vorhanden ?
        * user informationen für den ajax JSON Rückweg vorbereiten
    6. Installationssystem
        * Datasources bei der Installation in einer JSON Datei ablegen und in den Applications auslesen
    7. Updatesystem
    8. Repairmodus ?
    9. Lizenzen von Assets und Plugins überprüfen
    10. Mehrsprachigkeit/Internationalisierung
        * i18n
        * i10n
    11. user => username überprüfen
    12. user => blacklist erstellen | Innerhalb des Username überprüfen
    13. F5-Raids bei Formularen unterbinden
    14. Beim anlegen von neuen Datensätzen werden die UserIds und die Datumfelder im variables scope nicht aktualisiert
    15. FileUpload, etc in eine Extra-Component aus dem Model auslagern
    16. Pakete
        * Alles
        * Blog
        * Gallerie
        * Marketing/Produkt
    17. QueryBuilder zur Unterstützung verschiedener DB-Systeme
        * Idee und erste Doku unter QueryBuilder-idea-notes.md
    18. Zusätzliche Optionen
        * Berechtigungssystem auf Menüpunkte ausweiten
    19. Erweiterte Sicherheit in Modulen
        * Personen freischalten => Nur normales Editieren
        *
    20. API-Statistics wie page.filter allen Modulen hinzufügen. - abwägen, und nach und nach

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
    7. Implement "loading screen" into http interceptor
    8. Sidebar auf Icons reduzieren
    9. Assets weiter optimieren/reduzieren
    10. Dashboard untermodule in andere Dateien verschieben ggf mehr übersicht schaffen => nearly done
    11. Dashboard pro User variabel gestaltbar machen
        * Anordnung
        * Module
    12. Alle (asset) js Files in der index.cfm laden
    13. Eigene Tabs gegen AngularUI Tabs ersetzen
    14. Scss - CSS Editor
    15. Template Editor?
    16. Responsive anpassungen
    17. Design schick machen
    18. Bei gewissen Modulen easy/export Mode?

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
    

## Optimierungen
    1. Settings der unterschiedlichen Module und des Systems verbinden
    2. Nach weiteren DB-Enums Ausschau halten
    3. Foreign Key Indices setzen
    4. Aktuell gibt es sowohl creationDate als auch createdDate => gleichziehen!!!
    5. Tabellenprefix in Application verankern. Aus Datei auslesen.
    6. Datasources aus Datei auslesen.
    7. Serversettings in Applikation verankern
    8. Check handling of not found results for twitch and youtube. Check if it's best to throw an error or set a status and check it
    9. Prüfen ob D3 besser ist als Chart.js | Chart.js V2 ausprobieren
    10. Verwendung von nicht Klassenattributen (z.B. request.user) aus den Klassen entfernen und als Parameter erwarten
    11. Berechtigungen (Admin, Editor, User) in Module einbauen
    12. Alle Statistiken in einer Tabelle zusammenfassen
    13. CreateObject gegen import und new ersetzen, außer bei den dynamischen
    14. Move Module settings to server settings
    15. Controller zum Erstellen von Links (z.B. User) erstellen
    16. Creator und lastEditor direkt als Objekte in Objekten erstellen
    17. ggf. setter der Objekte "neue" Werte aktualisieren und bei speichern in die originalen übertragen.
    18. Charts responsive mit maxHeight!?
    19. Checken, ob man Loading Bar und Error Message Box irgendwie Global verankern kann



NULL checks

return type date => return null
set array == null

method caching of object