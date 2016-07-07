nephthysAdminApp
    .controller("overviewCtrl", ["$scope", "requestService", function($scope, service) {
        service
            .getList()
            .then(function (requests) {
                $scope.requests = requests;
            });
    }]);