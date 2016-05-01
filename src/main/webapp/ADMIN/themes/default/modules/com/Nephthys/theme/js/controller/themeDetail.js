nephthysAdminApp
    .controller('themeDetailCtrl', ["$scope", "$routeParams", "themeService", function ($scope, $routeParams, themeService) {
        themeService
            .getDetails($routeParams.themeId)
            .then(function (themeDetails) {
                $scope.theme = themeDetails;
            });
        
        $scope.createTheme = function () {
            themeService.createTheme($scope.theme.uploadFile, $scope.theme)
                .then(function (result) {
                    $scope.theme = result;
                });
        };
        
        $scope.save = function () {
            themeService
                .save($scope.theme)
                .then(function (result) {
                    $scope.theme = result;
                });
        };
    }]);