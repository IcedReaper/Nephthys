(function(angular) {
    var galleryDetailCtrl = angular.module('galleryDetailCtrl', ["galleryAdminService"]);
    
    galleryDetailCtrl.controller('galleryDetailCtrl', function ($scope, $rootScope, $routeParams, $q, galleryService) {
        var activePage = "detail";
        // load
        $scope.load = function() {
            return galleryService
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
        
        // tabs and paging
        $scope.showPage = function (page) {
            activePage = page;
        };
        
        $scope.tabClasses = function (page) {
            return (activePage === page ? "active" : "");
        };
        
        $scope.pageClasses = function (page) {
            return (activePage === page ? "active" : "");
        };
        
        // init
        $scope
            .load()
            .then($scope.showPage('details'));
        
        $rootScope.galleryId = $routeParams.galleryId;
        $scope.initialized = false;
    });
}(window.angular));