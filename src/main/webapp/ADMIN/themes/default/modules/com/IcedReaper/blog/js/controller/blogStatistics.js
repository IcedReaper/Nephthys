nephthysAdminApp
    .controller('blogStatisticsCtrl', ["$scope", "$rootScope", "$routeParams", "$q", "blogService", function ($scope, $rootScope, $routeParams, $q, blogService) {
        var blogpostId = null;
        $scope.load = function () {
            if(blogpostId !== null && ! isNaN(parseInt($scope.dayCount, 10))) {
                blogService
                    .getLastVisitChart(blogpostId, $scope.dayCount)
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
        
        $rootScope.$on('blog-loaded', function(event, blogData) {
            blogpostId = blogData.blogpostId;
            
            $scope.load();
        });
    }]);