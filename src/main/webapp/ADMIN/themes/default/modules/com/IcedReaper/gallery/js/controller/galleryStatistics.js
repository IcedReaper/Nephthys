(function(angular) {
    var galleryStatisticsCtrl = angular.module('galleryStatisticsCtrl', ["chart.js", "galleryAdminService"]);
    
    galleryStatisticsCtrl.controller('galleryStatisticsCtrl', function ($scope, $rootScope, $routeParams, galleryService, $q) {
        var galleryId = null;
        $scope.load = function () {
            galleryService
                .getLastVisitChart(galleryId, 20)
                .then(function (visitData) {
                    $scope.visitChart = {
                        labels: visitData.labels,
                        data:   [visitData.data]
                    };
                });
        };
        $scope.visitChart = {
            labels: [],
            data:   []
        };
        
        $rootScope.$on('gallery-loaded', function(event, galleryData) {
            galleryId = galleryData.galleryId;
            
            $scope.load();
        });
    });
}(window.angular));