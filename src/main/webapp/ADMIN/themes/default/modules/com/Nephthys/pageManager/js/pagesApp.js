var nephthysAdminApp = angular.module("nephthysAdminApp", ["ngRoute", 
                                                           "chart.js",
                                                           "ui.tree",
                                                           "ui.bootstrap",
                                                           "textAngular",
                                                           "com.nephthys.global.loadingBar",
                                                           "com.nephthys.global.userInfo",
                                                           "com.nephthys.page.statistics",
                                                           "com.nephthys.page.tasklist"]);

nephthysAdminApp
    .config(["$routeProvider",
        function ($routeProvider) {
            $routeProvider
                .when("/", {
                    templateUrl: "/themes/default/modules/com/Nephthys/pageManager/partials/tasklist.html"
                })
                
                .when("/pages/list", {
                    templateUrl: "/themes/default/modules/com/Nephthys/pageManager/partials/pagesList.html",
                    controller:  "pagesListCtrl"
                })
                .when("/pages/:pageId/version/:majorVersion/:minorVersion", {
                    templateUrl: "/themes/default/modules/com/Nephthys/pageManager/partials/pagesDetail.html",
                    controller:  "pagesDetailCtrl"
                })
                .when("/pages/:pageId", {
                    templateUrl: "/themes/default/modules/com/Nephthys/pageManager/partials/pagesDetail.html",
                    controller:  "pagesDetailCtrl"
                })
                
                .when("/status/list", {
                    templateUrl: "/themes/default/modules/com/Nephthys/pageManager/partials/statusList.html",
                    controller:  "statusListCtrl"
                })
                .when("/status/flow", {
                    templateUrl: "/themes/default/modules/com/Nephthys/pageManager/partials/statusFlow.html",
                    controller:  "statusFlowCtrl"
                })
                .when("/status/:statusId", {
                    templateUrl: "/themes/default/modules/com/Nephthys/pageManager/partials/statusDetail.html",
                    controller:  "statusDetailCtrl"
                })
                
                .when("/sitemap/:sitemapId", {
                    templateUrl: "/themes/default/modules/com/Nephthys/pageManager/partials/sitemap.html",
                    controller: "sitemapCtrl"
                })
                .when("/sitemap", {
                    templateUrl: "/themes/default/modules/com/Nephthys/pageManager/partials/sitemap.html",
                    controller: "sitemapCtrl"
                })
                
                .when("/statistic", {
                    templateUrl: "/themes/default/modules/com/Nephthys/pageManager/partials/statistics.html"
                })
                
                .otherwise({
                    redirectTo: "/"
                });
        }
    ])
    .config(["$httpProvider", globalAngularAjaxSettings])
    .config(window.$QDecorator);