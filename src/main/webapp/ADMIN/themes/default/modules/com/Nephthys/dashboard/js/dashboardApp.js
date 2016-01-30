var nephthysAdminApp = angular.module("nephthysAdminApp", ["visitService",
                                                           "loginStatisticsService",
                                                           "chart.js"]);

nephthysAdminApp
    .config(["$httpProvider", globalAngularAjaxSettings])
    .config(window.$QDecorator);