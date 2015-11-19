(function (angular) {
    var serverSettingsAdminApp = angular.module("serverSettingsAdmin", ["ngRoute", "serverSettingsDetailCtrl"]);
    
    serverSettingsAdminApp
        .config(["$routeProvider",
            function ($routeProvider) {
                $routeProvider
                    .when("/", {
                        templateUrl: "/themes/default/modules/com/Nephthys/serverSettings/partials/serverSettingsDetail.html",
                        controller:  "serverSettingsDetailCtrl"
                    })
                    .otherwise({
                        redirectTo: "/"
                    });
            }
        ])
        .config(["$httpProvider", globalAngularAjaxSettings]);
}(window.angular));