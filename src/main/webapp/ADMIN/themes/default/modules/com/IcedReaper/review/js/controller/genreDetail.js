nephthysAdminApp
    .controller('genreDetailCtrl', ["$scope", "$routeParams", "$route", "$q", "genreService", function ($scope, $routeParams, $route, $q, genreService) {
        // load
        $scope.load = function() {
            genreService
                .getDetails($routeParams.genreId)
                .then(function (genre) {
                    $scope.genre = genre;
                });
        };
        
        $scope.save = function () {
            genreService
                .save({
                    genreId: $scope.genre.genreId,
                    name:    $scope.genre.name
                })
                .then(function (newGenreId) {
                    if($scope.genre.genreId != newGenreId) {
                        $scope.genre.genreId = newGenreId;
                        
                        $route.updateParams({
                            genreId: newGenreId
                        });
                    }
                });
        };
        
        // init
        $scope.load();
    }]);