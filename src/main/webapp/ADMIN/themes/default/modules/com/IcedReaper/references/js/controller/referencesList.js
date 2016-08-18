nephthysAdminApp
    .controller('referencesListCtrl', ["$scope", "referencesService", function ($scope, referencesService) {
        $scope.delete = function (referenceId) {
            referencesService
                .delete(referenceId)
                .then($scope.refresh);
        };
        
        $scope.refresh = function () {
            referencesService
                .getList()
                .then(function (references) {
                    $scope.references = references;
                });
        };
        
        $scope.references = [];
        $scope.search = {
            active: ""
        };
        $scope.refresh();
    }]);