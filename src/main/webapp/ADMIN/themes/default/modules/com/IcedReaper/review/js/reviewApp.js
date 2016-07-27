var nephthysAdminApp = angular.module("nephthysAdminApp", ["ngRoute",
                                                           "ngTagsInput",
                                                           "ngFileUpload",
                                                           "ui.bootstrap",
                                                           "textAngular",
                                                           "com.Nephthys.global.loadingBar"]);
    
nephthysAdminApp
    .config(["$routeProvider",
        function ($routeProvider) {
            $routeProvider
                .when("/", {
                    templateUrl: "/themes/default/modules/com/IcedReaper/review/partials/reviewList.html",
                    controller:  "reviewListCtrl"
                })
                .when("/genres", {
                    templateUrl: "/themes/default/modules/com/IcedReaper/review/partials/genreList.html",
                    controller:  "genreListCtrl"
                })
                .when("/genre/:genreId", {
                    templateUrl: "/themes/default/modules/com/IcedReaper/review/partials/genreDetail.html",
                    controller:  "genreDetailCtrl"
                })
                .when("/types", {
                    templateUrl: "/themes/default/modules/com/IcedReaper/review/partials/typeList.html",
                    controller:  "typeListCtrl"
                })
                .when("/type/:typeId", {
                    templateUrl: "/themes/default/modules/com/IcedReaper/review/partials/typeDetail.html",
                    controller:  "typeDetailCtrl"
                })
                .when("/:reviewId", {
                    templateUrl: "/themes/default/modules/com/IcedReaper/review/partials/reviewDetail.html",
                    controller:  "reviewDetailCtrl"
                })
                .otherwise({
                    redirectTo: "/"
                });
        }
    ])
    .config(["$httpProvider", globalAngularAjaxSettings])
    .config(window.$QDecorator);