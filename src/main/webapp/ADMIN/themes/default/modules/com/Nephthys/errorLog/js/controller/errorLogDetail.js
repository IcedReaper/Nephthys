nephthysAdminApp
    .controller('errorLogDetailCtrl', ["$scope", "$routeParams", "errorLogService", function ($scope, $routeParams, errorLogService) {
        $scope.load = function () {
            errorLogService
                .getDetails($scope.errorCode,
                            $scope.fromDate,
                            $scope.toDate,
                            $scope.errorId)
                .then(function (error) {
                    $scope.details         = error.details;
                    $scope.previousErrorId = error.previousErrorId;
                    $scope.nextErrorId     = error.nextErrorId;
                });
        };
        
        $scope.errorCode = $routeParams.errorCode;
        $scope.fromDate  = $routeParams.fromDate.urlFormatToDate();
        $scope.toDate    = $routeParams.toDate.urlFormatToDate();
        $scope.errorId   = $routeParams.errorId;
        
        $scope.load();
    }]);