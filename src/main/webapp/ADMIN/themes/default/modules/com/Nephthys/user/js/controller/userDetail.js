nephthysAdminApp
    .controller('userDetailCtrl', ["$scope", "$rootScope", "$routeParams", "$q", "userService", function ($scope, $rootScope, $routeParams, $q, userService) {
        $scope.load = function() {
            $q.all([
                userService.getDetails($routeParams.userId),
                userService.getThemes()
            ])
            // and merging them
            .then($q.spread(function (userDetails, themes) {
                $scope.user   = userDetails;
                $scope.themes = themes;
                
                $rootScope.$emit('user-loaded', {userId: userDetails.userId});
            }));
        };
        
        $scope.save = function () {
            userService
                .save($scope.user)
                .then(function (user) {
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
        
        $scope.load();
    }]);