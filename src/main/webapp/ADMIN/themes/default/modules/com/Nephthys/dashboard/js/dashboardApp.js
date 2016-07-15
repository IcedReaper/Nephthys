var nephthysAdminApp = angular.module("nephthysAdminApp", ["com.nephthys.global.loadingBar",
                                                           "com.nephthys.page.statistics",
                                                           "com.nephthys.page.tasklist",
                                                           "com.nephthys.user.loginLog",
                                                           "com.nephthys.user.statistics",
                                                           "com.Nephthys.errorLog.statistics"]);

nephthysAdminApp
    .config(["$httpProvider", globalAngularAjaxSettings])
    .config(window.$QDecorator);