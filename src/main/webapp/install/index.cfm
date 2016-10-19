<!DOCTYPE html>
<html ng-app="nephthysInstallApp">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <title>Welcome to the installation routine of the Nephthys.CMS</title>
    
    <link rel="stylesheet" href="/install/css/main.css">
    <link rel="stylesheet" href="/install/css/additions.css">
    
    <script type="text/javascript" src="/install/js/jQuery/jquery-2.1.4.min.js"></script>
    <script type="text/javascript" src="/install/js/bootstrap/bootstrap.min.js"></script>
    
    <script type="text/javascript" src="/install/js/angularJs/angular.min.js"></script>
    <script type="text/javascript" src="/install/js/angularJs/angular-route.min.js"></script>
    
</head>
<body ng-controller="nephthysInstallCtrl">
    <header class="m-t-2">
        <div class="container">
            <div class="row">
                <div class="col-sm-12">
                    <ul class="nav nav-tabs">
                        <li class="nav-item" ng-repeat="step in wizardSteps">
                            <a class="nav-link" ng-class="((actualStep == $index + 1) ? 'active' : ((actualStep > $index + 1) ? 'success disabled' : 'disabled'))" href="#">{{step}}</a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </header>
    <main class="m-t-2">
        <div class="container">
            <div ng-view></div>
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
    
    <script type="text/javascript" src="/install/js/nephthysInstall.js"></script>
</body>
</html>