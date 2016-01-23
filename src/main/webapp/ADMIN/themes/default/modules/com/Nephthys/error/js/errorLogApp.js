(function (angular) {
    var errorLogAdminApp = angular.module("errorLogAdmin", ["ngRoute", "errorLogListCtrl", "errorLogDetailCtrl"]);
    
    errorLogAdminApp
        .config(["$routeProvider",
            function ($routeProvider) {
                $routeProvider
                    .when("/", {
                        templateUrl: "/themes/default/modules/com/Nephthys/error/partials/errorLogList.html",
                        controller:  "errorLogListCtrl"
                    })
                    .when("/:errorCode", {
                        templateUrl: "/themes/default/modules/com/Nephthys/error/partials/errorLogDetail.html",
                        controller:  "errorLogDetailCtrl"
                    })
                    .otherwise({
                        redirectTo: "/"
                    });
            }
        ])
        .config(["$httpProvider", globalAngularAjaxSettings]);
}(window.angular));