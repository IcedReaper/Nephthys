(function(angular) {
    var galleryCategoryCtrl = angular.module('galleryCategoryCtrl', ["galleryAdminService"]);
    
    galleryCategoryCtrl.controller('galleryCategoryCtrl', function ($scope, $rootScope, $routeParams, galleryService, $q) {
        var galleryId = null;
        
        $scope.load = function () {
            return galleryService
                    .loadCategories(galleryId)
                    .then(function (result) {
                        $scope.categories = [];
                        for(var c = 0; c < result.categories.length; c++) {
                            $scope.categories.push({
                                id:   result.categories[c].categoryId,
                                text: result.categories[c].name
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
                           for(var c = 0; c < result.categories.length; c++) {
                               categories.push({
                                   id:   result.categories[c].categoryId,
                                   text: result.categories[c].name
                               });
                           }
                           return categories;
                       });
        };
        
        $rootScope.$on('gallery-loaded', function(event, galleryData) {
            galleryId = galleryData.galleryId;
            
            $scope.load();
        });
    });
}(window.angular));