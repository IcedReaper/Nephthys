var nephthysAdminApp = angular.module("nephthysAdminApp", ["ngRoute",
                                                           "ngFileUpload",
                                                           "com.nephthys.global.loadingBar"]);
    
nephthysAdminApp
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
    .config(["$httpProvider", globalAngularAjaxSettings])
    .config(window.$QDecorator);