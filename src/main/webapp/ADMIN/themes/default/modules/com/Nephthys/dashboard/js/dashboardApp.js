var nephthysAdminApp = angular.module("nephthysAdminApp", ["com.nephthys.page.pageVisit"]);

nephthysAdminApp
    .config(["$httpProvider", globalAngularAjaxSettings])
    .config(window.$QDecorator);