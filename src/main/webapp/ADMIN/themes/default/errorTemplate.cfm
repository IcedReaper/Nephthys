<!DOCTYPE html>
<html class="error error<cfif attributes.statusCode EQ 404>404<cfelse>500</cfif>">
<head>
    <cfheader statuscode="#attributes.statusCode#" statustext="#attributes.statusText#">
    
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    
    <title>Verlaufen wa?!</title>
    
    <link rel="shortcut icon" href="/themes/default/img/favicon.gif">
    <link rel="stylesheet" href="/themes/default/css/main.css">
</head>
<body>
    <header>
    </header>
    <main>
        <!---<div class="site-wrapper text-xs-center">
            <cfswitch expression="#attributes.statusCode#">
                <cfcase value="500">
                    <h1>Uups, da ist wohl was schief gegangen!</h1>
                </cfcase>
                <cfcase value="404">
                    <h1>Uups, da wurde was nicht gefunden!</h1>
                </cfcase>
            </cfswitch>
            <a href="/">Zurück zur Startseite</a>
        </div>--->
        <cfdump var="#attributes#">
    </main>
    <footer>
        &copy; IcedReaper und das Nephthys Team 2015 - <cfoutput>#year(now())#</cfoutput>
    </footer>
</body>
</html>