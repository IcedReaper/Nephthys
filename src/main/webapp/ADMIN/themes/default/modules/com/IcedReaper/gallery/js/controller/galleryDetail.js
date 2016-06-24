nephthysAdminApp
    .controller('galleryDetailCtrl', ["$scope", "$routeParams", "$q", "galleryService", function ($scope, $routeParams, $q, galleryService) {
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