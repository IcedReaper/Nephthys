<!DOCTYPE html>
<html>
<head>
    <cfheader statuscode="#attributes.statusCode#" statustext="#attributes.statusText#">
    <title>Verlaufen wa?!</title>
</head>
<body>
    <cfswitch expression="#attributes.statusCode#">
        <cfcase value="500">
            <h1>Uups, da ist wohl was schief gegangen!</h1>
        </cfcase>
        <cfcase value="404">
            <h1>Uups, da wurde was nicht gefunden!</h1>
        </cfcase>
    </cfswitch>
    
    <cfif application.system.settings.getShowDumpOnError()>
        <cfdump var="#attributes.error#">
    </cfif>
</body>
</html>