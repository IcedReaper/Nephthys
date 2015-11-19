(function (angular) {
    var userAdminApp = angular.module("galleryAdmin", ["ngRoute",
                                                       "ngTagsInput",
                                                       "ngFileUpload",
                                                       "textAngular",
                                                       "galleryListCtrl",
                                                       "galleryDetailCtrl",
                                                       "galleryCategoryCtrl",
                                                       "galleryPictureCtrl",
                                                       "categoryListCtrl",
                                                       "categoryDetailCtrl"]);
    
    userAdminApp
        .config(["$routeProvider",
            function ($routeProvider) {
                $routeProvider
                    .when("/", {
                        templateUrl: "/themes/default/modules/com/IcedReaper/gallery/partials/galleryList.html",
                        controller:  "galleryListCtrl"
                    })
                    .when("/categories", {
                        templateUrl: "/themes/default/modules/com/IcedReaper/gallery/partials/categoryList.html",
                        controller:  "categoryListCtrl"
                    })
                    .when("/category/:categoryId", {
                        templateUrl: "/themes/default/modules/com/IcedReaper/gallery/partials/categoryDetail.html",
                        controller:  "categoryDetailCtrl"
                    })
                    /*.when("/:galleryId/statistics", {
                        templateUrl: "/themes/default/modules/com/IcedReaper/gallery/partials/galleryStatistics.html",
                        controller:  "galleryStatisticsCtrl"
                    })*/
                    .when("/:galleryId", {
                        templateUrl: "/themes/default/modules/com/IcedReaper/gallery/partials/galleryDetail.html",
                        controller:  "galleryDetailCtrl"
                    })
                    .otherwise({
                        redirectTo: "/"
                    });
            }
        ])
        .config(["$httpProvider", globalAngularAjaxSettings]);
}(window.angular));