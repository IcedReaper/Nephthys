nephthysAdminApp
    .service("statusService", function($http) {
        return {
            getList: function () {
                return $http.get('/ajax/com/IcedReaper/blog/getStatusList');
            },
            
            getDetails: function (statusId) {
                return $http.get('/ajax/com/IcedReaper/blog/getStatusDetails', {
                    params: {
                        statusId: statusId
                    }
                });
            },
            
            save: function (status) {
                return $http.post('/ajax/com/IcedReaper/blog/saveStatus', {
                    status: status
                });
            },
            
            delete: function (statusId) {
                return $http.delete('/ajax/com/IcedReaper/blog/deleteStatus', {
                    params: {
                        statusId: statusId
                    }
                });
            },
            
            activate: function (statusId) {
                return $http.post('/ajax/com/IcedReaper/blog/activateStatus', {
                    statusId: statusId
                });
            },
            
            deactivate: function (statusId) {
                return $http.post('/ajax/com/IcedReaper/blog/deactivateStatus', {
                    statusId: statusId
                });
            },
            
            getListAsArray: function () {
                return $http.get('/ajax/com/IcedReaper/blog/getStatusListAsArray');
            },
            
            saveStatusFlow: function (statusFlow) {
                return $http.post("/ajax/com/IcedReaper/blog/saveStatusFlow", {
                    statusFlow: statusFlow
                });
            }
        };
    });