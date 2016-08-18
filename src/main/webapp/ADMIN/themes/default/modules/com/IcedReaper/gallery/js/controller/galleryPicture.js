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
            var success = true,
                upload = function(index) {
                    if(index < files.length) {
                        galleryService
                            .uploadPicture(files[index],
                                           $routeParams.galleryId)
                            .then(function (suc) {
                                success = success ? suc : false;
                                files[index].result = true;
                                
                                upload(++index);
                            });
                    }
                    else {
                        $scope.load();
                    }
                };
            
            
            upload(0);
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