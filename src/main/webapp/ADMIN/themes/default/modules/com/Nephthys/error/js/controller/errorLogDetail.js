nephthysAdminApp
    .controller('errorLogDetailCtrl', ["$scope", "$routeParam", "errorLogService", function ($scope, $routeParams, errorLogService) {
        errorLogService
            .getDetails($routeParams.errorCode)
            .then(function (errorLogDetails) {
                $scope.errorLog = errorLogDetails.data;
            });
    }]);