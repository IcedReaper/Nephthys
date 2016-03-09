nephthysAdminApp
    .controller('genreListCtrl', ["$scope", "genreService", function ($scope, genreService) {
        $scope.delete = function (genreId) {
            genreService
                .delete(genreId)
                .then($scope.refresh);
        }
        
        $scope.refresh = function () {
            genreService
                .getList()
                .then(function (genres) {
                    $scope.genres = genres;
                });
        };
        
        $scope.genres = [];
        $scope.refresh();
    }]);