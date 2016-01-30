nephthysAdminApp
    .service("categoryService", function($http, Upload) {
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