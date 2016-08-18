nephthysAdminApp
    .controller('reviewGenreCtrl', ["$scope", "$routeParams", "$q", "reviewService", function ($scope, $routeParams, $q, reviewService) {
        $scope.load = function () {
            return reviewService
                .loadGenres($routeParams.reviewId)
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
                .addGenre($routeParams.reviewId, genre.id, genre.text)
                .then(function (newGenreId) {
                    if(! genre.id) {
                        genre.id = newGenreId;
                    }
                });
        };
        
        $scope.delete = function (genre) {
            reviewService.removeGenre($routeParams.reviewId, genre.id);
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
    }]);