(function(angular) {
    angular.module("blogAdminService", [])
        .config(window.$QDecorator)
        .service("blogService", function($http, Upload, $timeout) {
            return {
                getList: function () {
                    return $http.get('/ajax/com/IcedReaper/blog/getList');
                },
                
                getDetails: function (blogpostId) {
                    return $http.get('/ajax/com/IcedReaper/blog/getDetails', {
                        params: {
                            blogpostId: blogpostId
                        }
                    });
                },
                
                save: function (blog) {
                    return $http.post('/ajax/com/IcedReaper/blog/save', blog);
                },
                
                delete: function (blogpostId) {
                    return $http.delete('/ajax/com/IcedReaper/blog/delete', {
                        params: {
                            blogpostId: blogpostId
                        }
                    });
                },
                
                activate: function (blogpostId) {
                    return $http.post('/ajax/com/IcedReaper/blog/activate', {
                        blogpostId: blogpostId
                    });
                },
                
                deactivate: function (blogpostId) {
                    return $http.post('/ajax/com/IcedReaper/blog/deactivate', {
                        blogpostId: blogpostId
                    });
                },
                
                loadPictures: function (blogpostId) {
                    return $http.get('/ajax/com/IcedReaper/blog/loadPictures', {
                        params: {
                            blogpostId: blogpostId
                        }
                    });
                },
                
                loadCategories: function (blogpostId) {
                    return $http.get('/ajax/com/IcedReaper/blog/loadCategories', {
                        params: {
                            blogpostId: blogpostId
                        }
                    });
                },
                
                addCategory: function (blogpostId, categoryId, name) {
                    return $http.post('/ajax/com/IcedReaper/blog/addCategory', {
                        blogpostId:    blogpostId,
                        categoryId:   categoryId,
                        categoryName: name
                    });
                },
                
                removeCategory: function (blogpostId, categoryId) {
                    return $http.delete('/ajax/com/IcedReaper/blog/removeCategory', {
                        params: {
                            blogpostId: blogpostId,
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
                
                getLastVisitChart: function(blogpostId, dayCount) {
                    return $http.get('/ajax/com/IcedReaper/blog/getLastVisitChart', {
                        params: {
                            blogpostId: blogpostId,
                            dayCount:  dayCount
                        }
                    });
                }
            };
        });
}(window.angular));