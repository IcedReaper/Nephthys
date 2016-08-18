var nephthysAdminApp = angular.module("nephthysAdminApp", ["ngRoute",
                                                           "com.Nephthys.global.loadingBar",
                                                           "com.Nephthys.system.moduleSettings"]);
    
nephthysAdminApp
    .config(["$routeProvider",
        function ($routeProvider) {
            $routeProvider
                .when("/", {
                    templateUrl: "/themes/default/modules/com/Nephthys/moduleManager/partials/list.html",
                    controller:  "listCtrl"
                })
                .when("/install", {
                    templateUrl: "/themes/default/modules/com/Nephthys/moduleManager/partials/install.html",
                    controller:  "installCtrl"
                })
                .when("/:moduleId?", {
                    templateUrl: "/themes/default/modules/com/Nephthys/moduleManager/partials/detail.html",
                    controller:  "detailCtrl"
                })
                .when("/:moduleId/permissions", {
                    templateUrl: "/themes/default/modules/com/Nephthys/moduleManager/partials/permissions.html",
                    controller:  "permissionsCtrl"
                })
                .when("/:moduleId/dbDump", {
                    templateUrl: "/themes/default/modules/com/Nephthys/moduleManager/partials/databaseDump.html",
                    controller:  "databaseDumpCtrl"
                })
                .when("/settings/:moduleName", {
                    templateUrl: "/themes/default/modules/com/Nephthys/moduleManager/partials/moduleSettings.html",
                    controller:  "moduleSettingsCtrl"
                })
                .otherwise({
                    redirectTo: "/"
                });
        }
    ])
    .config(["$httpProvider", globalAngularAjaxSettings])
    .config(window.$QDecorator);