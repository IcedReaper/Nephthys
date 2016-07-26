nephthysAdminApp
    .controller('userDetailCtrl', ["$scope", "$routeParams", "$route", "$q", "userService", function ($scope, $routeParams, $route, $q, userService) {
        $scope.load = function() {
            $q.all([
                userService.getDetails($routeParams.userId),
                userService.getThemes(),
                userService.getPermissionsOfActualUser(),
                userService.getStatus()
            ])
            // and merging them
            .then($q.spread(function (userDetails, themes, actualPermissions, status) {
                $scope.user              = userDetails;
                $scope.themes            = themes;
                $scope.actualPermissions = actualPermissions;
                $scope.status            = status;
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
        
        $scope.pushToStatus = function (newStatusId) {
            if($scope.user.userId && newStatusId) {
                userService
                    .pushToStatus($scope.user.userId,
                                  newStatusId)
                    .then($scope.load);
            }
        };
        
        $scope.statusButtonClass = function (actualCanLogin, nextCanLogin) {
            if(! actualCanLogin && nextCanLogin) {
                return "btn-success";
            }
            if(actualCanLogin && ! nextCanLogin) {
                return "btn-danger";
            }
            if(! actualCanLogin && ! nextCanLogin) {
                return "btn-primary";
            }
            if(actualCanLogin && nextCanLogin) {
                return "btn-secondary";
            }
            
            return "btn-warning";
        };
        
        $scope.user = {};
        $scope.themes = [];
        $scope.actualPermissions = {};
        $scope.status = [];
        
        $scope.load();
    }]);