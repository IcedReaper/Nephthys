(function(angular) {
    angular.module("blogAdminService", [])
        .config(window.$QDecorator)
        .service("blogService", function($http, Upload, $timeout) {
            return {
                getList: function () {
                    return $http.get('/ajax/com/IcedReaper/blog/getList');
                },
                
                getDetails: function (blogId) {
                    return $http.get('/ajax/com/IcedReaper/blog/getDetails', {
                        params: {
                            blogId: blogId
                        }
                    });
                },
                
                save: function (blog) {
                    return $http.post('/ajax/com/IcedReaper/blog/save', blog);
                },
                
                delete: function (blogId) {
                    return $http.delete('/ajax/com/IcedReaper/blog/delete', {
                        params: {
                            blogId: blogId
                        }
                    });
                },
                
                activate: function (blogId) {
                    return $http.post('/ajax/com/IcedReaper/blog/activate', {
                        blogId: blogId
                    });
                },
                
                deactivate: function (blogId) {
                    return $http.post('/ajax/com/IcedReaper/blog/deactivate', {
                        blogId: blogId
                    });
                },
                
                loadPictures: function (blogId) {
                    return $http.get('/ajax/com/IcedReaper/blog/loadPictures', {
                        params: {
                            blogId: blogId
                        }
                    });
                },
                
                loadCategories: function (blogId) {
                    return $http.get('/ajax/com/IcedReaper/blog/loadCategories', {
                        params: {
                            blogId: blogId
                        }
                    });
                },
                
                addCategory: function (blogId, categoryId, name) {
                    return $http.post('/ajax/com/IcedReaper/blog/addCategory', {
                        blogId:    blogId,
                        categoryId:   categoryId,
                        categoryName: name
                    });
                },
                
                removeCategory: function (blogId, categoryId) {
                    return $http.delete('/ajax/com/IcedReaper/blog/removeCategory', {
                        params: {
                            blogId: blogId,
                            categoryId: categoryId
                        }
                    });
                },
                
                loadAutoCompleteCategories: function (queryString) {
                    return $http.get('/ajax/com/IcedReaper/blog/loadAutoCompleteCategories', {
                        params: {
                            queryString: queryString
                        }
                    });
                },
                
                getLastVisitChart: function(blogId, dayCount) {
                    return $http.get('/ajax/com/IcedReaper/blog/getLastVisitChart', {
                        params: {
                            blogId: blogId,
                            dayCount:  dayCount
                        }
                    });
                }
            };
        });
}(window.angular));