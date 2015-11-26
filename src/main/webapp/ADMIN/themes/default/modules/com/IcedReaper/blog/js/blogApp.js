(function (angular) {
    var userAdminApp = angular.module("blogAdmin", ["ngRoute",
                                                       "ngTagsInput",
                                                       "ngFileUpload",
                                                       "textAngular",
                                                       "blogListCtrl",
                                                       "blogDetailCtrl",
                                                       "blogCategoryCtrl",
                                                       "blogPictureCtrl",
                                                       "blogStatisticsCtrl",
                                                       "categoryListCtrl",
                                                       "categoryDetailCtrl"]);
    
    userAdminApp
        .config(["$routeProvider",
            function ($routeProvider) {
                $routeProvider
                    .when("/", {
                        templateUrl: "/themes/default/modules/com/IcedReaper/blog/partials/blogList.html",
                        controller:  "blogListCtrl"
                    })
                    .when("/categories", {
                        templateUrl: "/themes/default/modules/com/IcedReaper/blog/partials/categoryList.html",
                        controller:  "categoryListCtrl"
                    })
                    .when("/category/:categoryId", {
                        templateUrl: "/themes/default/modules/com/IcedReaper/blog/partials/categoryDetail.html",
                        controller:  "categoryDetailCtrl"
                    })
                    /*.when("/:blogId/statistics", {
                        templateUrl: "/themes/default/modules/com/IcedReaper/blog/partials/blogStatistics.html",
                        controller:  "blogStatisticsCtrl"
                    })*/
                    .when("/:blogId", {
                        templateUrl: "/themes/default/modules/com/IcedReaper/blog/partials/blogDetail.html",
                        controller:  "blogDetailCtrl"
                    })
                    .otherwise({
                        redirectTo: "/"
                    });
            }
        ])
        .config(["$httpProvider", globalAngularAjaxSettings]);
}(window.angular));