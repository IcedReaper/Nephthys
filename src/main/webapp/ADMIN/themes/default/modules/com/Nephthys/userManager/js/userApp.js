var nephthysAdminApp = angular.module("nephthysAdminApp", ["ngRoute",
                                                           "ngFileUpload",
                                                           "ui.bootstrap",
                                                           "ui.tree",
                                                           "com.nephthys.global.loadingBar",
                                                           "com.nephthys.global.userInfo",
                                                           "com.nephthys.userManager.statistics",
                                                           "com.Nephthys.userManager.tasklist"]);

nephthysAdminApp
    .config(["$routeProvider",
        function ($routeProvider) {
            $routeProvider
                .when("/", {
                    templateUrl: "/themes/default/modules/com/Nephthys/userManager/partials/tasklist.html"
                })
                
                .when("/user/list", {
                    templateUrl: "/themes/default/modules/com/Nephthys/userManager/partials/userList.html",
                    controller:  "userListCtrl"
                })
                .when("/user/:userId", {
                    templateUrl: "/themes/default/modules/com/Nephthys/userManager/partials/userDetail.html",
                    controller:  "userDetailCtrl"
                })
                
                .when("/blacklist/list", {
                    templateUrl: "/themes/default/modules/com/Nephthys/userManager/partials/blacklistList.html",
                    controller:  "blacklistListCtrl"
                })
                .when("/blacklist/:blacklistId", {
                    templateUrl: "/themes/default/modules/com/Nephthys/userManager/partials/blacklistEntry.html",
                    controller:  "blacklistEntryCtrl"
                })
                
                .when("/status/list", {
                    templateUrl: "/themes/default/modules/com/Nephthys/userManager/partials/statusList.html",
                    controller:  "statusListCtrl"
                })
                .when("/status/flow", {
                    templateUrl: "/themes/default/modules/com/Nephthys/userManager/partials/statusFlow.html",
                    controller:  "statusFlowCtrl"
                })
                .when("/status/:statusId", {
                    templateUrl: "/themes/default/modules/com/Nephthys/userManager/partials/statusDetail.html",
                    controller:  "statusDetailCtrl"
                })
                
                .otherwise({
                    redirectTo: "/"
                });
        }
    ])
    .config(["$httpProvider", globalAngularAjaxSettings])
    .config(window.$QDecorator);