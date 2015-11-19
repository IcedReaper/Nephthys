(function(angular) {
    var loginStatisticsCtrl = angular.module('loginStatisticsCtrl', ["loginStatisticsService"]);
    
    loginStatisticsCtrl.controller('loginStatisticsCtrl', function ($scope, loginStatisticsService, $q) {
        $scope.refresh = function () {
            loginStatisticsService
                .getList()
                .then(function (loginStatistics) {
                    $scope.successfulLogins = loginStatistics.successful;
                    $scope.failedLogins     = loginStatistics.failed;
                });
        };
        
        $scope.refresh();
    });
}(window.angular));