var nephthysAdminApp = angular.module("nephthysAdminApp", ["com.nephthys.page.pageVisit",
                                                           "com.nephthys.page.statistics.perPage"]);

nephthysAdminApp
    .config(["$httpProvider", globalAngularAjaxSettings])
    .config(window.$QDecorator);