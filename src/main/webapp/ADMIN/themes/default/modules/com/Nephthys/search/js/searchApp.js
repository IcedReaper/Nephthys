var nephthysAdminApp = angular.module("nephthysAdminApp", ["ngRoute",
                                                           "ui.bootstrap",
                                                           "com.nephthys.global.loadingBar",
                                                           "com.nephthys.search.statistics",
                                                           "com.nephthys.search.overview"]);

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