<cfoutput>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    
    <link rel="shortcut icon" href="/themes/default/img/favicon.gif">
    
    <title>#request.page.getTitle()#</title>
    
    <meta name="description" content="#request.page.getDescription()#">
    
    <link rel="stylesheet" href="/themes/default/assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="/themes/default/assets/bootstrap/css/bootstrap-theme.min.css">
    
    #request.page.renderResources("css")#
    
    <link rel="stylesheet" href="/themes/default/css/default.css">
    
    <script src="/themes/default/assets/jQuery/jquery-2.1.4.min.js"></script>
    <script src="/themes/default/assets/bootstrap/js/bootstrap.min.js"></script>
    
    #request.page.renderResources("js")#
</head>
<body>
    <div class="container">
        <header>
            #createObject("component", "WWW.modules.com.Nephthys.navigation.connector").init().header()#
        </header>
    </div>
    <main>
        #request.content#
    </main>
    <div class="container-fluid">
        <footer>
            #createObject("component", "WWW.modules.com.Nephthys.navigation.connector").init().footer()#
        </footer>
    </div>
</body>
</html>
</cfoutput>