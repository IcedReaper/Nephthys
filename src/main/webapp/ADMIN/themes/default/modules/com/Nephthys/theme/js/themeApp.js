(function (angular) {
    var themeAdminApp = angular.module("themeAdmin", ["ngRoute", "ngFileUpload", "themeListCtrl", "themeDetailCtrl"]);
    
    themeAdminApp
        .config(["$routeProvider",
            function ($routeProvider) {
                $routeProvider
                    .when("/", {
                        templateUrl: "/themes/default/modules/com/Nephthys/theme/partials/themeList.html",
                        controller:  "themeListCtrl"
                    })
                    .when("/:themeId", {
                        templateUrl: "/themes/default/modules/com/Nephthys/theme/partials/themeDetail.html",
                        controller:  "themeDetailCtrl"
                    })
                    .otherwise({
                        redirectTo: "/"
                    });
            }
        ])
        .config(["$httpProvider", globalAngularAjaxSettings]);
}(window.angular));