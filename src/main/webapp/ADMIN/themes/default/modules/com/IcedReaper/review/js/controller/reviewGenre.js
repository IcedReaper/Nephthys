nephthysAdminApp
    .controller('reviewGenreCtrl', ["$scope", "$rootScope", "$routeParams", "$q", "reviewService", function ($scope, $rootScope, $routeParams, $q, reviewService) {
        var reviewId = null;
        
        $scope.load = function () {
            return reviewService
                    .loadCategories(reviewId)
                    .then(function (result) {
                        $scope.categories = [];
                        for(var c = 0; c < result.categories.length; c++) {
                            $scope.categories.push({
                                id:   result.categories[c].genreId,
                                text: result.categories[c].name
                            });
                        }
                    });
        };
        
        $scope.add = function (genre) {
            reviewService.addGenre(reviewId, genre.id, genre.text);
        };
        
        $scope.delete = function (genre) {
            reviewService.removeGenre(reviewId, genre.id);
        };
        
        $scope.loadAutoCompleteCategories = function (queryString) {
            return reviewService
                       .loadAutoCompleteCategories(queryString)
                       .then(function (result) {
                           var categories = [];
                           for(var c = 0; c < result.categories.length; c++) {
                               categories.push({
                                   id:   result.categories[c].genreId,
                                   text: result.categories[c].name
                               });
                           }
                           return categories;
                       });
        };
        
        $rootScope.$on('review-loaded', function(event, reviewData) {
            reviewId = reviewData.reviewId;
            
            $scope.load();
        });
    }]);