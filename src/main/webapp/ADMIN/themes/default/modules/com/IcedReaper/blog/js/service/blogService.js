nephthysAdminApp
    .service("blogService", function($http, $q, Upload) {
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
            
            save: function (blogpost, fileNames) {
                blogpost.fileNames = JSON.stringify(fileNames);
                
                return $http.post('/ajax/com/IcedReaper/blog/save', blogpost);
            },
            
            uploadImages: function (blogpostId, images, imageSizes) {
                if(images.length > 0) {
                    return Upload.upload({
                        url: '/ajax/com/IcedReaper/blog/uploadImages',
                        data: {
                            images:     images,
                            imageSizes: JSON.stringify(imageSizes),
                            blogpostId: blogpostId
                        }
                    });
                }
                else {
                    // return an empty promise
                    return $q.resolve();
                }
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
            
            loadCategories: function (blogpostId) {
                return $http.get('/ajax/com/IcedReaper/blog/loadCategories', {
                    params: {
                        blogpostId: blogpostId
                    }
                });
            },
            
            addCategory: function (blogpostId, categoryId, name) {
                return $http.post('/ajax/com/IcedReaper/blog/addCategory', {
                    blogpostId:   blogpostId,
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
            
            loadComments: function (blogpostId) {
                return $http.get('/ajax/com/IcedReaper/blog/loadComments', {
                    params: {
                        blogpostId: blogpostId
                    }
                });
            },
            
            deleteComment: function (commentId) {
                return $http.delete('/ajax/com/IcedReaper/blog/deleteComment', {
                    params: {
                        commentId: commentId
                    }
                });
            },
            
            publishComment: function (commentId) {
                return $http.post('/ajax/com/IcedReaper/blog/publishComment', {
                    commentId: commentId
                });
            },
            
            getLastVisitChart: function(blogpostId, dayCount) {
                return $http.get('/ajax/com/IcedReaper/blog/getLastVisitChart', {
                    params: {
                        blogpostId: blogpostId,
                        dayCount:   dayCount
                    }
                });
            }
        };
    });