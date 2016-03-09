nephthysAdminApp
    .controller('reviewDetailCtrl', ["$scope", "$rootScope", "$routeParams", "$q", "reviewService", "typeService", function ($scope, $rootScope, $routeParams, $q, reviewService, typeService) {
        var activePage = "detail";
        // load
        $scope.load = function() {
            return $q.all([
                    reviewService.getDetails($routeParams.reviewId),
                    typeService.getList()
                ])
                // and merging them
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
        
        // tabs and paging
        $scope.showPage = function (page) {
            activePage = page;
        };
        
        $scope.tabClasses = function (page) {
            return (activePage === page ? "active" : "");
        };
        
        $scope.pageClasses = function (page) {
            return (activePage === page ? "active" : "");
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
        $scope.load()
              .then($scope.showPage('details'));
        
        $scope.reviewId = $routeParams.reviewId;
        $scope.initialized = false;
        $scope.newImage = null;
    }]);