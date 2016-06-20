var nephthysAdminApp = angular.module("nephthysAdminApp", ["ngRoute",
                                                           "ngTagsInput",
                                                           "ngFileUpload",
                                                           "ui.bootstrap",
                                                           "textAngular",
                                                           "chart.js",
                                                           "com.nephthys.global.loadingBar"]);
    
nephthysAdminApp
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
            .when("/settings", {
                templateUrl: "/themes/default/modules/com/IcedReaper/blog/partials/settings.html",
                controller: "settingsCtrl"
            })
            .when("/:blogpostId", {
                templateUrl: "/themes/default/modules/com/IcedReaper/blog/partials/blogDetail.html",
                controller:  "blogDetailCtrl"
            })
            .otherwise({
                redirectTo: "/"
            });
    }])
    .config(["$httpProvider", globalAngularAjaxSettings])
    .config(window.$QDecorator);