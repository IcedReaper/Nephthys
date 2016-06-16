var nephthysAdminApp = angular.module("nephthysAdminApp", ["com.nephthys.page.statistics",
                                                           "com.nephthys.page.tasklist"]);

nephthysAdminApp
    .config(["$httpProvider", globalAngularAjaxSettings])
    .config(window.$QDecorator);