var nephthysAdminApp = angular.module("nephthysAdminApp", ["ngRoute",
                                                           "ngTagsInput",
                                                           "ngFileUpload",
                                                           "textAngular",
                                                           "ui.bootstrap",
                                                           "ui.tree",
                                                           "com.nephthys.global.loadingBar",
                                                           "com.IcedReaper.gallery.statistics",
                                                           "com.IcedReaper.gallery.tasklist"]);
    
nephthysAdminApp
    .config(["$routeProvider", function ($routeProvider) {
        $routeProvider
            .when("/tasklist", {
                templateUrl: "/themes/default/modules/com/IcedReaper/gallery/partials/tasklist.html"
            })
            
            .when("/gallery/list", {
                templateUrl: "/themes/default/modules/com/IcedReaper/gallery/partials/galleryList.html",
                controller:  "galleryListCtrl"
            })
            .when("/gallery/:galleryId", {
                templateUrl: "/themes/default/modules/com/IcedReaper/gallery/partials/galleryDetail.html",
                controller:  "galleryDetailCtrl"
            })
            
            .when("/statistics", {
                templateUrl: "/themes/default/modules/com/IcedReaper/gallery/partials/statistics.html"
            })
            
            .when("/category/list", {
                templateUrl: "/themes/default/modules/com/IcedReaper/gallery/partials/categoryList.html",
                controller:  "categoryListCtrl"
            })
            .when("/category/:categoryId", {
                templateUrl: "/themes/default/modules/com/IcedReaper/gallery/partials/categoryDetail.html",
                controller:  "categoryDetailCtrl"
            })
            
            .when("/status/list", {
                templateUrl: "/themes/default/modules/com/IcedReaper/gallery/partials/statusList.html",
                controller:  "statusListCtrl"
            })
            .when("/status/flow", {
                templateUrl: "/themes/default/modules/com/IcedReaper/gallery/partials/statusFlow.html",
                controller:  "statusFlowCtrl"
            })
            .when("/status/:statusId", {
                templateUrl: "/themes/default/modules/com/IcedReaper/gallery/partials/statusDetail.html",
                controller:  "statusDetailCtrl"
            })
            
            
            .otherwise({
                redirectTo: "/tasklist"
            });
        }
    ])
    .config(["$httpProvider", globalAngularAjaxSettings])
    .config(window.$QDecorator);