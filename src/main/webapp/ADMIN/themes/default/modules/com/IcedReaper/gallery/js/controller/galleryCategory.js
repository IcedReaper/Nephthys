nephthysAdminApp
    .controller('galleryCategoryCtrl', ["$scope", "$routeParams", "$q", "galleryService", function ($scope, $routeParams, $q, galleryService) {
        $scope.load = function () {
            return galleryService
                    .loadCategories($routeParams.galleryId)
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
            galleryService.addCategory($routeParams.galleryId, category.id, category.text);
        };
        
        $scope.delete = function (category) {
            galleryService.removeCategory($routeParams.galleryId, category.id);
        };
        
        $scope.loadAutoCompleteCategories = function (queryString) {
            return galleryService
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
        
        $scope.load();
    }]);