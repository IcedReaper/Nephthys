<cfoutput>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    
    <title>Admin-Panel - Nephthys</title>
    
    <link rel="shortcut icon" href="/themes/default/img/favicon.gif">
    
    <link rel="stylesheet" href="/themes/default/css/main.css">
    
    <script src="/themes/default/assets/jQuery/jquery-2.1.4.min.js"></script>
    <script src="/themes/default/assets/bootstrap/js/bootstrap.min.js"></script>
</head>
<body>
    <nav class="navbar navbar-dark bg-inverse">
        <div class="container-fluid">
            <a class="navbar-brand" href="/dashboard/">Adminpanel - IcedReaper's CMS "Nephthys"</a>
            
            <cfif request.user.getUserId() NEQ 0>
                <div class="btn-group pull-right">
                    <button type="button" class="btn btn-secondary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        #request.user.getUsername()#
                    </button>
                    <div class="dropdown-menu p-r p-l p-b">
                        <a href="/com.Nephthys.user##/#request.user.getUserID()#" class="dropdown-item"><i class="fa fa-cog"></i> Einstellungen</a>
                        <div class="dropdown-divider"></div>
                        <a href="?logout" class="dropdown-item"><i class="fa fa-sign-out"></i> Ausloggen</a>
                    </div>
                </div>
            </cfif>
        </div>
    </nav>
    <main>
        <div class="container-fluid">
            <div class="row">
                <cfif request.user.getUserId() NEQ 0>
                    <div class="col-sm-3 col-md-2 sidebar">
                        <h3>Modulübersicht</h3>
                        <cfscript>
                            navigationConnector = createObject("component", "ADMIN.modules.com.Nephthys.navigation.connector").init();
                        </cfscript>
                        #navigationConnector.render()#
                    </div>
                    <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
                        #request.moduleController.render()#
                    </div>
                <cfelse>
                    #request.moduleController.render()#
                </cfif>
            </div>
        </div>
    </main>
    <footer>
        &copy; IcedReaper 2014-#year(now())#
    </footer>
</body>
</html>
</cfoutput>