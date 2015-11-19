(function(angular) {
    angular.module("galleryAdminCategoryService", [])
        .config(window.$QDecorator)
        .service("categoryService", function($http, Upload, $timeout) {
            return {
                getList: function () {
                    return $http.get('/ajax/com/IcedReaper/gallery/getCategoryList');
                },
                
                getDetails: function (categoryId) {
                    return $http.get('/ajax/com/IcedReaper/gallery/getCategoryDetails', {
                        params: {
                            categoryId: categoryId
                        }
                    });
                },
                
                save: function (category) {
                    return $http.post('/ajax/com/IcedReaper/gallery/saveCategory', category);
                },
                
                delete: function (categoryId) {
                    return $http.delete('/ajax/com/IcedReaper/gallery/deleteCategory', {
                        params: {
                            categoryId: categoryId
                        }
                    });
                }
            };
        });
}(window.angular));