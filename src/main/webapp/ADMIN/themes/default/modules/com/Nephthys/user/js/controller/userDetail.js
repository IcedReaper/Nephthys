(function(angular) {
    var userDetailCtrl = angular.module('userDetailCtrl', ["userAdminService"]);
    
    userDetailCtrl.controller('userDetailCtrl', function ($scope, $rootScope, $routeParams, userService) {
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
    });
}(window.angular));