var nephthysAdminApp = angular.module("nephthysAdminApp", ["com.Nephthys.global.loadingBar",
                                                           "com.Nephthys.pageManager.statistics",
                                                           "com.Nephthys.pageManager.tasklist",
                                                           "com.Nephthys.userManager.tasklist",
                                                           "com.Nephthys.userManager.loginLog",
                                                           "com.Nephthys.userManager.statistics",
                                                           "com.Nephthys.errorLog.statistics",
                                                           "com.IcedReaper.blog.tasklist",
                                                           "com.IcedReaper.gallery.tasklist"]);

nephthysAdminApp
    .config(["$httpProvider", globalAngularAjaxSettings])
    .config(window.$QDecorator);