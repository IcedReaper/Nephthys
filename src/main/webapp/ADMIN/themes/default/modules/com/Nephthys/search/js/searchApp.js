var nephthysAdminApp = angular.module("nephthysAdminApp", ["ngRoute",
                                                           "ui.bootstrap",
                                                           "com.Nephthys.global.loadingBar",
                                                           "com.Nephthys.search.statistics",
                                                           "com.Nephthys.search.overview"]);

nephthysAdminApp
    .config(["$routeProvider",
        function ($routeProvider) {
            $routeProvider
                .when("/", {
                    templateUrl: "/themes/default/modules/com/Nephthys/search/partials/overview.html",
                    controller: "overviewCtrl"
                })
                .otherwise({
                    redirectTo: "/"
                });
        }
    ])
    .config(["$httpProvider", globalAngularAjaxSettings])
    .config(window.$QDecorator);