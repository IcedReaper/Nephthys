nephthysAdminApp
    .controller('galleryDetailCtrl', ["$scope", "$routeParams", "$q", "galleryService", function ($scope, $routeParams, $q, galleryService) {
        $scope.load = function() {
            $q.all([
                galleryService.getDetails($routeParams.galleryId),
                galleryService.getStatus()
            ])
            .then($q.spread(function (galleryDetails, status, availableSubModules, availableOptions, actualUser) {
                $scope.gallery = galleryDetails;
                $scope.status  = status;
            }));
        };
        
        $scope.save = function () {
            galleryService
                .save($scope.gallery)
                .then(function (result) {
                    $scope.gallery = result;
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
        
        // init
        $scope.gallery = {};
        $scope.load();
        
        $scope.initialized = false;
    }]);