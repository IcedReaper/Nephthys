nephthysAdminApp
    .service("requestService", function($http) {
        return {
            getList: function (requestId) {
                return $http.get('/ajax/com/IcedReaper/permissionRequest/getList');
            },
            
            getRequest: function (requestId) {
                return $http.get('/ajax/com/IcedReaper/permissionRequest/getRequest', {
                    params: {
                        requestId: requestId
                    }
                });
            },
            
            approve: function (requestId, comment) {
                return $http.post('/ajax/com/IcedReaper/permissionRequest/approve', {
                    requestId: requestId,
                    comment: comment
                });
            },
            
            decline: function (requestId, comment) {
                return $http.post('/ajax/com/IcedReaper/permissionRequest/decline', {
                    requestId: requestId,
                    comment: comment
                });
            }
        };
    });