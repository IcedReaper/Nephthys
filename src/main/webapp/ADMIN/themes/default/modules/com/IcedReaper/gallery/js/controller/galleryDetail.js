(function(angular) {
    var galleryDetailCtrl = angular.module('galleryDetailCtrl', ["galleryAdminService"]);
    
    galleryDetailCtrl.controller('galleryDetailCtrl', function ($scope, $rootScope, $routeParams, $q, galleryService) {
        // load
        $scope.load = function() {
            galleryService
                .getDetails($routeParams.galleryId)
                .then(function (galleryDetails) {
                    $scope.gallery = galleryDetails.data;
                    
                    $rootScope.$emit('gallery-loaded', {galleryId: galleryDetails.data.galleryId});
                });
        };
        
        $scope.save = function () {
            galleryService
                .save($scope.gallery)
                .then(function (result) {
                    $scope.gallery = result.data;
                })
                .then($scope.loadPictures);
        };
        
        // init
        $scope.load();
        
        $rootScope.galleryId = $routeParams.galleryId;
    });
}(window.angular));