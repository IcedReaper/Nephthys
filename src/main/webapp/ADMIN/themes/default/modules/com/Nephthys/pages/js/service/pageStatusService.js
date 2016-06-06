nephthysAdminApp
    .service("statusService", function($http) {
        return {
            getList: function () {
                return $http.get('/ajax/com/Nephthys/pages/getStatusList');
            },
            
            getDetails: function (statusId) {
                return $http.get('/ajax/com/Nephthys/pages/getStatusDetails', {
                    params: {
                        statusId: statusId
                    }
                });
            },
            
            save: function (status) {
                return $http.post('/ajax/com/Nephthys/pages/saveStatus', {
                    status: status
                });
            },
            
            delete: function (statusId) {
                return $http.delete('/ajax/com/Nephthys/pages/deleteStatus', {
                    params: {
                        statusId: statusId
                    }
                });
            },
            
            activate: function (statusId) {
                return $http.post('/ajax/com/Nephthys/pages/activateStatus', {
                    statusId: statusId
                });
            },
            
            deactivate: function (statusId) {
                return $http.post('/ajax/com/Nephthys/pages/deactivateStatus', {
                    statusId: statusId
                });
            },
            
            getListAsArray: function () {
                return $http.get('/ajax/com/Nephthys/pages/getStatusListAsArray');
            },
            
            saveStatusFlow: function (statusFlow) {
                return $http.post("/ajax/com/Nephthys/pages/saveStatusFlow", {
                    statusFlow: statusFlow
                });
            }
        };
    });