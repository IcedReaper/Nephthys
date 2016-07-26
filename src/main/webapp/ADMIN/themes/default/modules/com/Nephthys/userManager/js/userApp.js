var nephthysAdminApp = angular.module("nephthysAdminApp", ["ngRoute",
                                                           "ngFileUpload",
                                                           "ui.bootstrap",
                                                           "com.nephthys.global.loadingBar",
                                                           "com.nephthys.global.userInfo",
                                                           "com.nephthys.userManager.statistics"]);

nephthysAdminApp
    .config(["$routeProvider",
        function ($routeProvider) {
            $routeProvider
                .when("/", {
                    templateUrl: "/themes/default/modules/com/Nephthys/userManager/partials/userList.html",
                    controller:  "userListCtrl"
                })
                .when("/blacklist/list", {
                    templateUrl: "/themes/default/modules/com/Nephthys/userManager/partials/blacklistList.html",
                    controller:  "blacklistListCtrl"
                })
                .when("/blacklist/:blacklistId", {
                    templateUrl: "/themes/default/modules/com/Nephthys/userManager/partials/blacklistEntry.html",
                    controller:  "blacklistEntryCtrl"
                })
                .when("/:userId", {
                    templateUrl: "/themes/default/modules/com/Nephthys/userManager/partials/userDetail.html",
                    controller:  "userDetailCtrl"
                })
                .otherwise({
                    redirectTo: "/"
                });
        }
    ])
    .config(["$httpProvider", globalAngularAjaxSettings])
    .config(window.$QDecorator);