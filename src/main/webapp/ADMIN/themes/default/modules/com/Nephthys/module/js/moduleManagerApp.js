var nephthysAdminApp = angular.module("nephthysAdminApp", ["ngRoute"]);
    
nephthysAdminApp
    .config(["$routeProvider",
        function ($routeProvider) {
            $routeProvider
                .when("/", {
                    templateUrl: "/themes/default/modules/com/Nephthys/module/partials/moduleManagerList.html",
                    controller:  "moduleManagerListCtrl"
                })
                .when("/:moduleId", {
                    templateUrl: "/themes/default/modules/com/Nephthys/module/partials/moduleManagerDetail.html",
                    controller:  "moduleManagerDetailCtrl"
                })
                .when("/:moduleId/permissions", {
                    templateUrl: "/themes/default/modules/com/Nephthys/module/partials/moduleManagerPermissions.html",
                    controller:  "moduleManagerPermissionCtrl"
                })
                .when("/:moduleId/dbDump", {
                    templateUrl: "/themes/default/modules/com/Nephthys/module/partials/moduleManagerDBDump.html",
                    controller:  "moduleManagerDBDumpCtrl"
                })
                .otherwise({
                    redirectTo: "/"
                });
        }
    ])
    .config(["$httpProvider", globalAngularAjaxSettings])
    .config(window.$QDecorator);