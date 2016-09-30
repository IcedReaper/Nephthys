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
<body ng-app>
    <header class="m-t-2">
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
        </div>
    </header>
    <main class="m-t-2">
        <div class="container">