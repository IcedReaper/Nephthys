nephthysAdminApp
    .controller('themeDetailCtrl', ["$scope", "$routeParams", "themeService", function ($scope, $routeParams, themeService) {
        themeService
            .getDetails($routeParams.themeId)
            .then(function (themeDetails) {
                $scope.theme = themeDetails.data;
            });
        
        $scope.createTheme = function () {
            themeService.createTheme($scope.theme.uploadFile, $scope.theme)
                .then(function (result) {
                    $scope.theme = result.data;
                });
        };
        
        $scope.save = function () {
            themeService
                .save($scope.theme)
                .then(function (result) {
                    $scope.theme = result.data;
                });
        };
    }]);