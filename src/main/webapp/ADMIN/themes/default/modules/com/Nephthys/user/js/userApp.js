(function (angular) {
    var userAdminApp = angular.module("userAdmin", ["ngRoute", "ngFileUpload", "userListCtrl", "userDetailCtrl", "userPermissionCtrl"]);
    
    userAdminApp
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
        .config(["$httpProvider", globalAngularAjaxSettings]);
}(window.angular));