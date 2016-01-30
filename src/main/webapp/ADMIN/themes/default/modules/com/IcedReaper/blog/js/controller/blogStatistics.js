nephthysAdminApp
    .controller('blogStatisticsCtrl', ["$scope", "$rootScope", "$routeParams", "$q", "blogService", function ($scope, $rootScope, $routeParams, $q, blogService) {
        var blogpostId = null;
        $scope.load = function () {
            if(blogpostId !== null && ! isNaN(parseInt($scope.dayCount, 10))) {
                blogService
                    .getLastVisitChart(blogpostId, $scope.dayCount)
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
        
        $rootScope.$on('blog-loaded', function(event, blogData) {
            blogpostId = blogData.blogpostId;
            
            $scope.load();
        });
    }]);