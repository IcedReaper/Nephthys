angular.module("com.nephthys.user.loginLog", [])
    .service("loginLogService", function($http) {
        return {
            getList: function () {
                return $http.get('/ajax/com/Nephthys/user/loginStatistics');
            }
        };
    })
    .controller('loginLogController', ["$scope", "loginLogService", function ($scope, loginLogService) {
        $scope.refresh = function () {
            loginLogService
                .getList()
                .then(function (loginStatistics) {
                    $scope.successfulLogins = loginStatistics.successful;
                    $scope.failedLogins     = loginStatistics.failed;
                });
        };
        
        $scope.refresh();
    }])
    .directive('nephthysUserLoginLog', function () {
        return {
            replace: true,
            restrict: "E",
            controller: "loginLogController",
            scope: {
                type: "@"
            },
            templateUrl : "/themes/default/modules/com/Nephthys/user/directives/loginLog/loginLog.html"
        };
    });