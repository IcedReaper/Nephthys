(function (angular) {
    var blogApp = angular.module("blogAdmin", ["ngRoute",
                                               "ngTagsInput",
                                               "ngFileUpload",
                                               "ui.bootstrap",
                                               "textAngular",
                                               "blogListCtrl",
                                               "blogDetailCtrl",
                                               "blogCategoryCtrl",
                                               "blogStatisticsCtrl",
                                               "categoryListCtrl",
                                               "categoryDetailCtrl",
                                               "UploadImageModalCtrl"]);
    
    blogApp
        .config(["$routeProvider", function ($routeProvider) {
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
                .when("/:blogpostId", {
                    templateUrl: "/themes/default/modules/com/IcedReaper/blog/partials/blogDetail.html",
                    controller:  "blogDetailCtrl"
                })
                .otherwise({
                    redirectTo: "/"
                });
        }])
        .config(["$httpProvider", globalAngularAjaxSettings]);
}(window.angular));