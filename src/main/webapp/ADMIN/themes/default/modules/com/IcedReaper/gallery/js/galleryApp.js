var nephthysAdminApp = angular.module("nephthysAdminApp", ["ngRoute",
                                                           "ngTagsInput",
                                                           "ngFileUpload",
                                                           "textAngular",
                                                           "ui.bootstrap",
                                                           "com.nephthys.global.loadingBar",
                                                           "com.IcedReaper.gallery.statistics"]);
    
nephthysAdminApp
    .config(["$routeProvider",
        function ($routeProvider) {
            $routeProvider
                .when("/", {
                    templateUrl: "/themes/default/modules/com/IcedReaper/gallery/partials/galleryList.html",
                    controller:  "galleryListCtrl"
                })
                
                .when("/statistics", {
                    templateUrl: "/themes/default/modules/com/IcedReaper/gallery/partials/statistics.html"
                })
                
                .when("/categories", {
                    templateUrl: "/themes/default/modules/com/IcedReaper/gallery/partials/categoryList.html",
                    controller:  "categoryListCtrl"
                })
                .when("/category/:categoryId", {
                    templateUrl: "/themes/default/modules/com/IcedReaper/gallery/partials/categoryDetail.html",
                    controller:  "categoryDetailCtrl"
                })
                
                .when("/:galleryId", {
                    templateUrl: "/themes/default/modules/com/IcedReaper/gallery/partials/galleryDetail.html",
                    controller:  "galleryDetailCtrl"
                })
                
                .otherwise({
                    redirectTo: "/"
                });
        }
    ])
    .config(["$httpProvider", globalAngularAjaxSettings])
    .config(window.$QDecorator);