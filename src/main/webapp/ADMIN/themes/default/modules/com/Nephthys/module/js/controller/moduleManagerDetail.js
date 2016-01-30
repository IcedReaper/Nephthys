nephthysAdminApp
    .controller('moduleManagerDetailCtrl', ["$scope", "$routeParams", "moduleManagerService", function ($scope, $routeParams, moduleManagerService) {
        moduleManagerService
            .getDetails($routeParams.moduleId)
            .then(function (moduleDetails) {
                $scope.module = moduleDetails.data;
            });
        
        $scope.save = function () {
            moduleManagerService
                .save($scope.module);
        };
    }]);