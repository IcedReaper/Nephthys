nephthysAdminApp
    .service("moduleService", function($http) {
        return {
            getList: function () {
                return $http.get('/ajax/com/Nephthys/moduleManager/getList');
            },
            
            getDetails: function (moduleId) {
                return $http.get('/ajax/com/Nephthys/moduleManager/getDetails', {
                    params: {
                        moduleId : moduleId
                    }
                });
            },
            
            save: function (module) {
                return $http
                    .post('/ajax/com/Nephthys/moduleManager/save',
                          module);
            },
            
            delete: function (moduleId) {
                return $http.delete('/ajax/com/Nephthys/moduleManager/delete', {
                    params: {
                        moduleId: moduleId
                    }
                });
            },
            
            activate: function (moduleId) {
                return $http.post('/ajax/com/Nephthys/moduleManager/activate', {
                    moduleId: moduleId
                });
            },
            
            deactivate: function (moduleId) {
                return $http.post('/ajax/com/Nephthys/moduleManager/deactivate', {
                    moduleId: moduleId
                });
            },
            
            getRoles: function () {
                return $http.get('/ajax/com/Nephthys/moduleManager/getRoles');
            },
            
            getUser: function (moduleId) {
                return $http.get('/ajax/com/Nephthys/moduleManager/getUser', {
                    params: {
                        moduleId: moduleId
                    }
                });
            },
            
            savePermissions: function  (moduleId, permissions) {
                return $http.post('/ajax/com/Nephthys/moduleManager/savePermissions', {
                    moduleId:    moduleId,
                    permissions: permissions
                });
            },
            
            getOptions: function (moduleId) {
                return $http.get('/ajax/com/Nephthys/moduleManager/getOptions', {
                    params: {
                        moduleId: moduleId
                    }
                });
            },
            
            getSubModules: function (moduleId) {
                return $http.get('/ajax/com/Nephthys/moduleManager/getSubModules', {
                    params: {
                        moduleId: moduleId
                    }
                });
            },
            
            getUnusedSubModules: function (moduleId) {
                return $http.get('/ajax/com/Nephthys/moduleManager/getUnusedSubModules', {
                    params: {
                        moduleId: moduleId
                    }
                });
            },
            
            addSubModules: function (moduleId, addedSubModules) {
                return $http.post('/ajax/com/Nephthys/moduleManager/addSubModules', {
                    moduleId:   moduleId,
                    subModules: addedSubModules
                });
            },
            
            removeSubModules: function (moduleId, removedSubModules) {
                return $http.post('/ajax/com/Nephthys/moduleManager/removeSubModules', {
                    moduleId:   moduleId,
                    subModules: removedSubModules
                });
            }
        };
    });