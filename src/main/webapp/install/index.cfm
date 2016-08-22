<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <title>Welcome to the installation routine of the Nephthys.CMS</title>
    
    <link rel="stylesheet" href="/install/css/main.css">
    
    <script src="/install/js/jquery-2.1.4.min.js"></script>
    <script src="/install/js/bootstrap.min.js"></script>
</head>
<body>
    <cfoutput>#application.actualStep#</cfoutput>
    <main class="m-t-2">
        <div class="container">
            <div class="row">
                <div class="col-sm-12">
                    <ul class="nav nav-tabs">
                        <li class="nav-item">
                            <a class="nav-link <cfif application.actualStep eq 1>active<cfelse>disabled</cfif>" href="#">Schritt 1</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <cfif application.actualStep eq 2>active<cfelse>disabled</cfif>" href="#">Schritt 2</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <cfif application.actualStep eq 3>active<cfelse>disabled</cfif>" href="#">Schritt 3</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <cfif application.actualStep eq 4>active<cfelse>disabled</cfif>" href="#">Schritt 4</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <cfif application.actualStep eq 5>active<cfelse>disabled</cfif>" href="#">Schritt 5</a>
                        </li>
                    </ul>
                </div>
            </div>
            
            <cfinclude template="partials/step_#application.actualStep#.cfm">
        </div>
    </main>
    <footer>
        © IcedReaper und das Nephthys Team 2015 - 2016
        <div class="footerLinks">
            <a href="https://www.nephthys.com">www.nephthys.com</a>
        </div>
        
        <div class="row">
            <div class="col-sm-4 offset-sm-8">
                Folge uns auf:<br />
                <div class="btn-group" role="group" aria-label="Folge uns auf">
                    <a type="button" class="btn btn-secondary" href="https://www.facebook.com/Nephthys.CMS" target="_blank"><i class="fa fa-facebook"></i></a>
                    <a type="button" class="btn btn-secondary" href="https://www.twitter.com/Nephthys.CMS" target="_blank"><i class="fa fa-twitter"></i></a>
                    <a type="button" class="btn btn-secondary" href="https://www.github.com/IcedReaper" target="_blank"><i class="fa fa-github"></i></a>
                    <a type="button" class="btn btn-secondary" href="https://www.instagram.com/Nephthys.CMS" target="_blank"><i class="fa fa-instagram"></i></a>
                    <a type="button" class="btn btn-secondary" href="https://plus.google.com/Nephthys.CMS" target="_blank"><i class="fa fa-google-plus"></i></a>
                </div>
            </div>
        </div>
    </footer>
</body>
</html>