(function(angular) {
    var moduleManagerListCtrl = angular.module('moduleManagerListCtrl', [ "moduleManagerAdminService" ]);
    
    moduleManagerListCtrl.controller('moduleManagerListCtrl', function ($scope, moduleManagerService) {
        $scope.activate = function (moduleId) {
            moduleManagerService
                .activate(moduleId)
                .then($scope.refresh);
        };
        
        $scope.deactivate = function (moduleId) {
            moduleManagerService
                .deactivate(moduleId)
                .then($scope.refresh);
        };
        
        $scope.delete = function (moduleId) {
            moduleManagerService
                .delete(moduleId)
                .then($scope.refresh);
        };
        
        $scope.refresh = function () {
            moduleManagerService
                .getList()
                .then(function (moduleManagerList) {
                    $scope.modules = moduleManagerList.data;
                });
        };
        
        $scope.modules = [];
        $scope.search = {
            active: ""
        };
        $scope.refresh();
    });
}(window.angular));