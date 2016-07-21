var nephthysAdminApp = angular.module("nephthysAdminApp", ["ngRoute",
                                                           "ngTagsInput",
                                                           "ngFileUpload",
                                                           "ui.bootstrap",
                                                           "textAngular",
                                                           "ui.bootstrap",
                                                           "ui.tree",
                                                           "com.nephthys.global.loadingBar",
                                                           "com.IcedReaper.blog.statistics",
                                                           "com.IcedReaper.blog.tasklist",
                                                           "com.nephthys.system.moduleSettings"]);
    
nephthysAdminApp
    .config(["$routeProvider", function ($routeProvider) {
        $routeProvider
            .when("/", {
                templateUrl: "/themes/default/modules/com/IcedReaper/blog/partials/tasklist.html"
            })
            
            .when("/blogpost/list", {
                templateUrl: "/themes/default/modules/com/IcedReaper/blog/partials/blogList.html",
                controller:  "blogListCtrl"
            })
            .when("/blogpost/:blogpostId", {
                templateUrl: "/themes/default/modules/com/IcedReaper/blog/partials/blogDetail.html",
                controller:  "blogDetailCtrl"
            })
            
            .when("/statistics", {
                templateUrl: "/themes/default/modules/com/IcedReaper/blog/partials/statistics.html"
            })
            
            .when("/category/list", {
                templateUrl: "/themes/default/modules/com/IcedReaper/blog/partials/categoryList.html",
                controller:  "categoryListCtrl"
            })
            .when("/category/:categoryId", {
                templateUrl: "/themes/default/modules/com/IcedReaper/blog/partials/categoryDetail.html",
                controller:  "categoryDetailCtrl"
            })
            
            .when("/settings", {
                templateUrl: "/themes/default/modules/com/IcedReaper/blog/partials/settings.html"
            })
            
            .when("/status/list", {
                templateUrl: "/themes/default/modules/com/IcedReaper/blog/partials/statusList.html",
                controller:  "statusListCtrl"
            })
            .when("/status/flow", {
                templateUrl: "/themes/default/modules/com/IcedReaper/blog/partials/statusFlow.html",
                controller:  "statusFlowCtrl"
            })
            .when("/status/:statusId", {
                templateUrl: "/themes/default/modules/com/IcedReaper/blog/partials/statusDetail.html",
                controller:  "statusDetailCtrl"
            })
            
            .otherwise({
                redirectTo: "/"
            });
    }])
    .config(["$httpProvider", globalAngularAjaxSettings])
    .config(window.$QDecorator);