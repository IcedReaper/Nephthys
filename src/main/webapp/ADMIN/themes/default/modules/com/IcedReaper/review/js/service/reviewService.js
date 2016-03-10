nephthysAdminApp
    .service("reviewService", function($http, Upload) {
        return {
            getList: function () {
                return $http.get('/ajax/com/IcedReaper/review/getList');
            },
            
            getDetails: function (reviewId) {
                return $http.get('/ajax/com/IcedReaper/review/getDetails', {
                    params: {
                        reviewId: reviewId
                    }
                });
            },
            
            save: function (review) {
                return $http.post('/ajax/com/IcedReaper/review/save', review);
            },
            
            uploadImage: function (image, reviewId) {
                return Upload.upload({
                    url: '/ajax/com/IcedReaper/review/uploadImage',
                    data: {
                        image:    image,
                        reviewId: reviewId
                    }
                });
            },
            
            delete: function (reviewId) {
                return $http.delete('/ajax/com/IcedReaper/review/delete', {
                    params: {
                        reviewId: reviewId
                    }
                });
            },
            
            loadGenres: function (reviewId) {
                return $http.get('/ajax/com/IcedReaper/review/loadGenres', {
                    params: {
                        reviewId: reviewId
                    }
                });
            },
            
            addGenre: function (reviewId, genreId, name) {
                return $http.post('/ajax/com/IcedReaper/review/addGenre', {
                    reviewId:  reviewId,
                    genreId:   genreId,
                    genreName: name
                });
            },
            
            removeGenre: function (reviewId, genreId) {
                return $http.delete('/ajax/com/IcedReaper/review/removeGenre', {
                    params: {
                        reviewId: reviewId,
                        genreId:  genreId
                    }
                });
            },
            
            loadAutoCompleteGenres: function (queryString) {
                return $http.get('/ajax/com/IcedReaper/review/loadAutoCompleteGenres', {
                    params: {
                        queryString: queryString
                    }
                });
            }
        };
    });