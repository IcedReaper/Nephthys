var nephthysAdminApp = angular.module("nephthysAdminApp", ["chart.js",
                                                           "com.nephthys.global.loadingBar"]);
    
nephthysAdminApp
    .config(["$httpProvider", globalAngularAjaxSettings])
    .config(window.$QDecorator);