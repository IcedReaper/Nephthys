(function(angular) {
    angular.module("galleryAdminService", [])
        .config(window.$QDecorator)
        .service("galleryService", function($http, Upload, $timeout) {
            return {
                getList: function () {
                    return $http.get('/ajax/com/IcedReaper/gallery/getList');
                },
                
                getDetails: function (galleryId) {
                    return $http.get('/ajax/com/IcedReaper/gallery/getDetails', {
                        params: {
                            galleryId: galleryId
                        }
                    });
                },
                
                save: function (gallery) {
                    return $http.post('/ajax/com/IcedReaper/gallery/save', gallery);
                },
                
                delete: function (galleryId) {
                    return $http.delete('/ajax/com/IcedReaper/gallery/delete', {
                        params: {
                            galleryId: galleryId
                        }
                    });
                },
                
                activate: function (galleryId) {
                    return $http.post('/ajax/com/IcedReaper/gallery/activate', {
                        galleryId: galleryId
                    });
                },
                
                deactivate: function (galleryId) {
                    return $http.post('/ajax/com/IcedReaper/gallery/deactivate', {
                        galleryId: galleryId
                    });
                },
                
                loadPictures: function (galleryId) {
                    return $http.get('/ajax/com/IcedReaper/gallery/loadPictures', {
                        params: {
                            galleryId: galleryId
                        }
                    });
                },
                
                loadCategories: function (galleryId) {
                    return $http.get('/ajax/com/IcedReaper/gallery/loadCategories', {
                        params: {
                            galleryId: galleryId
                        }
                    });
                },
                
                addCategory: function (galleryId, categoryId, name) {
                    return $http.post('/ajax/com/IcedReaper/gallery/addCategory', {
                        galleryId:    galleryId,
                        categoryId:   categoryId,
                        categoryName: name
                    });
                },
                
                removeCategory: function (galleryId, categoryId) {
                    return $http.delete('/ajax/com/IcedReaper/gallery/removeCategory', {
                        params: {
                            galleryId: galleryId,
                            categoryId: categoryId
                        }
                    });
                },
                
                loadAutoCompleteCategories: function (queryString) {
                    return $http.get('/ajax/com/IcedReaper/gallery/loadAutoCompleteCategories', {
                        params: {
                            queryString: queryString
                        }
                    });
                },
                
                uploadPicture: function (picture, galleryId) {
                    return Upload.upload({
                        url: '/ajax/com/IcedReaper/gallery/uploadPictures',
                        data: {
                            picture:   picture,
                            galleryId: galleryId
                        },
                    });
                },
                
                updatePicture: function (picture) {
                    return $http.post('/ajax/com/IcedReaper/gallery/updatePicture', picture);
                },
                
                deletePicture: function (galleryId, pictureId) {
                    return $http.delete('/ajax/com/IcedReaper/gallery/deletePicture', {
                        params: {
                            galleryId: galleryId,
                            pictureId: pictureId
                        }
                    });
                }
            };
        });
}(window.angular));