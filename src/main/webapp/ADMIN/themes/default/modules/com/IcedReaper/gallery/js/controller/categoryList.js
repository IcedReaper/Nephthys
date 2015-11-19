(function(angular) {
    var categoryListCtrl = angular.module('categoryListCtrl', ["galleryAdminCategoryService"]);
    
    categoryListCtrl.controller('categoryListCtrl', function ($scope, categoryService) {
        $scope.delete = function (categoryId) {
            categoryService
                .delete(categoryId)
                .then($scope.refresh);
        }
        
        $scope.refresh = function () {
            categoryService
                .getList()
                .then(function (categories) {
                    $scope.categories = categories.data;
                });
        };
        
        $scope.categories = [];
        $scope.refresh();
    });
}(window.angular));