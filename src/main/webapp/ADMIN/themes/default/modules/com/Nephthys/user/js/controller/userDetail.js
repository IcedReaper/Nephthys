nephthysAdminApp
    .controller('userDetailCtrl', ["$scope", "$rootScope", "$routeParams", "$q", "userService", function ($scope, $rootScope, $routeParams, $q, userService) {
        $scope.load = function() {
            $q.all([
                userService.getDetails($routeParams.userId),
                userService.getThemes()
            ])
            // and merging them
            .then($q.spread(function (userDetails, themes) {
                $scope.user   = userDetails.data;
                $scope.themes = themes.data;
                
                $rootScope.$emit('user-loaded', {userId: userDetails.data.userId});
            }));
        };
        
        userService
            .getDetails($routeParams.userId)
            .then(function (userDetails) {
                $scope.user = userDetails.data;
                
                $rootScope.$emit('user-loaded', {userId: userDetails.data.userId});
            });
        
        $scope.save = function () {
            userService
                .save($scope.user)
                .then(function (result) {
                    $scope.user = result.data;
                });
        };
        
        $scope.uploadAvatar = function () {
            userService
                .uploadAvatar($scope.user.userId, $scope.user.newAvatar)
                .then(function (result) {
                    $scope.user.avatar    = result.avatar;
                    $scope.user.newAvatar = "";
                });
        };
        
        $scope.load();
    }]);