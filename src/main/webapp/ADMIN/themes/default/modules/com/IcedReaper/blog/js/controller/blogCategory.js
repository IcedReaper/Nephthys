nephthysAdminApp
    .controller('blogCategoryCtrl', ["$scope", "$rootScope", "$routeParams", "$q", "blogService", function ($scope, $rootScope, $routeParams, $q, blogService) {
        var blogpostId = null;
        
        $scope.load = function () {
            return blogService
                    .loadCategories(blogpostId)
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
            blogService.addCategory(blogpostId, category.id, category.text);
        };
        
        $scope.delete = function (category) {
            blogService.removeCategory(blogpostId, category.id);
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
        
        $rootScope.$on('blog-loaded', function(event, blogData) {
            blogpostId = blogData.blogpostId;
            
            $scope.load();
        });
    }]);