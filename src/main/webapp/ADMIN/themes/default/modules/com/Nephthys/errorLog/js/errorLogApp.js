var nephthysAdminApp = angular.module("nephthysAdminApp", ["ngRoute",
                                                           "com.Nephthys.errorLog.statistics",
                                                           "com.nephthys.global.loadingBar"]);

nephthysAdminApp
    .config(["$routeProvider",
        function ($routeProvider) {
            $routeProvider
                .when("/", {
                    templateUrl: "/themes/default/modules/com/Nephthys/errorLog/partials/list.html",
                    controller:  "errorLogListCtrl"
                })
                .when("/:errorCode/:fromDate/:toDate", {
                    templateUrl: "/themes/default/modules/com/Nephthys/errorLog/partials/detail.html",
                    controller:  "errorLogDetailCtrl"
                })
                .when("/:errorCode/:fromDate/:toDate/:errorId", {
                    templateUrl: "/themes/default/modules/com/Nephthys/errorLog/partials/detail.html",
                    controller:  "errorLogDetailCtrl"
                })
                .otherwise({
                    redirectTo: "/"
                });
        }
    ])
    .config(["$httpProvider", globalAngularAjaxSettings]);