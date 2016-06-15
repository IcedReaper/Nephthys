nephthysAdminApp
    .controller('galleryStatisticsCtrl', ["$scope", "$rootScope", "$routeParams", "$q", "galleryService", function ($scope, $rootScope, $routeParams, $q, galleryService) {
        var galleryId = null;
        $scope.load = function () {
            if(galleryId !== null && ! isNaN(parseInt($scope.dayCount, 10))) {
                galleryService
                    .getLastVisitChart(galleryId, $scope.dayCount)
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
        
        $rootScope.$on('gallery-loaded', function(event, galleryData) {
            galleryId = galleryData.galleryId;
            
            $scope.load();
        });
    }]);