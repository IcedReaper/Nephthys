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
        
        $scope.delete = function (pictureId) {
            galleryService
                .deletePicture($routeParams.galleryId, pictureId)
                .then(function (result) {
                    $scope.pictures = result;
                });
        };
        
        $scope.upload = function (files) {
            var uploads = [];
            for(var i = 0; i < files.length; i++) {
                uploads.push(galleryService.uploadPicture(files[i],
                                                          $routeParams.galleryId));
            }
            
            $q.all(uploads)
                // and merging them
                .then($q.spread(function () {
                    var success = true;
                    for(var i = 0; i < arguments.length; i++) {
                        success = success ? arguments[i] : false;
                        files[i].result = true;
                    }
                    
                    $scope.load();
                }));
        };
        
        $scope.rowCount = function (colCount) {
            if($scope.pictures) {
                return new Array(Math.ceil($scope.pictures.length / colCount));
            }
            else {
                return new Array(0);
            }
        };
        
        $scope.saveSorting = function () {
            galleryService
                .updatePictureSorting($scope.pictures)
                .then(function () {
                    for(var i = 0; i < $scope.pictures.length; ++i) {
                        $scope.pictures[i].sortId = i + 1;
                    }
                });
        }
        
        $scope.load();
    }]);