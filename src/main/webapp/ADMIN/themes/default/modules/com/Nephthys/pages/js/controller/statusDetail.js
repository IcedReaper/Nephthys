(function(angular) {
    var statusDetailCtrl = angular.module('statusDetailCtrl', ["pageStatusService"]);
    
    statusDetailCtrl.controller('statusDetailCtrl', function ($scope, $routeParams, $q, pageStatusService) {
        $scope.load = function () {
            pageStatusService
                .getDetails($routeParams.pageStatusId)
                .then(function (pageStatus) {
                    $scope.pageStatus = pageStatus.data;
                });
        };
        
        $scope.save = function () {
            pageStatusService
                .save($scope.pageStatus)
                .then($scope.load);
        };
        
        $scope.load();
    });
}(window.angular));