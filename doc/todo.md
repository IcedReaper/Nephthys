# TODO List

## Allgemein
    1. Validierungen
        1. Mehr Validierungsregeln implementieren
    2. Tableprefix variabel gestalten
    3. Styling des Errortemplates
    4. loginHandler checken ob Name und location passt. => controller.user.userList
    5. Formbuilder
    6. getUserInformation zentral ablegen | Aktuell mehrfach identisch vorhanden ?
        * user informationen für den ajax JSON Rückweg vorbereiten
    7. Installationssystem
        * Datasources bei der Installation in einer JSON Datei ablegen und in den Applications auslesen
    8. Updatesystem
    9. repair modus ?
    10. Pfade in DB speichern / Controller what else | aktuell hard-coded an mehreren Stellen
        * Avatar
    11. Lizenzen von Assets und Plugins überprüfen
    12. Mehrsprachigkeit/Internationalisierung
        * i18n
        * i10n
    13. filter.cfc auf gleichen Nenner bringen. (Aktuell gibt die Methode mal arrays, mal queries zurück) !!!
    14. user => username überprüfen
    15. user => blacklist erstellen | Innerhalb des Username überprüfen
    16. F5-Raids unterbinden
    17. Beim anlegen von neuen Datensätzen werden die UserIds und die Datumfelder im variables scope nicht aktualisiert
    18. FileUpload, etc in eine Extra-Component aus dem Model auslagern
    19. page filter erweitern
    20. Pakete
        * Alles
        * Blog
        * Gallerie
        * Marketing/Produkt

## Website
    1. Codeoptimierung
    2. Userverwaltung ?
        * User darf nur sich selber bearbeiten können => Keine Ajax-Request
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
        1. Contentbearbeitung
            * Version fertig - noch sehr abstrakt
        2. Seitenversionierung
        3. Mehrsprachigkeit des Contents
        4. Seitenhierarchie
        5. Möglichkeit für unterschiedlichen Content bei Übersicht / Detailansicht ?
    3. Thememanagement
        1. Themeinstallation per git repository
            * Check ob alle Module in dem Theme vorhanden sind. Sonst Warnung
    4. Modul-Theme-Management
        1. Was tun, wenn das Modul in einem Theme nicht vorhanden ist.
    5. Workflow - benötigt versionierung
    6. DB Dump anbieten
    7. Vorschau
        * Template in ADMIN, welches ein Template in WWW inkludiert, wo dann die richtigen Sachen angezeigt werden; dann halt nur auch schon nicht veröffentlichte Sachen.
    8. Errorlog - WORK ON HOLD
    9. Implement "loading screen" into http interceptor
    10. Sidebar auf Icons reduzieren
    11. Dashboard untermodule in andere Dateien verschieben ggf mehr übersicht schaffen
    12. Assets weiter optimieren

## Module (in eigenen Repos/Projekten)
    1. Gallery
        1. Weitere Möglichkeiten
            * Search
            * Comments
            * Release Date
            * Bewertungen
                * Anonym per Option
                * Als eingeloggter User
    2. Blog
        *Mögliche Verbesserungen:
            * File resizing after upload is only applied by width and height attributes
            * F5-Raiding beim Abschicken des Kommentars möglich (Siehe Allgemein 17)
        * Comments
            * Nested comments
        * Adaptionen in der Übersicht
            * Kalenderübersicht hinzufügen => Klick auf Datum => zeigt alle Posts des Tages
    3. Reviewsystem
    4. Referenzen
    5. Preis/Leistung

## Optimierungen
    1. Settings der unterschiedlichen Module und des Systems verbinden
    2. Nach weiteren DB-Enums Ausschau halten
    3. Foreign Key Indices setzen
    4. Aktuell gibt es sowohl creationDate als auch createdDate => gleichziehen!!!
    5. Bei Ajax-Calls success entfernen, da Angular bei Fehlern anders reagiert und die Calls nicht in dem Success-Kreislauf landen :)