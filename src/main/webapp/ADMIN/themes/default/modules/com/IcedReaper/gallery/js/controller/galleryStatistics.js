nephthysAdminApp
    .controller('galleryStatisticsCtrl', ["$scope", "$routeParams", "$q", "galleryService", function ($scope, $routeParams, $q, galleryService) {
        $scope.load = function () {
            if($routeParams.galleryId !== null && ! isNaN(parseInt($scope.dayCount, 10))) {
                galleryService
                    .getLastVisitChart($routeParams.galleryId, $scope.dayCount)
                    .then(function (visitData) {
                        $scope.chart.labels = visitData.labels;
                        $scope.chart.data   = [visitData.data];
                    });
            }
        };
        
        $scope.$watch('dayCount', $scope.load);
        
        $scope.chart = {
            labels: [],
            data:   [],
            type:   "bar",
            options: {
                fixedHeight: true,
                height: 450,
                scales: {
                    yAxes: [{
                        ticks: {
                            beginAtZero:true
                        }
                    }]
                }
            }
        };
        
        $scope.dayCount = 20;
        
        $scope.load();
    }]);