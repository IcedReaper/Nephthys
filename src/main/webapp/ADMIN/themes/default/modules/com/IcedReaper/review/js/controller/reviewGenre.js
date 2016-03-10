nephthysAdminApp
    .controller('reviewGenreCtrl', ["$scope", "$rootScope", "$routeParams", "$q", "reviewService", function ($scope, $rootScope, $routeParams, $q, reviewService) {
        var reviewId = null;
        
        $scope.load = function () {
            return reviewService
                .loadGenres(reviewId)
                .then(function (genres) {
                    $scope.genres = [];
                    for(var c = 0; c < genres.length; c++) {
                        $scope.genres.push({
                            id:   genres[c].genreId,
                            text: genres[c].name
                        });
                    }
                });
        };
        
        $scope.add = function (genre) {
            reviewService
                .addGenre(reviewId, genre.id, genre.text)
                .then(function (newGenreId) {
                    if(! genre.id) {
                        genre.id = newGenreId;
                    }
                });
        };
        
        $scope.delete = function (genre) {
            reviewService.removeGenre(reviewId, genre.id);
        };
        
        $scope.loadAutoCompleteGenres = function (queryString) {
            return reviewService
               .loadAutoCompleteGenres(queryString)
               .then(function (genres) {
                   var genreList = [];
                   for(var c = 0; c < genres.length; c++) {
                       genreList.push({
                           id:   genres[c].genreId,
                           text: genres[c].name
                       });
                   }
                   return genreList;
               });
        };
        
        $rootScope.$on('review-loaded', function(event, reviewData) {
            reviewId = reviewData.reviewId;
            
            $scope.load();
        });
    }]);