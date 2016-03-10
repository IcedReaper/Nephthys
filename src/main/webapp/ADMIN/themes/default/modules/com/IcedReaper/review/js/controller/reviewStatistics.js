nephthysAdminApp
    .controller('reviewStatisticsCtrl', ["$scope", "$rootScope", "$routeParams", "$q", "reviewService", function ($scope, $rootScope, $routeParams, $q, reviewService) {
        var reviewId = null;
        $scope.load = function () {
            if(reviewId !== null && ! isNaN(parseInt($scope.dayCount, 10))) {
                reviewService
                    .getLastVisitChart(reviewId, $scope.dayCount)
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
        
        $rootScope.$on('review-loaded', function(event, reviewData) {
            reviewId = reviewData.reviewId;
            
            $scope.load();
        });
    }]);