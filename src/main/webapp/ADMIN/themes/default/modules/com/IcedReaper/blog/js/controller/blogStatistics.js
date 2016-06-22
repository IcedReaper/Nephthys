nephthysAdminApp
    .controller('blogStatisticsCtrl', ["$scope", "$routeParams", "$q", "blogService", function ($scope, $routeParams, $q, blogService) {
        $scope.load = function () {
            if($routeParams.blogpostId !== null && ! isNaN(parseInt($scope.dayCount, 10))) {
                blogService
                    .getLastVisitChart($routeParams.blogpostId, $scope.dayCount)
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
    }]);