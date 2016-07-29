var nephthysAdminApp = angular.module("nephthysAdminApp", ["ngRoute",
                                                           "com.Nephthys.global.loadingBar"]);
    
nephthysAdminApp
    .config(["$routeProvider",
        function ($routeProvider) {
            $routeProvider
                .when("/", {
                    templateUrl: "/themes/default/modules/com/IcedReaper/contactForm/partials/contactFormList.html",
                    controller:  "contactFormListCtrl"
                })
                .when("/:contactRequestId?", {
                    templateUrl: "/themes/default/modules/com/IcedReaper/contactForm/partials/contactFormDetail.html",
                    controller:  "contactFormDetailCtrl"
                })
                .otherwise({
                    redirectTo: "/"
                });
        }
    ])
    .config(["$httpProvider", globalAngularAjaxSettings])
    .config(window.$QDecorator);