nephthysAdminApp
    .controller('statusDetailCtrl', ["$scope", "$routeParams", "$q", "statusService", function ($scope, $routeParams, $q, statusService) {
        $scope.load = function () {
            statusService
                .getDetails($routeParams.statusId)
                .then(function (status) {
                    $scope.status          = status;
                });
        };
        
        $scope.save = function () {
            statusService
                .save($scope.status)
                .then($scope.load);
        };
        
        $scope.load();
    }]);