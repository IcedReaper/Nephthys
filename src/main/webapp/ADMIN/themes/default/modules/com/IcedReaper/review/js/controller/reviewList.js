nephthysAdminApp
    .controller('reviewListCtrl', ["$scope", "reviewService", function ($scope, reviewService) {
        $scope.delete = function (reviewId) {
            reviewService
                .delete(reviewId)
                .then($scope.refresh);
        };
        
        $scope.refresh = function () {
            reviewService
                .getList()
                .then(function (reviews) {
                    $scope.reviews = reviews;
                });
        };
        
        $scope.reviews = [];
        $scope.search = {
            active: ""
        };
        $scope.refresh();
    }]);