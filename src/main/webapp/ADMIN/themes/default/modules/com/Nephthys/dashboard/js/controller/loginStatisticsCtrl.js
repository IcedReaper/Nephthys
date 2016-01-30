nephthysAdminApp
    .controller('loginStatisticsCtrl', ["$scope", "$q", "loginStatisticsService", function ($scope, $q, loginStatisticsService) {
        $scope.refresh = function () {
            loginStatisticsService
                .getList()
                .then(function (loginStatistics) {
                    $scope.successfulLogins = loginStatistics.successful;
                    $scope.failedLogins     = loginStatistics.failed;
                });
        };
        
        $scope.refresh();
    }]);