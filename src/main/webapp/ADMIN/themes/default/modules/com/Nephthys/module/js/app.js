var nephthysAdminApp = angular.module("nephthysAdminApp", ["ngRoute",
                                                           "com.nephthys.global.loadingBar"]);
    
nephthysAdminApp
    .config(["$routeProvider",
        function ($routeProvider) {
            $routeProvider
                .when("/", {
                    templateUrl: "/themes/default/modules/com/Nephthys/module/partials/list.html",
                    controller:  "listCtrl"
                })
                .when("/install", {
                    templateUrl: "/themes/default/modules/com/Nephthys/module/partials/install.html",
                    controller:  "installCtrl"
                })
                .when("/:moduleId", {
                    templateUrl: "/themes/default/modules/com/Nephthys/module/partials/detail.html",
                    controller:  "detailCtrl"
                })
                .when("/:moduleId/permissions", {
                    templateUrl: "/themes/default/modules/com/Nephthys/module/partials/permissions.html",
                    controller:  "permissionsCtrl"
                })
                .when("/:moduleId/dbDump", {
                    templateUrl: "/themes/default/modules/com/Nephthys/module/partials/databaseDump.html",
                    controller:  "databaseDumpCtrl"
                })
                .otherwise({
                    redirectTo: "/"
                });
        }
    ])
    .config(["$httpProvider", globalAngularAjaxSettings])
    .config(window.$QDecorator);