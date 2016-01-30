nephthysAdminApp
    .controller('userPermissionCtrl', ["$scope", "$rootScope", "$routeParams", "$q", "userService", function ($scope, $rootScope, $routeParams, $q, userService) {
        var userId = null;
        
        $scope.load = function () {
            if(userId !== null) {
                $q.all([
                    userService.getPermissions($routeParams.userId),
                    userService.getRoles()
                ])
                // and merging them
                .then($q.spread(function (permissionsOfUser, roles) {
                    $scope.permissions = permissionsOfUser.permissions;
                    $scope.roles       = roles.roles;
                }));
            }
        };
        
        $scope.save = function () {
            userService
                .savePermissions(userId, $scope.permissions)
                .then($scope.load);
        };
        
        $rootScope.$on('user-loaded', function(event, userData) {
            userId = userData.userId;
            
            $scope.load();
        });
    }]);