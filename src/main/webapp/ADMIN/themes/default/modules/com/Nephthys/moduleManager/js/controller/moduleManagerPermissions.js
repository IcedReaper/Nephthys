(function(angular) {
    var moduleManagerPermissionCtrl = angular.module('moduleManagerPermissionCtrl', ["moduleManagerAdminService"]);
    
    moduleManagerPermissionCtrl.controller('moduleManagerPermissionCtrl', function ($scope, $routeParams, moduleManagerService, $q) {
        $scope.load = function () {
            $q.all([
                moduleManagerService.getDetails($routeParams.moduleId),
                moduleManagerService.getUser($routeParams.moduleId),
                moduleManagerService.getRoles()
            ])
            // and merging them
            .then($q.spread(function (moduleDetails, users, roles) {
                $scope.moduleName = moduleDetails.data.moduleName;
                $scope.users      = users.users;
                $scope.roles      = roles.roles;
            }));
        };
        
        $scope.save = function() {
            moduleManagerService
                .savePermissions($routeParams.moduleId, $scope.users)
                .then($scope.load);
        };
        
        $scope.load();
    });
}(window.angular));