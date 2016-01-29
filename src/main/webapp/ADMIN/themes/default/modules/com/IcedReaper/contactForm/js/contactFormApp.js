(function (angular) {
    var contactFormApp = angular.module("contactFormAdmin", ["ngRoute",
                                                             "contactFormListCtrl",
                                                             "contactFormDetailCtrl"]);
    
    contactFormApp
        .config(["$routeProvider",
            function ($routeProvider) {
                $routeProvider
                    .when("/", {
                        templateUrl: "/themes/default/modules/com/IcedReaper/contactForm/partials/contactFormList.html",
                        controller:  "contactFormListCtrl"
                    })
                    .when("/:requestId", {
                        templateUrl: "/themes/default/modules/com/IcedReaper/contactForm/partials/contactFormDetail.html",
                        controller:  "contactFormDetailCtrl"
                    })
                    .otherwise({
                        redirectTo: "/"
                    });
            }
        ])
        .config(["$httpProvider", globalAngularAjaxSettings]);
}(window.angular));