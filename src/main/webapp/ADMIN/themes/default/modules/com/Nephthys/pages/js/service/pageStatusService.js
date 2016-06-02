nephthysAdminApp
    .service("pageStatusService", function($http) {
        return {
            getList: function () {
                return $http.get('/ajax/com/Nephthys/pages/getStatusList');
            },
            
            getDetails: function (pageStatusId) {
                return $http.get('/ajax/com/Nephthys/pages/getStatusDetails', {
                    params: {
                        pageStatusId: pageStatusId
                    }
                });
            },
            
            save: function (pageStatus) {
                return $http.post('/ajax/com/Nephthys/pages/saveStatus', {
                    status: pageStatus
                });
            }/*,
            
            delete: function (pageStatusId) {
                return $http.delete('/ajax/com/Nephthys/pages/deleteStatus', {
                    params: {
                        pageStatusId: pageStatusId
                    }
                });
            },
            
            activate: function (pageStatusId) {
                return $http.post('/ajax/com/Nephthys/pages/activateStatus', {
                    pageStatusId: pageStatusId
                });
            },
            
            deactivate: function (pageStatusId) {
                return $http.post('/ajax/com/Nephthys/pages/deactivateStatus', {
                    pageStatusId: pageStatusId
                });
            }*/
        };
    });