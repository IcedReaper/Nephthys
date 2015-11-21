(function(angular) {
    var galleryStatisticsCtrl = angular.module('galleryStatisticsCtrl', ["chart.js", "galleryAdminService"]);
    
    galleryStatisticsCtrl.controller('galleryStatisticsCtrl', function ($scope, $rootScope, $routeParams, galleryService, $q) {
        var galleryId = null;
        $scope.load = function () {
            if(galleryId !== null && ! isNaN(parseInt($scope.dayCount, 10))) {
                galleryService
                    .getLastVisitChart(galleryId, $scope.dayCount)
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
        
        $rootScope.$on('gallery-loaded', function(event, galleryData) {
            galleryId = galleryData.galleryId;
            
            $scope.load();
        });
    });
}(window.angular));