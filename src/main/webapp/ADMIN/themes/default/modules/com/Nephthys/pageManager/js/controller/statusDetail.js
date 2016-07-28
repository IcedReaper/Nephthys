nephthysAdminApp
    .controller('statusDetailCtrl', ["$scope", "$routeParams", "$route", "$q", "statusService", function ($scope, $routeParams, $route, $q, statusService) {
        $scope.load = function () {
            statusService
                .getDetails($routeParams.statusId)
                .then(function (status) {
                    $scope.status = status;
                });
        };
        
        $scope.save = function () {
            statusService
                .save($scope.status)
                .then(function (newStatusId) {
                    if($scope.status.statusId != newStatusId) {
                        $scope.status.statusId = newStatusId;
                        
                        $route.updateParams({
                            statusId: newStatusId
                        });
                    }
                });
        };
        
        $scope.load();
    }]);