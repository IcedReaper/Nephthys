var nephthysAdminApp = angular.module("nephthysAdminApp", ["ngRoute",
                                                           "com.nephthys.global.loadingBar"]);

nephthysAdminApp
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