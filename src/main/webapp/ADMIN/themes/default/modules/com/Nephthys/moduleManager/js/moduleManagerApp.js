(function(angular) {
    var userAdminApp = angular.module("moduleManagerAdmin", ["ngRoute", "moduleManagerListCtrl", "moduleManagerDetailCtrl", "moduleManagerPermissionCtrl", "moduleManagerDBDumpCtrl"]);
    
    userAdminApp
        .config(["$routeProvider",
            function ($routeProvider) {
                $routeProvider
                    .when("/", {
                        templateUrl: "/themes/default/modules/com/Nephthys/moduleManager/partials/moduleManagerList.html",
                        controller:  "moduleManagerListCtrl"
                    })
                    .when("/:moduleId", {
                        templateUrl: "/themes/default/modules/com/Nephthys/moduleManager/partials/moduleManagerDetail.html",
                        controller:  "moduleManagerDetailCtrl"
                    })
                    .when("/:moduleId/permissions", {
                        templateUrl: "/themes/default/modules/com/Nephthys/moduleManager/partials/moduleManagerPermissions.html",
                        controller:  "moduleManagerPermissionCtrl"
                    })
                    .when("/:moduleId/dbDump", {
                        templateUrl: "/themes/default/modules/com/Nephthys/moduleManager/partials/moduleManagerDBDump.html",
                        controller:  "moduleManagerDBDumpCtrl"
                    })
                    .otherwise({
                        redirectTo: "/"
                    });
            }
        ])
        .config(["$httpProvider", globalAngularAjaxSettings]);
}(window.angular));