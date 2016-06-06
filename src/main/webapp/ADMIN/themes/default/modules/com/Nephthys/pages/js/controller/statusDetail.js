nephthysAdminApp
    .controller('statusDetailCtrl', ["$scope", "$routeParams", "$q", "statusService", function ($scope, $routeParams, $q, statusService) {
        $scope.load = function () {
            $q.all([
                statusService.getDetails($routeParams.statusId),
                statusService.getList()
            ])
            .then($q.spread(function (status, availableStatus) {
                $scope.status          = status;
                $scope.availableStatus = availableStatus;
            }));
        };
        
        $scope.save = function () {
            statusService
                .save($scope.status)
                .then($scope.load);
        };
        
        $scope.load();
    }]);