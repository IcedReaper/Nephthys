var nephthysAdminApp = angular.module("nephthysAdminApp", ["chart.js",
                                                           "ui.bootstrap"]);

nephthysAdminApp
    .config(["$httpProvider", globalAngularAjaxSettings])
    .config(window.$QDecorator);