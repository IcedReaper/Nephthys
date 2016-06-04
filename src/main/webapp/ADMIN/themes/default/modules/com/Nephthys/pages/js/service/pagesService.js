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
            
            save: function (pageId, pageVersion, majorVersion, minorVersion) {
                return $http.post('/ajax/com/Nephthys/pages/save', {
                    pageId: pageId,
                    pageVersion: pageVersion,
                    majorVersion: majorVersion,
                    minorVersion: minorVersion
                });
            },
            
            pushToStatus: function (pageId, pageVersionId, pageStatusId) {
                return $http.post('/ajax/com/Nephthys/pages/pushToStatus', {
                    pageId:        pageId,
                    pageVersionId: pageVersionId,
                    pageStatusId:  pageStatusId
                });
            },
            
            delete: function (pageId) {
                return $http.delete('/ajax/com/Nephthys/pages/delete', {
                    params: {
                        pageId: pageId
                    }
                });
            }/*,
            
            loadStatistics: function (pageId) {
                return $http.get('/ajax/com/Nephthys/pages/loadStatistics', {
                    params: {
                        pageId: pageId
                    }
                });
            }*/,
            
            getStatus: function () {
                return $http.get("/ajax/com/Nephthys/pages/getStatusList");
            },
            
            getAvailableSubModules: function () {
                return $http.get("/ajax/com/Nephthys/pages/getAvailableSubModules");
            },
            
            getAvailableOptions: function () {
                return $http.get("/ajax/com/Nephthys/pages/getAvailableOptions");
            },
            
            getActualUser: function () {
                return $http.get("/ajax/com/Nephthys/pages/getActualUser");
            },
            
            getDetailsForVersion: function (pageId, majorVersion, minorVersion) {
                return $http.get("/ajax/com/Nephthys/pages/getDetailsForVersion", {
                    params: {
                        pageId:       pageId,
                        majorVersion: majorVersion,
                        minorVersion: minorVersion
                    }
                });
            },
            
            getHierarchy: function () {
                return $http.get("/ajax/com/Nephthys/pages/getHierarchy");
            },
            addHierarchyVersion: function () {
                return $http.get("/ajax/com/Nephthys/pages/addHierarchyVersion");
            },
            saveHierarchy: function (hierarchyVersionId, hierarchy) {
                return $http.post("/ajax/com/Nephthys/pages/saveHierarchy", {
                    hierarchyVersionId: hierarchyVersionId,
                    hierarchy:          hierarchy
                });
            },
            pushHierarchyToStatus: function (hierarchyVersionId, pageStatusId) {
                return $http.post("/ajax/com/Nephthys/pages/pushHierarchyToStatus", {
                    hierarchyVersionId: hierarchyVersionId,
                    pageStatusId:       pageStatusId
                });
            }
        };
    });