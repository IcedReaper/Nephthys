nephthysAdminApp
    .controller('galleryCategoryCtrl', ["$scope", "$rootScope", "$routeParams", "$q", "galleryService", function ($scope, $rootScope, $routeParams, $q, galleryService) {
        var galleryId = null;
        
        $scope.load = function () {
            return galleryService
                    .loadCategories(galleryId)
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
            galleryService.addCategory(galleryId, category.id, category.text);
        };
        
        $scope.delete = function (category) {
            galleryService.removeCategory(galleryId, category.id);
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
        
        $rootScope.$on('gallery-loaded', function(event, galleryData) {
            galleryId = galleryData.galleryId;
            
            $scope.load();
        });
    }]);