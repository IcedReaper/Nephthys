(function(angular) {
    angular.module("blogAdminCategoryService", [])
        .config(window.$QDecorator)
        .service("categoryService", function($http, Upload, $timeout) {
            return {
                getList: function () {
                    return $http.get('/ajax/com/IcedReaper/blog/getCategoryList');
                },
                
                getDetails: function (categoryId) {
                    return $http.get('/ajax/com/IcedReaper/blog/getCategoryDetails', {
                        params: {
                            categoryId: categoryId
                        }
                    });
                },
                
                save: function (category) {
                    return $http.post('/ajax/com/IcedReaper/blog/saveCategory', category);
                },
                
                delete: function (categoryId) {
                    return $http.delete('/ajax/com/IcedReaper/blog/deleteCategory', {
                        params: {
                            categoryId: categoryId
                        }
                    });
                }
            };
        });
}(window.angular));