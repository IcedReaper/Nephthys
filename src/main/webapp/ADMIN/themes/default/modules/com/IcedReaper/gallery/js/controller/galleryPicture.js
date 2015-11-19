(function(angular) {
    var galleryPictureCtrl = angular.module('galleryPictureCtrl', ["galleryAdminService"]);
    
    galleryPictureCtrl.controller('galleryPictureCtrl', function ($scope, $rootScope, $routeParams, galleryService, $q) {
        var galleryId = null;
        $scope.load = function () {
            return galleryService
                    .loadPictures(galleryId)
                    .then(function (result) {
                        $scope.pictures = result.pictures;
                    });
        };
        
        $scope.save = function (picture) {
            galleryService
                .updatePicture(picture);
        };
        
        // delete
        $scope.delete = function (pictureId) {
            galleryService
                .deletePicture(galleryId, pictureId)
                .then(function (result) {
                    $scope.pictures = result.pictures;
                });
        };
        
        // new picture functionality
        $scope.upload = function () {
            var uploads = [];
            for(var i = 0; i < $scope.newPictures.length; i++) {
                uploads.push(galleryService.uploadPicture($scope.newPictures[i],
                                                          galleryId));
            }
            
            $q.all(uploads)
                // and merging them
                .then($q.spread(function () {
                    var success = true;
                    for(var i = 0; i < arguments.length; i++) {
                        success = success ? arguments[i].success : false;
                    }
                    
                    $scope.newPictures = [];
                    
                    $scope.load();
                }));
        };
        $scope.newPictures = [];
        
        $rootScope.$on('gallery-loaded', function(event, galleryData) {
            galleryId = galleryData.galleryId;
            
            $scope.load();
        });
        
        $scope.rowCount = function (colCount) {
            if($scope.pictures) {
                return new Array(Math.ceil($scope.pictures.length / colCount));
            }
            else {
                return new Array(0);
            }
        };
    });
}(window.angular));