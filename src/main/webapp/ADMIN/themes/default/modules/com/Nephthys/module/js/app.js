var nephthysAdminApp = angular.module("nephthysAdminApp", ["ngRoute",
                                                           "com.nephthys.global.loadingBar",
                                                           "com.nephthys.system.moduleSettings"]);
    
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
                .when("/settings/:moduleName", {
                    templateUrl: "/themes/default/modules/com/Nephthys/module/partials/moduleSettings.html",
                    controller:  "moduleSettingsCtrl"
                })
                .otherwise({
                    redirectTo: "/"
                });
        }
    ])
    .config(["$httpProvider", globalAngularAjaxSettings])
    .config(window.$QDecorator);