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
            
            pushToStatus: function (pageId, pageVersionId, statusId) {
                return $http.post('/ajax/com/Nephthys/pages/pushToStatus', {
                    pageId:        pageId,
                    pageVersionId: pageVersionId,
                    statusId:  statusId
                });
            },
            
            delete: function (pageId) {
                return $http.delete('/ajax/com/Nephthys/pages/delete', {
                    params: {
                        pageId: pageId
                    }
                });
            },
            
            getStatus: function () {
                return $http.get("/ajax/com/Nephthys/pages/getStatusList");
            },
            
            getModule: function () {
                return $http.get("/ajax/com/Nephthys/pages/getModule");
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
            
            getSitemap: function () {
                return $http.get("/ajax/com/Nephthys/pages/getSitemap");
            },
            addSitemapVersion: function () {
                return $http.get("/ajax/com/Nephthys/pages/addSitemapVersion");
            },
            saveSitemap: function (sitemap) {
                return $http.post("/ajax/com/Nephthys/pages/saveSitemap", {
                    sitemap: sitemap
                });
            }
        };
    });