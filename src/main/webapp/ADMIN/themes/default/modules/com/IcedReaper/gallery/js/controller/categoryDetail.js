nephthysAdminApp
    .controller('categoryDetailCtrl', ["$scope", "$routeParams", "$route", "$q", "categoryService", function ($scope, $routeParams, $route, $q, categoryService) {
        // load
        $scope.load = function() {
            categoryService
                .getDetails($routeParams.categoryId)
                .then(function (categoryDetails) {
                    $scope.category = categoryDetails;
                });
        };
        
        $scope.save = function () {
            categoryService
                .save({
                    categoryId: $scope.category.categoryId,
                    name:       $scope.category.name
                })
                .then(function (newCategoryId) {
                    if($scope.category.categoryId != newCategoryId) {
                        $scope.category.categoryId = newCategoryId;
                        
                        $route.updateParams({
                            categoryId: newCategoryId
                        });
                    }
                });
        };
        
        // init
        $scope.load();
    }]);