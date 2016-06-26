<cfoutput>
<!DOCTYPE html>
<html lang="en"<cfif request.page.isSpecialCssClassSet("html")> class="#request.page.getSpecialCssClass('html')#"</cfif>>
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
    
    <link rel="stylesheet" href="/themes/default/css/main.css">
    
    #request.page.renderResources("css")#
    
    <script src="/themes/default/assets/jQuery/jquery-2.1.4.min.js"></script>
    <script src="/themes/default/assets/bootstrap/js/bootstrap.min.js"></script>
    
    #request.page.renderResources("js")#
    
    #request.page.renderOpenGraphInfo()#
</head>
<body<cfif request.page.isSpecialCssClassSet("body")> class="#request.page.getSpecialCssClass('body')#"</cfif>>
    <header<cfif request.page.isSpecialCssClassSet("header")> class="#request.page.getSpecialCssClass('header')#"</cfif>>
        #createObject("component", "WWW.modules.com.Nephthys.navigation.connector").init().header()#
    </header>
    <main<cfif request.page.isSpecialCssClassSet("main")> class="#request.page.getSpecialCssClass('main')#"</cfif>>
        #request.content#
    </main>
    <footer<cfif request.page.isSpecialCssClassSet("footer")> class="#request.page.getSpecialCssClass('footer')#"</cfif>>
        #createObject("component", "WWW.modules.com.Nephthys.navigation.connector").init().footer()#
    </footer>
</body>
</html>
</cfoutput>