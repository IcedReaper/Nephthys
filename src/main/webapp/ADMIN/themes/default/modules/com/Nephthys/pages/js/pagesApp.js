var nephthysAdminApp = angular.module("nephthysAdminApp", ["ngRoute", 
                                                           "chart.js",
                                                           "textAngular"]);

nephthysAdminApp
    .config(["$routeProvider",
        function ($routeProvider) {
            $routeProvider
                .when("/", {
                    templateUrl: "/themes/default/modules/com/Nephthys/pages/partials/pagesList.html",
                    controller:  "pagesListCtrl"
                })
                .when("/status", {
                    templateUrl: "/themes/default/modules/com/Nephthys/pages/partials/statusList.html",
                    controller:  "statusListCtrl"
                })
                .when("/status/:pageStatusId", {
                    templateUrl: "/themes/default/modules/com/Nephthys/pages/partials/statusDetail.html",
                    controller:  "statusDetailCtrl"
                })
                /*.when("/statusflow", {
                    templateUrl: "/themes/default/modules/com/Nephthys/pages/partials/statusFlow.html",
                    controller:  "statusFlowCtrl"
                })*/
                .when("/:pageId", {
                    templateUrl: "/themes/default/modules/com/Nephthys/pages/partials/pagesDetail.html",
                    controller:  "pagesDetailCtrl"
                })
                .when("/:pageId/statistics", {
                    templateUrl: "/themes/default/modules/com/Nephthys/pages/partials/pagesStatistics.html",
                    controller:  "pagesStatisticsCtrl"
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