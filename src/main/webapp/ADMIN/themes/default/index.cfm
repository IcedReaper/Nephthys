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
    
    <script type="text/javascript" src="/themes/default/assets/angularJs/angular.min.js"></script>
    <script type="text/javascript" src="/themes/default/assets/angularJs/angular-route.min.js"></script>
    <script type="text/javascript" src="/themes/default/assets/angularJs/$QDecorator.js"></script>
    
    <script type="text/javascript" src="/themes/default/js/globalFunctions.js"></script>
    <script type="text/javascript" src="/themes/default/js/globalAngularAjaxSettings.js"></script>
</head>
<body<cfif request.user.getUserId() NEQ null> ng-app="nephthysAdminApp"</cfif>>
    <nav class="navbar navbar-dark navbar-fixed-top bg-inverse">
        <div class="container-fluid">
            <a class="navbar-brand" href="/com.Nephthys.dashboard/">Adminpanel - Nephthys</a>
            
            <cfif request.user.getUserId() NEQ null>
                <div class="btn-group pull-right">
                    <button type="button" class="btn btn-secondary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        #request.user.getUsername()#
                    </button>
                    <div class="dropdown-menu p-r-1 p-l-1 p-b-1">
                        <a href="/com.Nephthys.userManager##/user/#request.user.getUserId()#" class="dropdown-item"><i class="fa fa-cog"></i> Einstellungen</a>
                        <div class="dropdown-divider"></div>
                        <a href="?logout" class="dropdown-item"><i class="fa fa-sign-out"></i> Ausloggen</a>
                    </div>
                </div>
                
                <div class="pull-right" ng-controller="sessionTimeoutCtrl" ng-show="secondsRemaining">
                    <a class="navbar-brand">Verbleibende Sessionzeit: {{secondsRemaining | secondsToDateTime | date:'mm:ss'}}</a>
                </div>
            </cfif>
        </div>
    </nav>
    <main>
        <cfif request.user.getUserId() NEQ null>
            <div class="container-fluid">
                <div class="row">
                    <div class="col-sm-3 col-md-2 sidebar">
                        <h3>Modulübersicht</h3>
                        <cfscript>
                            navigationConnector = createObject("component", "ADMIN.modules.com.Nephthys.navigation.connector").init();
                        </cfscript>
                        #navigationConnector.render()#
                    </div>
                    <div class="col-sm-9 offset-sm-3 col-md-10 offset-md-2 main">
                        #request.moduleController.render()#
                    </div>
                </div>
            </div>
        <cfelse>
            <div class="container m-y-3">
                <div class="row">
                    <div class="col-sm-12">
                        #request.moduleController.render()#
                    </div>
                </div>
            </div>
        </cfif>
    </main>
    <footer>
        &copy; IcedReaper und das Nephthys Team 2015 - #year(now())#
    </footer>
    
    <cfif request.user.getUserId() NEQ null>
        <script type="text/javascript" src="/themes/default/js/sessionTimeout.js"></script>
    </cfif>
</body>
</html>
</cfoutput>