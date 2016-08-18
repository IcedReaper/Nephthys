nephthysAdminApp
    .controller('blogpostPictureCtrl', ["$scope", "$routeParams", "$q", "blogService", function ($scope, $routeParams, $q, blogService) {
        $scope.load = function () {
            return blogService
                    .loadPictures($routeParams.blogpostId)
                    .then(function (result) {
                        $scope.pictures = result;
                    });
        };
        
        $scope.save = function (pictureDetails) {
            blogService
                .updatePicture($routeParams.blogpostId, pictureDetails);
        };
        
        $scope.delete = function (pictureId) {
            blogService
                .deletePicture($routeParams.blogpostId, pictureId)
                .then(function (result) {
                    $scope.pictures = result;
                });
        };
        
        $scope.upload = function (files) {
            var success = true,
                upload = function(index) {
                    if(index < files.length) {
                        blogService
                            .uploadPicture(files[index],
                                           $routeParams.blogpostId)
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
            blogService
                .updatePictureSorting($routeParams.blogpostId, $scope.pictures)
                .then(function () {
                    for(var i = 0; i < $scope.pictures.length; ++i) {
                        $scope.pictures[i].sortId = i + 1;
                    }
                });
        }
        
        $scope.load();
    }]);