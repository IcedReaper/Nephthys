nephthysAdminApp
    .controller('galleryDetailCtrl', ["$scope", "$routeParams", "$q", "galleryService", function ($scope, $routeParams, $q, galleryService) {
        $scope.load = function() {
            return galleryService
                       .getDetails($routeParams.galleryId)
                       .then(function (galleryDetails) {
                           $scope.gallery = galleryDetails;
                       });
        };
        
        $scope.save = function () {
            galleryService
                .save($scope.gallery)
                .then(function (result) {
                    $scope.gallery = result;
                })
                .then($scope.loadPictures);
        };
        
        // init
        $scope.load();
        
        $scope.initialized = false;
    }]);