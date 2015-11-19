(function(angular) {
    var moduleManagerDetailCtrl = angular.module('moduleManagerDetailCtrl', ["moduleManagerAdminService"]);
    
    moduleManagerDetailCtrl.controller('moduleManagerDetailCtrl', function ($scope, $routeParams, moduleManagerService) {
        moduleManagerService
            .getDetails($routeParams.moduleId)
            .then(function (moduleDetails) {
                $scope.module = moduleDetails.data;
            });
        
        $scope.save = function () {
            moduleManagerService
                .save($scope.module);
        };
    });
}(window.angular));