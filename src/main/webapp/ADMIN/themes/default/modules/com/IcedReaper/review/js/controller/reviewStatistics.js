nephthysAdminApp
    .controller('reviewStatisticsCtrl', ["$scope", "$routeParams", "$q", "reviewService", function ($scope, $routeParams, $q, reviewService) {
        $scope.load = function () {
            if($routeParams.reviewId !== null && ! isNaN(parseInt($scope.dayCount, 10))) {
                reviewService
                    .getLastVisitChart($routeParams.reviewId, $scope.dayCount)
                    .then(function (visitData) {
                        $scope.visitChart = {
                            labels: visitData.labels,
                            data:   [visitData.data]
                        };
                    });
            }
        };
        
        $scope.$watch('dayCount', $scope.load);
        
        $scope.visitChart = {
            labels: [],
            data:   []
        };
        
        $scope.dayCount = 20;
    }]);