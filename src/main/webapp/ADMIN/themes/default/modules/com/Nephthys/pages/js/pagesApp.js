var nephthysAdminApp = angular.module("nephthysAdminApp", ["ngRoute", 
                                                           "chart.js",
                                                           "ui.tree",
                                                           "ui.bootstrap",
                                                           "textAngular",
                                                           "nephthys.userInfo",
                                                           "com.nephthys.page.pageVisit",
                                                           "com.nephthys.page.statistics.perPage"]);

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
                
                .when("/statistic", {
                    templateUrl: "/themes/default/modules/com/Nephthys/pages/partials/statistics.html"
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

structIsEmpty = function (struct) {
    return Object.keys(struct).length === 0 && struct.constructor === Object;
}