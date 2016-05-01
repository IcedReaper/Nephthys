nephthysAdminApp
    .controller('statusDetailCtrl', ["$scope", "$routeParams", "$q", "pageStatusService", function ($scope, $routeParams, $q, pageStatusService) {
        $scope.load = function () {
            pageStatusService
                .getDetails($routeParams.pageStatusId)
                .then(function (pageStatus) {
                    $scope.pageStatus = pageStatus;
                });
        };
        
        $scope.save = function () {
            pageStatusService
                .save($scope.pageStatus)
                .then($scope.load);
        };
        
        $scope.load();
    }]);