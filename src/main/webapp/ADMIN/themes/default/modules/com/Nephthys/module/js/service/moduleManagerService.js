nephthysAdminApp
    .service("moduleManagerService", function($http) {
        return {
            getList: function () {
                return $http.get('/ajax/com/Nephthys/module/getList');
            },
            
            getDetails: function (moduleId) {
                return $http.get('/ajax/com/Nephthys/module/getDetails', {
                    params: {
                        moduleId : moduleId
                    }
                });
            },
            
            save: function (module) {
                return $http
                    .post('/ajax/com/Nephthys/module/save',
                          module);
            },
            
            delete: function (moduleId) {
                return $http.delete('/ajax/com/Nephthys/module/delete', {
                    params: {
                        moduleId: moduleId
                    }
                });
            },
            
            activate: function (moduleId) {
                return $http.post('/ajax/com/Nephthys/module/activate', {
                    moduleId: moduleId
                });
            },
            
            deactivate: function (moduleId) {
                return $http.post('/ajax/com/Nephthys/module/deactivate', {
                    moduleId: moduleId
                });
            },
            
            getRoles: function () {
                return $http.get('/ajax/com/Nephthys/module/getRoles');
            },
            
            getUser: function (moduleId) {
                return $http.get('/ajax/com/Nephthys/module/getUser', {
                    params: {
                        moduleId: moduleId
                    }
                });
            },
            
            savePermissions: function  (moduleId, permissions) {
                return $http.post('/ajax/com/Nephthys/module/savePermissions', {
                    moduleId:    moduleId,
                    permissions: permissions
                });
            }
        };
    });