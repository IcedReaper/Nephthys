nephthysAdminApp
    .controller('userPermissionCtrl', ["$scope", "$routeParams", "$q", "userService", function ($scope, $routeParams, $q, userService) {
        $scope.load = function () {
            if($routeParams.userId !== null && $routeParams.userId !== 0) {
                $q.all([
                    userService.getPermissions($routeParams.userId),
                    userService.getRoles()
                ])
                .then($q.spread(function (permissionsOfUser, roles) {
                    $scope.permissions = permissionsOfUser;
                    $scope.roles       = roles;
                }));
            }
        };
        
        $scope.save = function () {
            userService.savePermissions($routeParams.userId, $scope.permissions);
        };
        
        $scope.load();
    }]);