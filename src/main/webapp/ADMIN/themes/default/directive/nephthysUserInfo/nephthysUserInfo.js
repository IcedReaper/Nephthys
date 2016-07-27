angular.module("com.Nephthys.global.userInfo", [])
    .directive("nephthysUserInfo", function() {
        return {
            replace: true,
            restrict: "E",
            scope: {
                user: "=?",
                hideName: "@"
            },
            templateUrl : "/themes/default/directive/nephthysUserInfo/nephthysUserInfo.html",
            link: function (scope, element, attrs) {
                if(scope.hideName === undefined) {
                    scope.hideName = false;
                }
            }
        };
    });