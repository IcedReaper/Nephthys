var nephthysAdminApp = angular.module("nephthysAdminApp", ["com.nephthys.global.loadingBar"]);
    
nephthysAdminApp
    .config(["$httpProvider", globalAngularAjaxSettings])
    .config(window.$QDecorator);