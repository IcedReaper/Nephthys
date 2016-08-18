nephthysAdminApp
    .service("statusService", function($http) {
        return {
            getList: function () {
                return $http.get('/ajax/com/IcedReaper/gallery/getStatusList');
            },
            
            getDetails: function (statusId) {
                return $http.get('/ajax/com/IcedReaper/gallery/getStatusDetails', {
                    params: {
                        statusId: statusId
                    }
                });
            },
            
            save: function (status) {
                return $http.post('/ajax/com/IcedReaper/gallery/saveStatus', {
                    status: status
                });
            },
            
            delete: function (statusId) {
                return $http.delete('/ajax/com/IcedReaper/gallery/deleteStatus', {
                    params: {
                        statusId: statusId
                    }
                });
            },
            
            activate: function (statusId) {
                return $http.post('/ajax/com/IcedReaper/gallery/activateStatus', {
                    statusId: statusId
                });
            },
            
            deactivate: function (statusId) {
                return $http.post('/ajax/com/IcedReaper/gallery/deactivateStatus', {
                    statusId: statusId
                });
            },
            
            getListAsArray: function () {
                return $http.get('/ajax/com/IcedReaper/gallery/getStatusListAsArray');
            },
            
            saveStatusFlow: function (statusFlow) {
                return $http.post("/ajax/com/IcedReaper/gallery/saveStatusFlow", {
                    statusFlow: statusFlow
                });
            }
        };
    });