nephthysAdminApp
    .controller('blogCategoryCtrl', ["$scope", "$routeParams", "$q", "blogService", function ($scope, $routeParams, $q, blogService) {
        $scope.load = function () {
            return blogService
                    .loadCategories($routeParams.blogpostId)
                    .then(function (result) {
                        $scope.categories = [];
                        for(var c = 0; c < result.length; c++) {
                            $scope.categories.push({
                                id:   result[c].categoryId,
                                text: result[c].name
                            });
                        }
                    });
        };
        
        $scope.add = function (category) {
            blogService.addCategory($routeParams.blogpostId, category.id, category.text);
        };
        
        $scope.delete = function (category) {
            blogService.removeCategory($routeParams.blogpostId, category.id);
        };
        
        $scope.loadAutoCompleteCategories = function (queryString) {
            return blogService
                       .loadAutoCompleteCategories(queryString)
                       .then(function (result) {
                           var categories = [];
                           for(var c = 0; c < result.length; c++) {
                               categories.push({
                                   id:   result[c].categoryId,
                                   text: result[c].name
                               });
                           }
                           return categories;
                       });
        };
    }]);