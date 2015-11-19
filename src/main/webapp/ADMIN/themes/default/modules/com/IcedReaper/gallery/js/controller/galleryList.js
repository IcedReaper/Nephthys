(function(angular) {
    var galleryListCtrl = angular.module('galleryListCtrl', ["galleryAdminService"]);
    
    galleryListCtrl.controller('galleryListCtrl', function ($scope, galleryService) {
        $scope.activate = function (galleryId) {
            galleryService
                .activate(galleryId)
                .then($scope.refresh);
        };
        $scope.deactivate = function (galleryId) {
            galleryService
                .deactivate(galleryId)
                .then($scope.refresh);
        };
        
        $scope.delete = function (galleryId) {
            galleryService
                .delete(galleryId)
                .then($scope.refresh);
        }
        
        $scope.refresh = function () {
            galleryService
                .getList()
                .then(function (galleries) {
                    $scope.galleries = galleries.data;
                });
        };
        
        $scope.galleries = [];
        $scope.search = {
            active: "", 
            filterCategory: "",
            creatorUserId: ""
        };
        $scope.refresh();
    });
}(window.angular));