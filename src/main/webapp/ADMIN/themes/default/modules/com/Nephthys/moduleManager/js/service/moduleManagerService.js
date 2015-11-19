(function (angular) {
    angular.module("moduleManagerAdminService", [])
        .config(window.$QDecorator)
        .service("moduleManagerService", function($http) {
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
                }
            };
        });
}(window.angular));