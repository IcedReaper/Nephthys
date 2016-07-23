nephthysAdminApp
    .controller("moduleSettingsCtrl", ["$scope", "$routeParams", function($scope, $routeParams) {
        $scope.moduleName = $routeParams.moduleName;
    }]);