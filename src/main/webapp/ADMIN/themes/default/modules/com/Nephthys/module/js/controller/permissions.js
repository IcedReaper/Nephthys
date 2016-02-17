nephthysAdminApp
    .controller('permissionsCtrl', ["$scope", "$routeParams", "$q", "moduleService", function ($scope, $routeParams, $q, moduleService) {
        $scope.load = function () {
            $q.all([
                moduleService.getDetails($routeParams.moduleId),
                moduleService.getUser($routeParams.moduleId),
                moduleService.getRoles()
            ])
            // and merging them
            .then($q.spread(function (moduleDetails, users, roles) {
                $scope.moduleName = moduleDetails.data.moduleName;
                $scope.users      = users.users;
                $scope.roles      = roles.roles;
            }));
        };
        
        $scope.save = function() {
            moduleService
                .savePermissions($routeParams.moduleId, $scope.users)
                .then($scope.load);
        };
        
        $scope.load();
    }]);