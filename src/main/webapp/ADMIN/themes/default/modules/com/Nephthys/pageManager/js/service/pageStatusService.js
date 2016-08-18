nephthysAdminApp
    .service("statusService", function($http) {
        return {
            getList: function () {
                return $http.get('/ajax/com/Nephthys/pageManager/getStatusList');
            },
            
            getDetails: function (statusId) {
                return $http.get('/ajax/com/Nephthys/pageManager/getStatusDetails', {
                    params: {
                        statusId: statusId
                    }
                });
            },
            
            save: function (status) {
                return $http.post('/ajax/com/Nephthys/pageManager/saveStatus', {
                    status: status
                });
            },
            
            delete: function (statusId) {
                return $http.delete('/ajax/com/Nephthys/pageManager/deleteStatus', {
                    params: {
                        statusId: statusId
                    }
                });
            },
            
            activate: function (statusId) {
                return $http.post('/ajax/com/Nephthys/pageManager/activateStatus', {
                    statusId: statusId
                });
            },
            
            deactivate: function (statusId) {
                return $http.post('/ajax/com/Nephthys/pageManager/deactivateStatus', {
                    statusId: statusId
                });
            },
            
            getListAsArray: function () {
                return $http.get('/ajax/com/Nephthys/pageManager/getStatusListAsArray');
            },
            
            saveStatusFlow: function (statusFlow) {
                return $http.post("/ajax/com/Nephthys/pageManager/saveStatusFlow", {
                    statusFlow: statusFlow
                });
            }
        };
    });