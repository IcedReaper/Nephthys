var nephthysAdminApp = angular.module("nephthysAdminApp", ["ngRoute", 
                                                           "chart.js",
                                                           "ui.tree",
                                                           "textAngular"]);

nephthysAdminApp
    .config(["$routeProvider",
        function ($routeProvider) {
            $routeProvider
                .when("/", {
                    templateUrl: "/themes/default/modules/com/Nephthys/pages/partials/tasklist.html",
                    controller:  "tasklistCtrl"
                })
                
                .when("/pages/list", {
                    templateUrl: "/themes/default/modules/com/Nephthys/pages/partials/pagesList.html",
                    controller:  "pagesListCtrl"
                })
                .when("/pages/:pageId/version/:majorVersion/:minorVersion", {
                    templateUrl: "/themes/default/modules/com/Nephthys/pages/partials/pagesDetail.html",
                    controller:  "pagesDetailCtrl"
                })
                .when("/pages/:pageId", {
                    templateUrl: "/themes/default/modules/com/Nephthys/pages/partials/pagesDetail.html",
                    controller:  "pagesDetailCtrl"
                })
                .when("/pages/:pageId/statistics", {
                    templateUrl: "/themes/default/modules/com/Nephthys/pages/partials/pagesStatistics.html",
                    controller:  "pagesStatisticsCtrl"
                })
                
                .when("/status/list", {
                    templateUrl: "/themes/default/modules/com/Nephthys/pages/partials/statusList.html",
                    controller:  "statusListCtrl"
                })
                .when("/status/flow", {
                    templateUrl: "/themes/default/modules/com/Nephthys/pages/partials/statusFlow.html",
                    controller:  "statusFlowCtrl"
                })
                .when("/status/:statusId", {
                    templateUrl: "/themes/default/modules/com/Nephthys/pages/partials/statusDetail.html",
                    controller:  "statusDetailCtrl"
                })
                
                .when("/sitemap", {
                    templateUrl: "/themes/default/modules/com/Nephthys/pages/partials/sitemap.html",
                    controller: "sitemapCtrl"
                })
                .otherwise({
                    redirectTo: "/"
                });
        }
    ])
    .config(["$httpProvider", globalAngularAjaxSettings])
    .config(window.$QDecorator);

Array.prototype.move = function (old_index, new_index) {
    if (new_index >= this.length) {
        var k = new_index - this.length;
        while ((k--) + 1) {
            this.push(undefined);
        }
    }
    this.splice(new_index, 0, this.splice(old_index, 1)[0]);
    return this;
};

structDeepCopy = function (struct) {
    return JSON.parse(JSON.stringify(struct));
};