nephthysAdminApp
    .controller('galleryDetailCtrl', ["$scope", "$routeParams", "$route", "$q", "galleryService", function ($scope, $routeParams, $route, $q, galleryService) {
        $scope.load = function() {
            $q.all([
                galleryService.getDetails($routeParams.galleryId),
                galleryService.getStatus()
            ])
            .then($q.spread(function (galleryDetails, status) {
                $scope.gallery = galleryDetails;
                $scope.status  = status;
            }));
        };
        
        $scope.save = function () {
            galleryService
                .save($scope.gallery)
                .then(function (result) {
                    var oldGalleryId = $scope.gallery.galleryId;
                    $scope.gallery = result;
                    
                    if(oldGalleryId == 0) {
                        $route.updateParams({
                            galleryId: result.galleryId
                        });
                    }
                });
        };
        
        $scope.pushToStatus = function (newStatusId) {
            if(newStatusId) {
                galleryService
                    .pushToStatus($routeParams.galleryId,
                                  newStatusId)
                    .then(function() {
                        $scope.gallery.statusId = newStatusId;
                    });
            }
        };
        
        $scope.statusButtonClass = function (actualOnline, nextOnline) {
            if(! actualOnline && nextOnline) {
                return "btn-success";
            }
            if(actualOnline && ! nextOnline) {
                return "btn-danger";
            }
            if(! actualOnline && ! nextOnline) {
                return "btn-primary";
            }
            if(actualOnline && nextOnline) {
                return "btn-secondary";
            }
            
            return "btn-warning";
        };
        
        // init
        $scope.gallery = {};
        $scope.load();
        
        $scope.initialized = false;
    }]);