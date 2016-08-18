var nephthysAdminApp = angular.module("nephthysAdminApp", ["com.Nephthys.global.loadingBar"]);
    
nephthysAdminApp
    .config(["$httpProvider", globalAngularAjaxSettings])
    .config(window.$QDecorator);