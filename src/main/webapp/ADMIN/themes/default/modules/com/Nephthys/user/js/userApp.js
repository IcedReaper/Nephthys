var nephthysAdminApp = angular.module("nephthysAdminApp", ["ngRoute",
                                                           "ngFileUpload",
                                                           "ui.bootstrap",
                                                           "com.nephthys.global.loadingBar",
                                                           "com.nephthys.user.statistics"]);

nephthysAdminApp
    .config(["$routeProvider",
        function ($routeProvider) {
            $routeProvider
                .when("/", {
                    templateUrl: "/themes/default/modules/com/Nephthys/user/partials/userList.html",
                    controller:  "userListCtrl"
                })
                .when("/:userId", {
                    templateUrl: "/themes/default/modules/com/Nephthys/user/partials/userDetail.html",
                    controller:  "userDetailCtrl"
                })
                .otherwise({
                    redirectTo: "/"
                });
        }
    ])
    .config(["$httpProvider", globalAngularAjaxSettings])
    .config(window.$QDecorator);