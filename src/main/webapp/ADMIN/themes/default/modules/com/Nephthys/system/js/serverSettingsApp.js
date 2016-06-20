var nephthysAdminApp = angular.module("nephthysAdminApp", ["ngRoute",
                                                           "com.nephthys.global.loadingBar"]);
    
nephthysAdminApp
    .config(["$routeProvider",
        function ($routeProvider) {
            $routeProvider
                .when("/", {
                    templateUrl: "/themes/default/modules/com/Nephthys/system/partials/serverSettingsDetail.html",
                    controller:  "serverSettingsDetailCtrl"
                })
                .otherwise({
                    redirectTo: "/"
                });
        }
    ])
    .config(["$httpProvider", globalAngularAjaxSettings])
    .config(window.$QDecorator);