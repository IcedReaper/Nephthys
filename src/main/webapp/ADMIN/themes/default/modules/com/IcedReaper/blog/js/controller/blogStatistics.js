(function(angular) {
    var blogStatisticsCtrl = angular.module('blogStatisticsCtrl', ["chart.js", "blogAdminService"]);
    
    blogStatisticsCtrl.controller('blogStatisticsCtrl', function ($scope, $rootScope, $routeParams, blogService, $q) {
        var blogId = null;
        $scope.load = function () {
            if(blogId !== null && ! isNaN(parseInt($scope.dayCount, 10))) {
                blogService
                    .getLastVisitChart(blogId, $scope.dayCount)
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
            blogId = blogData.blogId;
            
            $scope.load();
        });
    });
}(window.angular));