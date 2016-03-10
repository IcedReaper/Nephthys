nephthysAdminApp
    .controller('typeListCtrl', ["$scope", "typeService", function ($scope, typeService) {
        $scope.delete = function (typeId) {
            typeService
                .delete(typeId)
                .then($scope.refresh);
        }
        
        $scope.refresh = function () {
            typeService
                .getList()
                .then(function (types) {
                    $scope.types = types;
                });
        };
        
        $scope.types = [];
        $scope.refresh();
    }]);