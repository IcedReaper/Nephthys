var nephthysAdminApp = angular.module("nephthysAdminApp", ["chart.js",
                                                           "com.nephthys.page.pageVisit"]);

nephthysAdminApp
    .config(["$httpProvider", globalAngularAjaxSettings])
    .config(window.$QDecorator);