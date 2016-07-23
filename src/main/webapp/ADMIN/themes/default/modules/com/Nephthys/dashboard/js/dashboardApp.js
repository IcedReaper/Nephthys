var nephthysAdminApp = angular.module("nephthysAdminApp", ["com.nephthys.global.loadingBar",
                                                           "com.nephthys.page.statistics",
                                                           "com.nephthys.page.tasklist",
                                                           "com.nephthys.userManager.loginLog",
                                                           "com.nephthys.userManager.statistics",
                                                           "com.Nephthys.errorLog.statistics"]);

nephthysAdminApp
    .config(["$httpProvider", globalAngularAjaxSettings])
    .config(window.$QDecorator);