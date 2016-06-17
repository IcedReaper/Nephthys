var nephthysAdminApp = angular.module("nephthysAdminApp", ["com.nephthys.page.statistics",
                                                           "com.nephthys.page.tasklist",
                                                           "com.nephthys.user.loginLog",
                                                           "com.nephthys.user.statistics"]);

nephthysAdminApp
    .config(["$httpProvider", globalAngularAjaxSettings])
    .config(window.$QDecorator);