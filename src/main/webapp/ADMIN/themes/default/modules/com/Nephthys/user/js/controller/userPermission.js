(function(angular) {
    var userPermissionCtrl = angular.module('userPermissionCtrl', ["userAdminService"]);
    
    userPermissionCtrl.controller('userPermissionCtrl', function ($scope, $routeParams, userService, $q) {
        // making multiple parallel ajax calls
        $q.all([
                userService.getDetails($routeParams.userId),
                userService.getPermissions($routeParams.userId),
                userService.getPermissionList()
            ])
            // and merging them
            .then($q.spread(function (userDetails, permissionsOfUser, permissionList) {
                    $scope.username = userDetails.data.username;
                    
                    console.log('permissionsOfUser', permissionsOfUser);
                    console.log('permissionList', permissionList);
                }));
        
        $scope.save = function(user) {
            console.log('save permissions...');
        };
        
        $scope.username = '';
    });
}(window.angular));