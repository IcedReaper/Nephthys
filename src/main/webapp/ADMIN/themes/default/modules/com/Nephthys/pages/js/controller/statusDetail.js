nephthysAdminApp
    .controller('statusDetailCtrl', ["$scope", "$routeParams", "$q", "pageStatusService", function ($scope, $routeParams, $q, pageStatusService) {
        $scope.load = function () {
            $q.all([
                pageStatusService.getDetails($routeParams.pageStatusId),
                pageStatusService.getList()
            ])
            .then($q.spread(function (status, availableStatus) {
                $scope.status          = status;
                $scope.availableStatus = availableStatus;
            }));
        };
        
        $scope.save = function () {
            pageStatusService
                .save($scope.status)
                .then($scope.load);
        };
        
        $scope.load();
    }]);