nephthysAdminApp
    .service("typeService", function($http, Upload) {
        return {
            getList: function () {
                return $http.get('/ajax/com/IcedReaper/review/getTypeList');
            },
            
            getDetails: function (typeId) {
                return $http.get('/ajax/com/IcedReaper/review/getTypeDetails', {
                    params: {
                        typeId: typeId
                    }
                });
            },
            
            save: function (type) {
                return $http.post('/ajax/com/IcedReaper/review/saveType', type);
            },
            
            delete: function (typeId) {
                return $http.delete('/ajax/com/IcedReaper/review/deleteType', {
                    params: {
                        typeId: typeId
                    }
                });
            }
        };
    });