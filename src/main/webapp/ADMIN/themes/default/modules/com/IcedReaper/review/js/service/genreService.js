nephthysAdminApp
    .service("genreService", function($http, Upload) {
        return {
            getList: function () {
                return $http.get('/ajax/com/IcedReaper/review/getGenreList');
            },
            
            getDetails: function (genreId) {
                return $http.get('/ajax/com/IcedReaper/review/getGenreDetails', {
                    params: {
                        genreId: genreId
                    }
                });
            },
            
            save: function (genre) {
                return $http.post('/ajax/com/IcedReaper/review/saveGenre', genre);
            },
            
            delete: function (genreId) {
                return $http.delete('/ajax/com/IcedReaper/review/deleteGenre', {
                    params: {
                        genreId: genreId
                    }
                });
            }
        };
    });