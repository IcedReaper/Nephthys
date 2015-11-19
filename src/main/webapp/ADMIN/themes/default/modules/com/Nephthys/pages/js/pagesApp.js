(function (angular) {
    var pagesAdminApp = angular.module("pagesAdmin", ["ngRoute", "pagesListCtrl", "pagesDetailCtrl", "pagesStatisticsCtrl"]);
    
    pagesAdminApp
        .config(["$routeProvider",
            function ($routeProvider) {
                $routeProvider
                    .when("/", {
                        templateUrl: "/themes/default/modules/com/Nephthys/pages/partials/pagesList.html",
                        controller:  "pagesListCtrl"
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
        .config(["$httpProvider", globalAngularAjaxSettings]);
}(window.angular));