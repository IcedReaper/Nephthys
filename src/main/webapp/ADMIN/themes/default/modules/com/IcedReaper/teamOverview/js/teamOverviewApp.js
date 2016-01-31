var nephthysAdminApp = angular.module("nephthysAdminApp", []);
    
nephthysAdminApp
    .config(["$httpProvider", globalAngularAjaxSettings])
    .config(window.$QDecorator);