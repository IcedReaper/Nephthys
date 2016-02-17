nephthysAdminApp
    .service("pagesService", function($http) {
        return {
            getList: function () {
                return $http.get('/ajax/com/Nephthys/pages/getList');
            },
            
            getDetails: function (pageId) {
                return $http.get('/ajax/com/Nephthys/pages/getDetails', {
                    params: {
                        pageId: pageId
                    }
                });
            },
            
            save: function (page) {
                return $http.post('/ajax/com/Nephthys/pages/save', page);
            },
            
            delete: function (pageId) {
                return $http.delete('/ajax/com/Nephthys/pages/delete', {
                    params: {
                        pageId: pageId
                    }
                });
            },
            
            activate: function (pageId) {
                return $http.post('/ajax/com/Nephthys/pages/activate', {
                    pageId: pageId
                });
            },
            
            deactivate: function (pageId) {
                return $http.post('/ajax/com/Nephthys/pages/deactivate', {
                    pageId: pageId
                });
            },
            
            loadStatistics: function (pageId) {
                return $http.get('/ajax/com/Nephthys/pages/loadStatistics', {
                    params: {
                        pageId: pageId
                    }
                });
            },
            
            getStatus: function () {
                return $http.get("/ajax/com/Nephthys/pages/getStatusList");
            },
            
            getAvailableSubModules: function () {
                return $http.get("/ajax/com/Nephthys/pages/getAvailableSubModules");
            },
            
            getAvailableOptions: function () {
                return $http.get("/ajax/com/Nephthys/pages/getAvailableOptions");
            }
        };
    });