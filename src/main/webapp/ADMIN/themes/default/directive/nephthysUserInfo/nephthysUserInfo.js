angular.module("com.Nephthys.global.userInfo", [])
    .directive("nephthysUserInfo", function() {
        return {
            replace: true,
            restrict: "E",
            scope: {
                user: "=?",
                hideName: "@"
            },
            templateUrl : "/themes/default/directive/nephthysUserInfo/nephthysUserInfo.html"
        };
    });