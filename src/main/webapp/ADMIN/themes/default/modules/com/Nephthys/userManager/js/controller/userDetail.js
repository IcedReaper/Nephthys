nephthysAdminApp
    .controller('userDetailCtrl', ["$scope", "$routeParams", "$route", "$q", "userService", function ($scope, $routeParams, $route, $q, userService) {
        $scope.load = function() {
            $q.all([
                userService.getDetails($routeParams.userId),
                userService.getThemes(),
                userService.getPermissionsOfActualUser()
            ])
            // and merging them
            .then($q.spread(function (userDetails, themes, actualPermissions) {
                $scope.user              = userDetails;
                $scope.themes            = themes;
                $scope.actualPermissions = actualPermissions;
            }));
        };
        
        $scope.save = function () {
            userService
                .save($scope.user)
                .then(function (user) {
                    if($scope.user.userId != user.userId) {
                        $route.updateParams({
                            userId: userId
                        });
                    }
                    
                    $scope.user = user;
                });
        };
        
        $scope.uploadAvatar = function () {
            userService
                .uploadAvatar($scope.user.userId, $scope.user.newAvatar)
                .then(function (avatar) {
                    $scope.user.avatar    = avatar;
                    $scope.user.newAvatar = "";
                });
        };
        
        $scope.user = {};
        
        $scope.actualPermissions = {};
        
        $scope.load();
    }]);