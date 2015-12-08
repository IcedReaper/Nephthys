(function(angular) {
    var blogStatisticsCtrl = angular.module('blogStatisticsCtrl', ["chart.js", "blogAdminService"]);
    
    blogStatisticsCtrl.controller('blogStatisticsCtrl', function ($scope, $rootScope, $routeParams, blogService, $q) {
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
    });
}(window.angular));