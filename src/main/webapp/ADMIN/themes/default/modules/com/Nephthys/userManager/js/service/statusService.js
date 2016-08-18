nephthysAdminApp
    .service("statusService", function($http) {
        return {
            getList: function () {
                return $http.get('/ajax/com/Nephthys/userManager/getStatusList');
            },
            
            getDetails: function (statusId) {
                return $http.get('/ajax/com/Nephthys/userManager/getStatusDetails', {
                    params: {
                        statusId: statusId
                    }
                });
            },
            
            save: function (status) {
                return $http.post('/ajax/com/Nephthys/userManager/saveStatus', {
                    status: status
                });
            },
            
            delete: function (statusId) {
                return $http.delete('/ajax/com/Nephthys/userManager/deleteStatus', {
                    params: {
                        statusId: statusId
                    }
                });
            },
            
            activate: function (statusId) {
                return $http.post('/ajax/com/Nephthys/userManager/activateStatus', {
                    statusId: statusId
                });
            },
            
            deactivate: function (statusId) {
                return $http.post('/ajax/com/Nephthys/userManager/deactivateStatus', {
                    statusId: statusId
                });
            },
            
            getListAsArray: function () {
                return $http.get('/ajax/com/Nephthys/userManager/getStatusListAsArray');
            },
            
            saveStatusFlow: function (statusFlow) {
                return $http.post("/ajax/com/Nephthys/userManager/saveStatusFlow", {
                    statusFlow: statusFlow
                });
            }
        };
    });