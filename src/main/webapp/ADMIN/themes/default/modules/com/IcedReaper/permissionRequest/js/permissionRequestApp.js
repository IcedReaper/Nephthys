var nephthysAdminApp = angular.module("nephthysAdminApp", ["ngRoute",
                                                           "com.nephthys.global.loadingBar",
                                                           "com.nephthys.global.userInfo",
                                                           "com.IcedReaper.permissionRequest.tasklist"]);
    
nephthysAdminApp
    .config(["$routeProvider", function ($routeProvider) {
        $routeProvider
            .when("/tasklist", {
                templateUrl: "/themes/default/modules/com/IcedReaper/permissionRequest/partials/tasklist.html"
            })
            
            .when("/request/:requestId", {
                templateUrl: "/themes/default/modules/com/IcedReaper/permissionRequest/partials/galleryDetail.html",
                controller:  "requestDetailCtrl"
            })
            
            .otherwise({
                redirectTo: "/tasklist"
            });
        }
    ])
    .config(["$httpProvider", globalAngularAjaxSettings])
    .config(window.$QDecorator);