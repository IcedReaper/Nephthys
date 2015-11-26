(function(angular) {
    var categoryDetailCtrl = angular.module('categoryDetailCtrl', ["blogAdminCategoryService"]);
    
    categoryDetailCtrl.controller('categoryDetailCtrl', function ($scope, $routeParams, $q, categoryService) {
        // load
        $scope.load = function() {
            categoryService
                .getDetails($routeParams.categoryId)
                .then(function (categoryDetails) {
                    $scope.category = categoryDetails.data;
                });
        };
        
        $scope.save = function () {
            categoryService
                .save({
                    categoryId: $scope.category.categoryId,
                    name:       $scope.category.name
                })
                .then(function () {
                    if($scope.category.categoryId == 0) {
                        $scope.category.name = "";
                    }
                });
        };
        
        // init
        $scope.load();
    });
}(window.angular));