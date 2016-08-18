var nephthysAdminApp = angular.module("nephthysAdminApp", ["chart.js",
                                                           "com.Nephthys.global.loadingBar"]);
    
nephthysAdminApp
    .config(["$httpProvider", globalAngularAjaxSettings])
    .config(window.$QDecorator);