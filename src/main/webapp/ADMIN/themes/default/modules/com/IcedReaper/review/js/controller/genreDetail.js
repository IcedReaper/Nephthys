nephthysAdminApp
    .controller('genreDetailCtrl', ["$scope", "$routeParams", "$q", "genreService", function ($scope, $routeParams, $q, genreService) {
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
                .then(function () {
                    if($scope.genre.genreId == 0) {
                        $scope.genre.name = "";
                    }
                });
        };
        
        // init
        $scope.load();
    }]);