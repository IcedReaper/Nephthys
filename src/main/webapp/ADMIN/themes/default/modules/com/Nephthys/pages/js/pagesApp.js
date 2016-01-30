var nephthysAdminApp = angular.module("nephthysAdminApp", ["ngRoute", 
                                                           "chart.js"]);

nephthysAdminApp
    .config(["$routeProvider",
        function ($routeProvider) {
            $routeProvider
                .when("/", {
                    templateUrl: "/themes/default/modules/com/Nephthys/pages/partials/pagesList.html",
                    controller:  "pagesListCtrl"
                })
                .when("/status", {
                    templateUrl: "/themes/default/modules/com/Nephthys/pages/partials/statusList.html",
                    controller:  "statusListCtrl"
                })
                .when("/status/:pageStatusId", {
                    templateUrl: "/themes/default/modules/com/Nephthys/pages/partials/statusDetail.html",
                    controller:  "statusDetailCtrl"
                })
                .when("/:pageId", {
                    templateUrl: "/themes/default/modules/com/Nephthys/pages/partials/pagesDetail.html",
                    controller:  "pagesDetailCtrl"
                })
                .when("/:pageId/statistics", {
                    templateUrl: "/themes/default/modules/com/Nephthys/pages/partials/pagesStatistics.html",
                    controller:  "pagesStatisticsCtrl"
                })
                .otherwise({
                    redirectTo: "/"
                });
        }
    ])
    .config(["$httpProvider", globalAngularAjaxSettings])
    .config(window.$QDecorator);