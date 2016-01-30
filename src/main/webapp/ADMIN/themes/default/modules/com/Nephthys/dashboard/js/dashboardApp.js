var nephthysAdminApp = angular.module("nephthysAdminApp", ["chart.js"]);

nephthysAdminApp
    .config(["$httpProvider", globalAngularAjaxSettings])
    .config(window.$QDecorator);