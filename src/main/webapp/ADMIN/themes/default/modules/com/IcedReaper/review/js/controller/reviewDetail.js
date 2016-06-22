nephthysAdminApp
    .controller('reviewDetailCtrl', ["$scope", "$routeParams", "$q", "reviewService", "typeService", function ($scope, $routeParams, $q, reviewService, typeService) {
        $scope.load = function() {
            return $q.all([
                    reviewService.getDetails($routeParams.reviewId),
                    typeService.getList()
                ])
                .then($q.spread(function (reviewDetails, types) {
                    $scope.review = reviewDetails;
                    $scope.types = types;
                }));
        };
        
        $scope.save = function () {
            reviewService
                .save($scope.review)
                .then(function(reviewId) {
                    $scope.review.reviewId = reviewId;
                    
                    if($scope.newImage) {
                        return reviewService.uploadImage($scope.newImage, $scope.review.reviewId);
                    }
                    else {
                        return $q.resolve();
                    }
                })
                .then(function (imagePath) {
                    $scope.review.imagePath = imagePath;
                    $scope.newImage = null;
                });
        };
        
        $scope.imageSelect = function() {
            if($scope.newImage) {
                return $scope.newImage;
            }
            else {
                return $scope.review.imagePath;
            }
        };
        
        // init
        $scope.load();
        
        $scope.reviewId = $routeParams.reviewId;
        $scope.initialized = false;
        $scope.newImage = null;
    }]);