nephthysAdminApp
    .controller('listCtrl', ["$scope", "moduleService", function ($scope, moduleService) {
        $scope.activate = function (moduleId) {
            moduleService
                .activate(moduleId)
                .then($scope.refresh);
        };
        
        $scope.deactivate = function (moduleId) {
            moduleService
                .deactivate(moduleId)
                .then($scope.refresh);
        };
        
        $scope.delete = function (moduleId) {
            moduleService
                .delete(moduleId)
                .then($scope.refresh);
        };
        
        $scope.refresh = function () {
            moduleService
                .getList()
                .then(function (moduleManagerList) {
                    $scope.modules = moduleManagerList.data;
                });
        };
        
        $scope.modules = [];
        $scope.search = {};
        $scope.refresh();
    }]);