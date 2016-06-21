nephthysAdminApp
    .controller('galleryPictureCtrl', ["$scope", "$routeParams", "$q", "galleryService", function ($scope, $routeParams, $q, galleryService) {
        $scope.load = function () {
            return galleryService
                    .loadPictures($routeParams.galleryId)
                    .then(function (result) {
                        $scope.pictures = result;
                    });
        };
        
        $scope.save = function (picture) {
            galleryService
                .updatePicture(picture);
        };
        
        // delete
        $scope.delete = function (pictureId) {
            galleryService
                .deletePicture($routeParams.galleryId, pictureId)
                .then(function (result) {
                    $scope.pictures = result;
                });
        };
        
        // new picture functionality
        $scope.upload = function () {
            var uploads = [];
            for(var i = 0; i < $scope.newPictures.length; i++) {
                uploads.push(galleryService.uploadPicture($scope.newPictures[i],
                                                          $routeParams.galleryId));
            }
            
            $q.all(uploads)
                // and merging them
                .then($q.spread(function () {
                    var success = true;
                    for(var i = 0; i < arguments.length; i++) {
                        success = success ? arguments[i] : false;
                    }
                    
                    $scope.newPictures = [];
                    
                    $scope.load();
                }));
        };
        $scope.newPictures = [];
        
        $scope.rowCount = function (colCount) {
            if($scope.pictures) {
                return new Array(Math.ceil($scope.pictures.length / colCount));
            }
            else {
                return new Array(0);
            }
        };
        
        $scope.load();
    }]);